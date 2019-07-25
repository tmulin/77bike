import 'package:flutter/material.dart';
import 'package:qiqi_bike/api/mobcent_client.dart';
import 'package:qiqi_bike/core/application.dart';
import 'package:qiqi_bike/core/messages.dart';
import 'package:qiqi_bike/models/message/message_pmsessionlist.dart';
import 'package:qiqi_bike/widgets/user_avatar_widget.dart';
import 'package:scoped_model/scoped_model.dart';

import '../master_page.dart';
import 'message_notifies_page.dart';

class MessagePage extends StatefulWidget {
  PageRefreshController controller;

  MessagePage({this.controller});

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  _DataSource _dataSource;
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();

    widget.controller?.addListener(_refreshPage);

    _dataSource = _DataSource("站内信");
    _dataSource.reload();
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller?.removeListener(_refreshPage);
  }

  void _refreshPage() {
    if (_refreshIndicatorKey?.currentState?.mounted ?? false)
      _refreshIndicatorKey?.currentState?.show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("消息"),
        centerTitle: true,
      ),
      body: _buildPageBody(context),
    );
  }

  _buildPageBody(BuildContext context) {
    final itemCount = _dataSource.items.length + 1;

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () {
        return _dataSource.reload();
      },
      child: ListView.separated(
        itemCount: itemCount,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildMenuItems(context);
          }
          return _buildPmSessionItem(context, _dataSource.items[index - 1]);
        },
        separatorBuilder: (context, index) => Divider(height: 0),
      ),
    );
  }

  _buildMenuItem(BuildContext context,
      {String title,
      int badgeValue = 0,
      IconData icon,
      Color bgColor,
      Widget trailing,
      Widget route}) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration:
            BoxDecoration(color: bgColor ?? Theme.of(context).primaryColorDark),
        child: Center(child: Icon(icon, color: Colors.white, size: 24)),
      ),
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (badgeValue > 0)
            Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(20)),
                child: Center(
                  child: Text(badgeValue.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                )),
          trailing ??
              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade400,
              ),
        ],
      ),
      onTap: route == null
          ? null
          : () async {
              await Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => route));

              /// 路由跳转返回之后,重新检查消息
              ApplicationCore.checkMessages();
            },
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        ScopedModelDescendant<MessagesModel>(
            builder: (context, _, messages) => _buildMenuItem(context,
                title: "提到我的",
                badgeValue: messages.atMeInfo.count,
                icon: Icons.alternate_email,
                bgColor: Colors.amber.shade500)),
        Divider(height: 0),
        ScopedModelDescendant<MessagesModel>(
            builder: (context, _, messages) => _buildMenuItem(context,
                title: "评论",
                badgeValue: messages.replyInfo.count,
                icon: Icons.comment,
                bgColor: Colors.blue.shade500,
                route: MessageNotifiesPage())),
        Divider(height: 0),
        ScopedModelDescendant<MessagesModel>(
            builder: (context, _, messages) => _buildMenuItem(context,
                title: "好友",
                badgeValue: messages.friendInfo.count,
                icon: Icons.person_add,
                bgColor: Colors.redAccent)),
        Divider(height: 0)
      ],
    );
  }

  Widget _buildPmSessionItem(BuildContext context, PmSession pmSession) {
    return ListTile(
      leading: UserAvatarWidget(
        pmSession.toUserAvatar,
        width: 40,
        height: 40,
        borderRadius: 4,
      ),
      dense: true,
      title: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        child: Text(pmSession.toUserName),
      ),
      subtitle: Text(pmSession.lastSummary, overflow: TextOverflow.ellipsis),
    );
  }
}

class _DataSource extends Model {
  /// 数据源名称
  final String name;

  int _itemCount = 0;
  List<PmSession> _items = [];

  _DataSource(this.name);

  int get itemCount => _itemCount;

  List<PmSession> get items => _items;

  int _hasMore = 1;
  int _nextPage = 1;
  bool _loading = false;

  bool isLoading() => _loading;

  bool hasMore() {
    return _hasMore > 0;
  }

  Future<bool> loadMore({bool clear = false}) async {
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
      var response =
          await MobcentClient.instance.messageListPmSession(page: _nextPage);
      if (!response.noError) {
        notifyListeners();
        return false;
      }
      print(
          "DataSource ${name} | P:${_nextPage} loadMore => GOT ${response.body?.list?.length} Topics ...");

      /// 刷新数据源时,清除旧数据(在刷新成功之后再清除旧数据,避免先清空数据导致的页面闪烁)
      if (clear) {
        this._items.clear();
      }

      /// 页码+1
      this._nextPage++;
      this._itemCount = (response.total_num ?? 1) - 1;
      this._items.addAll(response.body?.list ?? []);
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
    return await this.loadMore(clear: true);
  }
}
