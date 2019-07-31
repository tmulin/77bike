import 'package:flutter/material.dart';
import 'package:qiqi_bike/api/mobcent_client.dart';
import 'package:qiqi_bike/common/data_helper.dart';
import 'package:qiqi_bike/core/application.dart';
import 'package:qiqi_bike/models/forum/forum_search.dart';
import 'package:qiqi_bike/views/topic_page.dart';
import 'package:qiqi_bike/widgets/topic_list_ending.dart';
import 'package:scoped_model/scoped_model.dart';

import '../index_page.dart';

class UserRepliesPage extends StatefulWidget {
  final int userId;

  UserRepliesPage({@required this.userId});

  @override
  _UserRepliesPageState createState() => _UserRepliesPageState();
}

class _UserRepliesPageState extends State<UserRepliesPage> {
  ScrollController _scrollController;
  _DataSource _dataSource;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _dataSource = _DataSource("用户回复列表", userId: widget.userId);
    _dataSource.loadMore().then((value) {
      if (!value) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(_dataSource.message)));
      }
    });

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        print("ScrollController Reach Bottom , loadMore ...");
        if (_dataSource.hasMore())
          _dataSource.loadMore().then((value) {
            if (!value) {
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text(_dataSource.message)));
            }
          });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(context),
      body: _buildResultView(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final String title =
        widget.userId == ApplicationCore.session.uid ? "我" : "Ta";
    return AppBar(
      title: Text("${title}回复的帖子"),
    );
  }

  Widget _buildResultView(BuildContext context) {
    return ScopedModel(
      model: _dataSource,
      child: ScopedModelDescendant<_DataSource>(
        builder: (context, child, model) {
          print("ScopedModelDescendant ${model.name} build ...");

          final itemCount = model.items.length + 1;

          return RefreshIndicator(
            onRefresh: () {
              return model.reload();
            },
            child: ListView.separated(
              physics: AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              itemCount: itemCount,
              itemBuilder: (context, index) {
                if (index == itemCount - 1) {
                  // 构建结尾
                  return TopicListEnding(
                      _dataSource.hasMore(), _dataSource.isLoading(), () {
                    _dataSource.loadMore().then((value) {
                      if (!value) {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                            behavior: SnackBarBehavior.floating,
                            content: Text(_dataSource.message)));
                      }
                    });
                  });
                }
                return _buildTopicItemView(context, index, model.items[index]);
              },
              separatorBuilder: (context, index) => Divider(height: 0),
            ),
          );
        },
      ),
    );
  }

  _buildTopicItemView(BuildContext context, int index, SearchTopic model) {
    final textTheme = Theme.of(context).textTheme;
    final itemWidget = Container(
      color: Colors.white,
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(model.title, style: textTheme.subhead),
          Text(model.subject,
              style: textTheme.body1.copyWith(color: textTheme.caption.color)),
          Row(
            children: <Widget>[
              Text(model.user_nick_name, style: textTheme.caption),
              Spacer(),
              IconWithLabel(
                  onPressed: () {},
                  icon: Icon(Icons.remove_red_eye,
                      color: Colors.grey.shade400, size: 18),
                  label: Text(model.hits.toString(), style: textTheme.caption)),
              IconWithLabel(
                  onPressed: () {},
                  icon: Icon(Icons.chat_bubble,
                      color: Colors.grey.shade400, size: 18),
                  label:
                      Text(model.replies.toString(), style: textTheme.caption)),
              Container(width: 32),
              Text(
                  DataHelper.toDateTimeOffsetString(
                      model.last_reply_date_value),
                  style: textTheme.caption),
            ],
          )
        ],
      ),
    );

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TopicPage(
                  boardId: model.board_id,
                  topicId: model.topic_id,
                  title: model.title,
                )));
      },
      child: itemWidget,
    );
  }
}

class _DataSource extends Model {
  final int userId;

  /// 数据源名称
  final String name;

  _DataSource(this.name, {@required this.userId});

  int _itemCount = 0;
  List<SearchTopic> _items = [];

  int get itemCount => _itemCount;

  List<SearchTopic> get items => _items;

  bool _loading = false;
  int _hasMore = 1;
  int _nextPage = 1;
  String _message;

  /// 错误信息
  String get message => _message;

  bool hasMore() {
    return _hasMore > 0;
  }

  bool isLoading() => _loading;

  Future<bool> loadMore({bool clear = false}) async {
    if (_loading) {
      print("DataSource ${name} | U:${userId} loading in progress, ignore ...");
      return true;
    }
    _loading = true;
    this._message = null;
    notifyListeners();
    print("DataSource ${name} | U:${userId}  loading ...");
    try {
      var response = await MobcentClient.instance
          .userReplyList(this.userId, page: _nextPage, pageSize: 20);
      if (!response.noError) {
        this._message = response.head.errInfo;
        notifyListeners();
        return false;
      }
      print(
          "DataSource ${name} | U:${userId} loadMore => GOT ${response.list?.length} Topics ...");

      if (clear) {
        this._items.clear();
      }

      /// 页码+1
      this._nextPage++;
      this._hasMore = response.has_next;
      this._itemCount = response.total_num ?? 0;
      this._items.addAll(response.list ?? []);
      notifyListeners();
    } finally {
      _loading = false;
    }
    return true;
  }

  Future<bool> reload() async {
    this._hasMore = 1;
    this._nextPage = 1;
    this._itemCount = 0;
    return await this.loadMore(clear: true);
  }
}
