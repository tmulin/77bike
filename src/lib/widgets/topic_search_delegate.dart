import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qiqi_bike/api/mobcent_client.dart';
import 'package:qiqi_bike/common/data_helper.dart';
import 'package:qiqi_bike/models/forum/forum_search.dart';
import 'package:qiqi_bike/views/board_page.dart';
import 'package:qiqi_bike/views/topic_page.dart';
import 'package:qiqi_bike/widgets/topic_image_widget.dart';
import 'package:qiqi_bike/widgets/topic_list_ending.dart';
import 'package:scoped_model/scoped_model.dart';

class TopicSearchDelegate extends SearchDelegate<String> {
  List<String> suggestions = <String>[
    "公路车",
    "451",
    "功率计",
    "爬坡",
    "牙盘",
    "变速",
    "轮组",
    "花鼓"
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      CupertinoButton(
        child: Text(
          "取消",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        onPressed: () {
          this.close(context, null);
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return Icon(Icons.search);
  }

  SearchResultListView _resultView;

  @override
  Widget buildResults(BuildContext context) {
    print("buildResults::Search => ${query}");
    print("buildResults::QueryString => ${_resultView?.queryString}");

    if (_resultView?.queryString != query) {
      // _resultView = null;
    }
    if (_resultView == null)
      _resultView = SearchResultListView(this.query,
          key: GlobalKey(debugLabel: this.query));

    return _resultView;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.separated(
      itemCount: suggestions.length,
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          // this.close(context, suggestions[index]);
          this.query = suggestions[index];
          this.showResults(context);
        },
        title: Text(suggestions[index]),
      ),
      separatorBuilder: (context, index) => Divider(height: 0),
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    var theme = Theme.of(context).copyWith(
      textTheme: Theme.of(context).textTheme.copyWith(
            title: TextStyle(color: Colors.white, fontSize: 18),
          ),
    );
    return theme;
  }
}

class _DataSource extends Model {
  final int boardId;
  final int filterId;
  final String sortBy;

  /// 数据源名称
  final String name;

  _DataSource(this.name, {this.boardId = 0, this.filterId = 0, this.sortBy});

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

  Future<bool> loadMore() async {
    if (_loading) {
      print(
          "DataSource ${name} | B:${boardId} F:${filterId} P:${_nextPage} S:${sortBy} loading in progress, ignore ...");
      return true;
    }
    _loading = true;
    notifyListeners();
    print(
        "DataSource ${name} | B:${boardId} F:${filterId} P:${_nextPage} S:${sortBy} loading ...");
    try {
      var response = await MobcentClient.instance
          .forumSearch(this.name, page: _nextPage, pageSize: 10);
      if (!response.noError) {
        this._message = response.head.errInfo;
        notifyListeners();
        return false;
      }
      print(
          "DataSource ${name} | B:${boardId} F:${filterId} P:${_nextPage} S:${sortBy} loadMore => GOT ${response.list?.length} Topics ...");

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
    this._items.clear();
    return await this.loadMore();
  }
}

class SearchResultListView extends StatefulWidget {
  final String queryString;

  SearchResultListView(this.queryString, {Key key}) : super(key: key) {
    print("SearchResultListView::New Instance => ${this.queryString} ...");
  }

  @override
  _SearchResultListViewState createState() => _SearchResultListViewState();
}

class _SearchResultListViewState extends State<SearchResultListView> {
  ScrollController _scrollController;
  String queryString;
  _DataSource _dataSource;

  @override
  void initState() {
    super.initState();

    queryString = widget.queryString;

    print("_SearchResultListViewState::initState => ${widget.queryString}");

    _dataSource = _DataSource(widget.queryString);
    _dataSource.loadMore().then((value) {
      if (!value) {
        Scaffold.of(context).showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(_dataSource.message)));
      }
    });

    print("_SearchResultListViewState::initState ++");

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        print("ScrollController Reach Bottom , loadMore ...");
        _dataSource.loadMore();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    print("_SearchResultListViewState::dispose ++");
  }

  @override
  void didUpdateWidget(SearchResultListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    print(
        "_SearchResultListViewState::didUpdateWidget : ${oldWidget.queryString} => ${widget.queryString}");
    if (widget.queryString != _dataSource.name) {
      _dataSource = _DataSource(widget.queryString);
      _dataSource.loadMore().then((value) {
        if (!value) {
          Scaffold.of(context).showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(_dataSource.message)));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              // controller: _scrollController,
              itemCount: itemCount,
              itemBuilder: (context, index) {
                if (index == itemCount - 1) {
                  // 构建结尾
                  return TopicListEnding(
                      _dataSource.hasMore(), _dataSource.isLoading(), () {
                    _dataSource.loadMore().then((value) {
                      if (!value) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                            behavior: SnackBarBehavior.floating,
                            content: Text(_dataSource.message)));
                      }
                    });
                  });
                }
                return _buildTopicItemView(context, index, model.items[index]);
              },
            ),
          );
        },
      ),
    );
  }

  _buildTopicItemView(BuildContext context, int index, SearchTopic model) {
    final imgUrl = model.pic_path
        ?.replaceAll("/mobcent/app/runtime/images/xgsize/", "/attachment/");
    final image = DataHelper.isIsNullOrWhiteSpaceString(imgUrl)
        ? null
        : Container(
            width: MediaQuery.of(context).size.width / 4 - 8,
            padding: EdgeInsets.only(right: 8),
            child: TopicImageWidget(imgUrl, aspectRatio: 1),
          );
    var widget = Container(
      constraints: BoxConstraints(minHeight: 120),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _builtTopicTitleWidget(context, model),
                    // _buildUserDetailWidgetMini(context, model),
                    _buildTopicContentWidget(context, model),
                  ],
                ),
              ),
              if (image != null) image
            ],
          ),
          _buildTopicBottomWidget(context, model),
        ],
      ),
    );

    return Container(
      margin: EdgeInsets.only(top: 8),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TopicPage(
                      boardId: model.board_id,
                      topicId: model.topic_id,
                      title: model.title,
                    )));
          },
          child: widget,
        ),
      ),
    );
  }

  _builtTopicTitleWidget(BuildContext context, SearchTopic model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text(
        model.title,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  _buildTopicContentWidget(BuildContext context, SearchTopic model,
      {Widget suffix}) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text(
        model.subject,
        style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
      ),
    );

    if (suffix == null) {
      return content;
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[Expanded(child: content), suffix],
      );
    }
  }

  _buildTopicBottomWidget(BuildContext context, SearchTopic model) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: <Widget>[
          Text(
            model.user_nick_name,
            style: TextStyle(color: Theme.of(context).primaryColorDark),
          ),
          Spacer(),
          Text(
            DataHelper.toDateTimeOffsetString(model.last_reply_date_value),
            style: TextStyle(color: Theme.of(context).hintColor, fontSize: 13),
          ),
          IconWithLabel(
              onPressed: () {},
              icon: Icon(
                Icons.remove_red_eye,
                color: Colors.grey.shade400,
                size: 18,
              ),
              label: Text(
                model.hits.toString(),
                style:
                    TextStyle(color: Theme.of(context).hintColor, fontSize: 13),
              )),
          IconWithLabel(
              onPressed: () {},
              icon: Icon(
                Icons.chat_bubble,
                color: Colors.grey.shade400,
                size: 18,
              ),
              label: Text(
                model.replies.toString(),
                style:
                    TextStyle(color: Theme.of(context).hintColor, fontSize: 13),
              )),
        ],
      ),
    );
  }
}

class KeepAliveFutureBuilder extends StatefulWidget {
  final Future future;
  final AsyncWidgetBuilder builder;

  KeepAliveFutureBuilder({this.future, this.builder});

  @override
  _KeepAliveFutureBuilderState createState() => _KeepAliveFutureBuilderState();
}

class _KeepAliveFutureBuilderState extends State<KeepAliveFutureBuilder>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.future,
      builder: widget.builder,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
