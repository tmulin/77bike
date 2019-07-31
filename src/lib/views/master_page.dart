import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qiqi_bike/core/application.dart';
import 'package:qiqi_bike/core/messages.dart';
import 'package:qiqi_bike/core/session.dart';
import 'package:qiqi_bike/core/settings.dart';
import 'package:qiqi_bike/update/update_service.dart';
import 'package:qiqi_bike/views/topic_editor_page.dart';
import 'package:scoped_model/scoped_model.dart';

import 'discovery/discovery_page.dart';
import 'forum_page.dart';
import 'index_page.dart';
import 'message/message_page.dart';
import 'publish_page.dart';
import 'user_login_page.dart';

class MasterPage extends StatefulWidget {
  @override
  _MasterPageState createState() => _MasterPageState();
}

class _MasterPageState extends State<MasterPage> {
  int _currentIndex = 0;
  var pageControllers = <PageRefreshController>[
    PageRefreshController(),
    PageRefreshController(),
    null,
    PageRefreshController(),
    null
  ];
  ApplicationUpdateResponse _updateResponse;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 1000)).then((_) {
      UpdaterService.instance.checkUpdate().then((response) {
        if (response?.hasUpdate ?? false) {
          setState(() {
            _updateResponse = response;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var mainPages = <Widget>[
      IndexPage(controller: pageControllers[0]),
      ForumPage(controller: pageControllers[1]),
      PublishPage(),
      MessagePage(controller: pageControllers[3]),
      DiscoveryPage(updateDetails: _updateResponse),
    ];

    return ScopedModel<MessagesModel>(
      model: ApplicationCore.messages,
      child: ScopedModel<Session>(
        model: ApplicationCore.session,
        child: ScopedModel<Settings>(
          model: ApplicationCore.settings,
          child: Scaffold(
            bottomNavigationBar: _buildBottomNavigation(context),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      if (ApplicationCore.session.uid > 0) {
                        /// 发布新帖
                        return TopicEditorPage();
                      } else {
                        /// 登录
                        return UserLoginPage();
                      }
                    },
                    fullscreenDialog: true));
              },
              child: Icon(Icons.add),
              mini: true,
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            body: Container(
                color: Color(0xfff5f5f5),
                child: IndexedStack(index: _currentIndex, children: mainPages)),
          ),
        ),
      ),
    );
  }

  _buildBottomNavigation(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      child: Row(
        //里边可以放置大部分Widget，让我们随心所欲的设计底栏
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          _buildNavButton(context, Icons.home, 0, label: "首页"),
          _buildNavButton(context, Icons.widgets, 1, label: "社区"),
          // _buildNavButton(context, Icons.add_box, 2),
          Container(
            width: 32,
            height: 0,
          ),
          ScopedModelDescendant<MessagesModel>(
              builder: (context, _, messages) => _buildNavButton(
                  context, Icons.message, 3,
                  label: "消息", bubble: messages.hasMessage)),
          _buildNavButton(context, Icons.center_focus_strong, 4,
              label: "发现", bubble: _updateResponse != null),
        ],
      ),
    );
  }

  Widget _buildNavButton(BuildContext context, IconData icon, int index,
      {String label, bool bubble = false}) {
    final color = _currentIndex == index
        ? Theme.of(context).primaryColor
        : Colors.black26;
    return GestureDetector(
      /// 点击区域优化(避免透明背景色导致的点击无效)
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final int previousIndex = _currentIndex;
        _currentIndex = index;
        pageControllers[_currentIndex]?.refresh();
        setState(() {});

        /// 手动触发消息检查
        ApplicationCore.checkMessages();
      },
      child: Stack(
        alignment: AlignmentDirectional.topEnd,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                [0, 1, 3].contains(index) && index == _currentIndex
                    ? RefreshIcon(
                        refreshIcon: Icon(Icons.refresh, color: color))
                    : Icon(icon, color: color),
                if (label != null) Text(label, style: TextStyle(color: color))
              ],
            ),
          ),
          if (bubble)
            Padding(
                padding: EdgeInsets.only(top: 4, right: 8),
                child: Icon(Icons.fiber_manual_record,
                    color: Colors.red, size: 10)),
        ],
      ),
    );
  }
}

class PageRefreshController extends ChangeNotifier {
  void refresh() {
    this.notifyListeners();
  }
}

class RefreshIcon extends StatefulWidget {
  final Icon defaultIcon;
  final Icon refreshIcon;

  RefreshIcon({this.defaultIcon, this.refreshIcon = const Icon(Icons.refresh)});

  @override
  _RefreshIconState createState() => _RefreshIconState();
}

class _RefreshIconState extends State<RefreshIcon>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animate;

  @override
  void initState() {
    super.initState();
    controller = new AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animate = new Tween<double>(begin: 0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    // 启动动画(正向执行)
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(RefreshIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("RefreshIcon::didUpdateWidget ...");
    controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: animate,
      child: widget.refreshIcon,
    );
  }
}
