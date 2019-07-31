import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:qiqi_bike/api/mobcent_client.dart';
import 'package:qiqi_bike/common/data_helper.dart';
import 'package:qiqi_bike/core/application.dart';
import 'package:qiqi_bike/core/build.dart';
import 'package:qiqi_bike/core/session.dart';
import 'package:qiqi_bike/core/settings.dart';
import 'package:qiqi_bike/models/user/user_userinfo.dart';
import 'package:qiqi_bike/update/update_dialog.dart';
import 'package:qiqi_bike/update/update_service.dart';
import 'package:qiqi_bike/views/discovery/user_albums_page.dart';
import 'package:qiqi_bike/views/discovery/user_favorites_page.dart';
import 'package:qiqi_bike/widgets/popup_menu_ex.dart' as ex;
import 'package:qiqi_bike/widgets/user_avatar_widget.dart';
import 'package:scoped_model/scoped_model.dart';

import '../user_login_page.dart';
import 'cache_status_page.dart';
import 'demo/demo_content_page.dart';
import 'demo/demo_embed_page.dart';
import 'demo/demo_emoji_page.dart';
import 'demo/demo_emojiwidget_page.dart';
import 'demo/demo_topic_page.dart';
import 'user_replices_page.dart';
import 'user_topics_page.dart';

class DiscoveryPage extends StatefulWidget {
  final ApplicationUpdateResponse updateDetails;

  DiscoveryPage({this.updateDetails});

