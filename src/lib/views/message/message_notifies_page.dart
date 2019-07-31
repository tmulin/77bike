import 'package:flutter/material.dart';
import 'package:qiqi_bike/api/mobcent_client.dart';
import 'package:qiqi_bike/common/data_helper.dart';
import 'package:qiqi_bike/models/message/message_notifylist.dart';
import 'package:qiqi_bike/widgets/user_avatar_widget.dart';
import 'package:scoped_model/scoped_model.dart';

import '../topic_page.dart';

class MessageNotifiesPage extends StatefulWidget {
  final String type;
  final String title;

  MessageNotifiesPage({this.type = "post", this.title = "评论"});

  @override
  _MessageNotifiesPageState createState() => _MessageNotifiesPageState();
}

class _MessageNotifiesPageState extends State<MessageNotifiesPage> {
  _DataSource _dataSource;

  @override
  void initState() {
    super.initState();
    _dataSource = _DataSource(widget.title, type: widget.type);
    _dataSource.reload().then((value) {
      print(
          "MessageNotifiesPage::load => ${value} :: ${_dataSource.items.length}");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: _buildPageBody(context),
    );
  }

  _buildPageBody(BuildContext context) {
    final itemCount = _dataSource.items.length;

    return RefreshIndicator(
      onRefresh: () {
        return _dataSource.reload().then((value) {
          setState(() {});
        });
      },
      child: ListView.separated(
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return _buildNotifyItem(context, _dataSource.items[index]);
        },
        separatorBuilder: (context, index) => Divider(height: 0),
      ),
    );
  }

  Widget _buildNotifyItem(BuildContext context, Notify notify) {
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => TopicPage(
                    boardId: notify.board_id,
                    topicId: notify.topic_id,
                    title: notify.topic_subject,
                  )));
        },
        child: Container(
          color: Colors.white,
          margin: EdgeInsets.only(bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ListTile(
                leading: UserAvatarWidget(
                  notify.icon,
                  width: 40,
                  height: 40,
                  borderRadius: 4,
                ),
                dense: true,
                title: Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 4),
                  child: Text(notify.reply_nick_name),
                ),
                subtitle: Text(DataHelper.toDateTimeOffsetString(
                    notify.replied_date_value)),
              ),
              Divider(height: 0),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  notify.reply_content?.trim(),
                  softWrap: false,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.grey.shade300),
                child: Text(
                  notify.topic_content?.trim(),
                  softWrap: false,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _DataSource extends Model {
  /// 数据源名称
  final String name;
  final String type;

  int _itemCount = 0;
  List<Notify> _items = [];

  _DataSource(this.name, {@required this.type});

  int get itemCount => _itemCount;

  List<Notify> get items => _items;

  int _hasMore = 1;
  int _nextPage = 1;
  bool _loading = false;

  bool isLoading() => _loading;

  bool hasMore() {
    return _hasMore > 0;
  }

  Future<bool> loadMore() async {
    if (_loading) {
      print(
          "DataSource ${name} | P:${_nextPage} loading in progress, ignore ...");
      return true;
    }

    print(
        "DataSource ${name} | P:${_nextPage} TOTAL ${itemCount} / ${this.items.length} | HAS MORE => ${this.hasMore()}");

    if (this.itemCount > 0 && this.itemCount == this.items.length) {
      print("DataSource ${name} | P:${_nextPage} all loaded !");
      return true;
    }

    _loading = true;

    /// 正在加载
    notifyListeners();

    print("DataSource ${name} | P:${_nextPage} loading ...");
    try {
      var response = await MobcentClient.instance
          .messageListNotify(page: _nextPage, type: this.type);
      if (!response.noError) {
        notifyListeners();
        return false;
      }
      print(
          "DataSource ${name} | P:${_nextPage} loadMore => GOT ${response.list?.length} Topics ...");

      /// 页码+1
      this._nextPage++;

      this._itemCount = response?.list?.length ?? 0;
      this._items.addAll(response?.list ?? []);
      this._hasMore = response.has_next;
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
