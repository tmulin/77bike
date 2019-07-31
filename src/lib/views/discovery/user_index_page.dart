import 'package:flutter/material.dart';
import 'package:qiqi_bike/api/mobcent_client.dart';
import 'package:qiqi_bike/core/application.dart';
import 'package:qiqi_bike/models/common.dart';
import 'package:qiqi_bike/models/user/user_userinfo.dart';
import 'package:qiqi_bike/views/discovery/user_albums_page.dart';
import 'package:qiqi_bike/views/discovery/user_replices_page.dart';
import 'package:qiqi_bike/views/discovery/user_topics_page.dart';
import 'package:qiqi_bike/views/message/message_chat_page.dart';
import 'package:qiqi_bike/widgets/user_avatar_widget.dart';

import '../webview_page.dart';

class UserIndexPage extends StatefulWidget {
  final int userId;

  final String userName;

  final String userAvatar;

  UserIndexPage({this.userId, this.userName, this.userAvatar});

  @override
  _UserIndexPageState createState() => _UserIndexPageState();
}

class _UserIndexPageState extends State<UserIndexPage> {
  UserInfoResponse _userInfo;

  Future<void> reloadUserInfo() async {
    MobcentClient.instance.userGetUserInfo(widget.userId).then((response) {
      if (response.noError) {
        setState(() {
          _userInfo = response;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    reloadUserInfo();
  }

  Future<dynamic> addFirend() async {
    final String url = ApplicationCore.buildActionUrl("user/useradminview",
        extParameters: {"uid": "${widget.userId}", "act": "add"});
    await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => WebViewPage(
              url: url,
              title: "添加好友",
              fixTitle: true,
            )));
  }

  Future<dynamic> toggleFollow() async {
    MobcentResponse response;
    if (_userInfo.is_follow == 0) {
      response = await MobcentClient.instance.userFollow(userId: widget.userId);
      if (response.noError) {
        setState(() {
          _userInfo.is_follow = 1;
        });
      }
    } else {
      response =
          await MobcentClient.instance.userUnFollow(userId: widget.userId);
      if (response.noError) {
        setState(() {
          _userInfo.is_follow = 0;
        });
      }
    }
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return new SimpleDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          children: <Widget>[Center(child: Text(response.head.errInfo))],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text("Ta的主页"),
        centerTitle: true,
      ),
      body: _buildPageBody(context),
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) async {
            print("TAP => ${index}");
            if (index == 0) {
              await addFirend();
            } else if (index == 1) {
              await toggleFollow();
            } else if (index == 2) {
              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MessageChatPage(
                        userId: widget.userId,
                        userName: widget.userName,
                      )));
            }
          },
          currentIndex: 1,
          selectedItemColor: Theme.of(context).textTheme.caption.color,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.person_add), title: Text("加好友")),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline), title: Text("加关注")),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline), title: Text("聊天")),
          ]),
    );
  }

  Widget _buildPageBody(BuildContext context) {
    return RefreshIndicator(
      onRefresh: this.reloadUserInfo,
      child: ListView(
        children: <Widget>[
          _buildUserHeadItem(context),
          Container(height: 8),
          _buildItem(context,
              title: "Ta的发表",
              icon: Icon(Icons.note_add),
              route: UserTopicsPage(userId: widget.userId)),
          Divider(height: 0),
          _buildItem(context,
              title: "Ta的回复",
              icon: Icon(Icons.speaker_notes),
              route: UserRepliesPage(userId: widget.userId)),
          Divider(height: 0),
          _buildItem(
            context,
            title: "Ta的相册",
            icon: Icon(Icons.photo_library),
            route: UserAlbumsPage(userId: widget.userId),
          ),
        ],
      ),
    );
  }

  _buildUserHeadItem(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 80,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: UserAvatarWidget(widget.userAvatar),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(widget.userName, style: TextStyle(fontSize: 18)),
                  Container(width: 8),
                  Text(
                    _userInfo?.userTitle ?? "",
                    style: TextStyle(color: Color(0xffC6A300), fontSize: 13),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  ...?_userInfo?.body?.creditShowList?.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text("${item.title}: ${item.data}"),
                    );
                  })
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  _buildItem(BuildContext context,
      {@required String title,
      @required Icon icon,
      String subtitle,
      Widget trailing,
      Widget trailingPrefix,
      Widget route,
      GestureTapCallback onTap}) {
    return Container(
      color: Colors.white,
      child: ListTile(
        title: Text(title),
        subtitle: subtitle == null ? null : Text(subtitle),
        leading: icon,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            if (trailingPrefix != null) trailingPrefix,
            trailing ??
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade400,
                )
          ],
        ),
        onTap: onTap ??
            (route == null
                ? null
                : () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => route));
                  }),
      ),
    );
  }
}