  @override
  _DiscoveryPageState createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> {
  String appVersoin;
  UserInfoResponse _userInfo;
  ApplicationUpdateResponse _updateDetails;

  @override
  void initState() {
    super.initState();
    this.reloadUserInfo();
    _updateDetails = widget.updateDetails;

    ApplicationCore.session.addListener(_currentUserChanged);
    appVersoin = "?.?.?";
    PackageInfo.fromPlatform().then((packageInfo) {
      if (mounted) {
        setState(() {
          appVersoin = packageInfo.version;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    ApplicationCore.session.removeListener(_currentUserChanged);
  }

  void _currentUserChanged() {
    this.reloadUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    assert(ApplicationCore.session != null);

    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          title: Text("发现"),
          centerTitle: true,
          actions: <Widget>[
            if (Build.inDevelopment) _buildDebugPageMenu(context)
          ],
        ),
        body: _buildPageBody(context));
  }

  Future<void> reloadUserInfo() async {
    var userId = ApplicationCore.session.uid;
    if (userId > 0) {
      MobcentClient.instance.userGetUserInfo(userId).then((response) {
        if (response.noError) {
          setState(() {
            _userInfo = response;
          });
        }
      });
    } else {
      setState(() {
        _userInfo = null;
      });
    }
  }

  Widget _buildPageBody(BuildContext context) {
    return RefreshIndicator(
      onRefresh: this.reloadUserInfo,
      child: ListView(
        children: <Widget>[
          _buildUserHeadItem(context),
          Container(height: 8),
          _buildItem(context,
              title: "我的发表",
              icon: Icon(Icons.note_add),
              route: UserTopicsPage(userId: ApplicationCore.session.uid)),
          Divider(height: 0),
          _buildItem(context,
              title: "我的回复",
              icon: Icon(Icons.speaker_notes),
              route: UserRepliesPage(userId: ApplicationCore.session.uid)),
          Divider(height: 0),
          _buildItem(context,
              title: "我的收藏",
              icon: Icon(Icons.favorite_border),
              route: UserFavoritesPage(userId: ApplicationCore.session.uid)),
          Divider(height: 0),
          _buildItem(
            context,
            title: "我的相册",
            icon: Icon(Icons.photo_library),
            route: UserAlbumsPage(userId: ApplicationCore.session.uid),
          ),
          Container(height: 8),
          // _buildUserInfoItem(context),
          // Divider(height: 0),
          ScopedModelDescendant<Settings>(
            builder: (context, child, model) {
              return _buildItem(
                context,
                title: "倒序浏览",
                icon: Icon(Icons.sort),
                trailing: Switch(
                    value: model.reverseOrder == 1,
                    onChanged: (value) {
                      model.update(reverseOrder: value ? 1 : 0);
                    }),
              );
            },
          ),
          Divider(height: 0),
          ScopedModelDescendant<Settings>(
            builder: (context, child, model) {
              return _buildItem(
                context,
                title: "无图模式",
                icon: Icon(Icons.photo),
                trailing: Switch(
                    value: model.textMode == 1,
                    onChanged: (value) {
                      model.update(textMode: value ? 1 : 0);
                    }),
              );
            },
          ),
          Divider(height: 0),
          ScopedModelDescendant<Settings>(
            builder: (context, child, model) {
              return _buildItem(
                context,
                title: "图片加速",
                icon: Icon(Icons.cloud_download),
                trailing: Switch(
                    value: model.cloudProcess == 1,
                    onChanged: (value) {
                      model.update(cloudProcess: value ? 1 : 0);
                    }),
              );
            },
          ),
          Divider(height: 0),
          _buildItem(context,
              title: "临时文件",
              icon: Icon(Icons.restore_from_trash),
              route: CacheStatusPage()),
//        ScopedModelDescendant<Settings>(
//          builder: (context, child, model) {
//            return _buildItem(
//              context,
//              title: "帖子内显示小图片",
//              icon: Icon(Icons.photo),
//              trailing: Switch(
//                  value: model.smallImage == 1,
//                  onChanged: (value) {
//                    model.update(smallImage: value ? 1 : 0);
//                  }),
//            );
//          },
//        ),
          Container(height: 8),
          _buildVersionUpdateWidget(context),
          if (Build.inDevelopment)
            Container(height: 16),
          if (Build.inDevelopment)
            ScopedModelDescendant<Settings>(
              builder: (context, child, model) {
                return _buildItem(
                  context,
                  title: "代理服务器",
                  icon: Icon(Icons.all_out),
                  trailing: Switch(
                      value: model.enableProxy == 1,
                      onChanged: (value) {
                        model.update(enableProxy: value ? 1 : 0);
                      }),
                );
              },
            ),
          Container(height: 8),
          if (ApplicationCore.session.uid > 0)
            Container(
              margin: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 32),
              child: CupertinoButton(
                color: Colors.white,
                child: Text(
                  "退出登录",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () async {
                  await ApplicationCore.userLogout();
                  setState(() {
                    _userInfo = null;
                  });
                },
              ),
            )
        ],
      ),
    );
  }

  _buildUserHeadItem(BuildContext context) {
    return ScopedModelDescendant<Session>(
      builder: (context, child, session) {
        if (session.uid == 0) {
          return Container(
              color: Colors.white,
              height: 80,
              padding: EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  Icon(CupertinoIcons.profile_circled,
                      size: 60, color: Colors.grey.shade300),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => UserLoginPage()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text("立即登录", style: TextStyle(color: Colors.red)),
                    ),
                  ),
                  Spacer(),

                  /// 签到按钮
                  _buildSignWidget(context),
                ],
              ));
        } else {
          return Container(
            color: Colors.white,
            height: 80,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: UserAvatarWidget(session.avatar),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(session.userName, style: TextStyle(fontSize: 18)),
                        Container(width: 8),
                        Text(
                          _userInfo?.userTitle ?? "",
                          style:
                              TextStyle(color: Color(0xffC6A300), fontSize: 13),
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

                Spacer(),

                /// 签到按钮
                _buildSignWidget(context),
              ],
            ),
          );
        }
      },
    );
  }

  _buildSignWidget(BuildContext context) {
    return ScopedModelDescendant<Session>(builder: (context, _, session) {
      final todayCode = DataHelper.nowToDateCode();
      final mainColor = session.signDate == todayCode
          ? Theme.of(context).backgroundColor
          : Color(0xFFFF6A6A);
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: RawMaterialButton(
          constraints: BoxConstraints(
              maxWidth: 40, maxHeight: 40, minWidth: 40, minHeight: 40),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: mainColor, width: 2)),
          child: Text("签",
              style: TextStyle(
                  color: mainColor, fontSize: 20, fontWeight: FontWeight.bold)),
          onPressed: () async {
            final response = await MobcentClient.instance.userSign();
            if ([070000006, 070000003].contains(response?.head?.errCode)) {
              print("更新签到状态 => ${todayCode}");
              if (ApplicationCore.session.signDate != todayCode) {
                /// 记录的签到日期与当前日期不同
                ApplicationCore.session.update(signDate: todayCode);
              }
            }
            Flushbar(
              animationDuration: Duration(milliseconds: 500),
              backgroundColor: Theme.of(context).primaryColor,
              boxShadows: [
                BoxShadow(
                    color: Theme.of(context).primaryColor,
                    offset: Offset(0.0, 2.0),
                    blurRadius: 28.0),
              ],
              flushbarStyle: FlushbarStyle.GROUNDED,
              flushbarPosition: FlushbarPosition.TOP,
              messageText: Text(
                response.head.errInfo,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              duration: Duration(seconds: 3),
            )..show(context);
          },
        ),
      );
    });
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

  _buildVersionUpdateWidget(BuildContext context) {
    if (_updateDetails == null) {
      return _buildItem(context,
          title: "当前版本",
          icon: Icon(Icons.update),
          trailing: Icon(null),
          trailingPrefix: Text("v${appVersoin}"), onTap: () {
        UpdaterService.instance.checkUpdate().then((response) {
          if (response.hasUpdate) {
            setState(() {
              _updateDetails = response;
            });
          }
        });
      });
    }

    return _buildItem(context,
        title: "版本更新",
        icon: Icon(Icons.update),
        trailing: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Icon(Icons.fiber_manual_record, color: Colors.red, size: 10)),
        trailingPrefix: Text("点击下载 v${_updateDetails.versionName}",
            style: TextStyle(color: Colors.red)), onTap: () async {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return UpdateDialog(_updateDetails);
        },
      );
    });
  }

  _buildDebugPageMenu(BuildContext context) {
    return PopupMenuButton<String>(
      offset: Offset(0, kToolbarHeight),
      onSelected: (value) {
        switch (value) {
          case "demo_emoji_page":
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DemoEmojiPage(), fullscreenDialog: true));
            break;
          case "demo_content_page":
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DemoContentPage(),
                fullscreenDialog: true));
            break;
          case "demo_embed_page":
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DemoEmbedPage(), fullscreenDialog: true));
            break;
          case "demo_emojiwidget_page":
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DemoEmojiWidgetPage(),
                fullscreenDialog: true));
            break;
          case "demo_topic_page":
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DemoTopicPage(), fullscreenDialog: true));
            break;
        }
      },
      itemBuilder: (context) {
        return [
          ex.PopupMenuItem<String>(
            value: "demo_emoji_page",
            child: Text("简单排版"),
          ),
          ex.PopupMenuItem<String>(
            value: "demo_embed_page",
            child: Text("内嵌排版"),
          ),
          ex.PopupMenuItem<String>(
            value: "demo_content_page",
            child: Text("组件排版"),
          ),
          ex.PopupMenuItem<String>(
            value: "demo_webview_page",
            child: Text("WEB排版"),
          ),
          ex.PopupMenuItem<String>(
            value: "demo_emojiwidget_page",
            child: Text("自定义排版"),
          ),
          ex.PopupMenuItem<String>(
            value: "demo_topic_page",
            child: Text("主题页演示"),
          ),
        ];
      },
    );
  }
}
