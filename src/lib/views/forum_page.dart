import 'package:flutter/material.dart';
import 'package:qiqi_bike/api/mobcent_client.dart';
import 'package:qiqi_bike/common/data_helper.dart';
import 'package:qiqi_bike/core/application.dart';
import 'package:qiqi_bike/core/forum.dart';
import 'package:qiqi_bike/models/forum/forum_forumlist.dart';
import 'package:qiqi_bike/widgets/forum_search_button.dart';
import 'package:scoped_model/scoped_model.dart';

import 'board_page.dart';
import 'master_page.dart';

class ForumPage extends StatefulWidget {
  PageRefreshController controller;

  ForumPage({this.controller});

  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _loadData() async {
    List<BoardCategory> categories;
    List<BoardClassification> boardClasses;
    if (true) {
      var response = await MobcentClient.instance.forumList();
      if (response.noError) {
        categories = response.list;
      }
    }

    if (true) {
      var response = await MobcentClient.instance.userGetSetting();
      if (response.noError) {
        boardClasses = response.body.postInfo.map((item) {
          final classes = item.topic.classificationType_list
              .map((cls) => Classification(
                  id: cls.classificationType_id,
                  name: cls.classificationType_name))
              .toList();
          return BoardClassification(id: item.fid, classes: classes);
        }).toList();
      }
    }
    ApplicationCore.forum.update(classes: boardClasses, categories: categories);
  }

  @override
  void initState() {
    super.initState();

    widget.controller?.addListener(_refreshPage);

    /// 异步刷新版块数据
    this._loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildPageBody(context),
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller?.removeListener(_refreshPage);
  }

  void _refreshPage() {
    if (_refreshIndicatorKey.currentState.mounted)
      _refreshIndicatorKey.currentState?.show();
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text("社区"),
      centerTitle: true,
      titleSpacing: 0,
      // bottom: _buildPageTabBar(context),
      actions: <Widget>[const ForumSearchButton()],
    );
  }

  Widget _buildPageBody(BuildContext context) {
    return RefreshIndicator(
        key: _refreshIndicatorKey,
        displacement: 20,
        onRefresh: () async {
          return this._loadData();
        },
        child: _buildBoardCategories(context));
  }

  Widget _buildBoardCategories(BuildContext context) {
    return ScopedModel<ForumModel>(
      model: ApplicationCore.forum,
      child: ScopedModelDescendant<ForumModel>(
        builder: (context, child, forumData) => ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: forumData.boardCategories.length,
            itemBuilder: (context, index) {
              return _buildBoardCategory(
                  context, forumData.boardCategories[index]);
            }),
      ),
    );
  }

  Widget _buildBoardCategory(BuildContext context, BoardCategory category) {
    final width = MediaQuery.of(context).size.width;
    final minHeight = 160;

    return Container(
      constraints: BoxConstraints(minHeight: 120),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          /// 论坛标题
          Container(
              color: Color(0xfff5f5f5),
              padding: EdgeInsets.all(8),
              child: Text(
                category.board_category_name,
                style: TextStyle(fontSize: 16),
              )),
          Divider(height: 0),

          /// 版块列表
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            childAspectRatio: width / minHeight,
            physics: NeverScrollableScrollPhysics(),
            children: category.board_list
                .map((board) => _buildBoard(context, board))
                .toList(),
          ),

          /// 版块底部与下一版块标题之间额外间距
          Container(
            height: 8,
            color: Color(0xfff5f5f5),
          )
        ],
      ),
    );
  }

  Widget _buildBoard(BuildContext context, Board board) {
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BoardPage(
                  boardId: board.board_id, boardName: board.board_name)));
        },
        child: Ink(
          padding: EdgeInsets.all(8),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.grey.shade100)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      board.board_name,
                      style: TextStyle(fontSize: 15),
                    ),
                    board.td_posts_num == 0
                        ? Container()
                        : Text("(${board.td_posts_num})",
                            style: TextStyle(color: Colors.blue)),
                  ]),
              Text(
                DataHelper.toDateTimeOffsetString(board.last_posts_date_value),
                style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
              )
            ],
          ),
        ),
      ),
    );
  }
}
