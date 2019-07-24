import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qiqi_bike/api/mobcent_client.dart';
import 'package:qiqi_bike/common/data_helper.dart';
import 'package:qiqi_bike/core/application.dart';
import 'package:qiqi_bike/models/forum/forum_postlist.dart';
import 'package:qiqi_bike/views/board_page.dart';
import 'package:qiqi_bike/widgets/emoji_text_widget.dart';
import 'package:qiqi_bike/widgets/popup_menu_ex.dart' as ex;
import 'package:qiqi_bike/widgets/post_image_widget.dart';
import 'package:qiqi_bike/widgets/user_avatar_widget.dart';
import 'package:scoped_model/scoped_model.dart';

class _DataSource extends Model {
  final int boardId;
  final int topicId;

  /// 排序
  /// 0 = 正序; 1 = 倒序
  int order;

  /// 数据源名称
  final String name;

  int _itemCount = 0;
  PostTopic _topic;
  List<PostReply> _items = [];

  _DataSource(this.name, {this.boardId = 0, this.topicId, this.order = 0});

  int get itemCount => _itemCount;

  PostTopic get topic => _topic;

  List<PostReply> get items => _items;

  int _hasMore = 1;
  int _nextPage = 1;
  bool _loading = false;

  bool isLoading() => _loading;

  bool hasMore() {
    return _hasMore > 0;
  }

  void fixIosProblem(List<PostContent> contents) {
    if (contents == null) return;

    for (int index = 0; index < contents.length; index++) {
      print(
          "fixIosProblem: $index @ ${contents.length} => ${contents[index].infor}");
      if (contents[index].type != 0) continue;
      final lines = contents[index].infor?.replaceAll("\r", "")?.split("\n");
      if (lines == null || lines.length == 1) continue;
      lines.forEach((item) {
        print(
            "fixIosProblem: $index @ ${contents.length} => SPLIT ${contents[index]}");
      });

      contents[index].infor = lines[0];
      contents.insertAll(
          index + 1,
          lines.sublist(1).map((line) => PostContent(
              type: 0, infor: line.replaceAll("\r", "").replaceAll("\n", ""))));
      index += lines.length - 1;
    }
  }

  Future<bool> loadMore({bool clear = false}) async {
    if (_loading) {
      print(
          "DataSource ${name} | B:${boardId} T:${topicId} P:${_nextPage} ORDER:${order} loading in progress, ignore ...");
      return true;
    }

    print(
        "DataSource ${name} | B:${boardId} T:${topicId} P:${_nextPage} ORDER:${order} TOTAL ${itemCount} / ${this.items.length} | HAS MORE => ${this.hasMore()}");

    if ((!this.hasMore()) ||
        (this.itemCount > 0 && this.itemCount == this.items.length)) {
      print(
          "DataSource ${name} | B:${boardId} T:${topicId} P:${_nextPage} ORDER:${order} all loaded !");
      return true;
    }

    _loading = true;

    /// 正在加载
    notifyListeners();

    print(
        "DataSource ${name} | B:${boardId} T:${topicId} P:${_nextPage} ORDER:${order} loading ...");
    try {
      var response = await MobcentClient.instance.postList(
          authorId: 0, topicId: topicId, page: _nextPage, order: order);
      if (!response.noError) {
        notifyListeners();
        return false;
      }
      print(
          "DataSource ${name} | B:${boardId} T:${topicId} P:${_nextPage} ORDER:${order} loadMore => GOT ${response.list?.length} Topics ...");

      /// 刷新数据源时,清除旧数据(在刷新成功之后再清除旧数据,避免先清空数据导致的页面闪烁)
      if (clear) {
        this._items.clear();
      }

      for (var reply in response.list) {
        fixIosProblem(reply?.reply_content);
        // reply?.reply_content?.forEach((content) {
        //   print("==>> ${content.infor}");
        //   if (content.type == 0)
        //     content.infor =
        //         content.infor.replaceAll("\r", "").replaceAll("\n", "");
        //   print("<<== ${content.infor}");
        // });
      }

      /// 页码+1
      this._nextPage++;
      this._itemCount = (response.total_num ?? 1) - 1;
      this._items.addAll(response.list ?? []);
      this._hasMore = response.has_next;

      /// 只有首次才需要设置主题帖
      this._topic ??= response.topic;

      if (this._topic != null) {
        fixIosProblem(this._topic?.content);
        // this._topic?.content?.forEach((content) {
        //   print("==>> ${content.infor}");
        //   if (content.type == 0)
        //     content.infor =
        //         content.infor.replaceAll("\r", "").replaceAll("\n", "");
        //   print("<<== ${content.infor}");
        // });
      }

      notifyListeners();
    } finally {
      _loading = false;
    }
    return true;
  }

  Future<bool> reload() async {
    this._hasMore = 1;
    this._nextPage = 1;

    /// 清除主题帖
    this._topic = null;
    this._itemCount = 0;
    return await this.loadMore(clear: true);
  }
}

class TopicSettings extends Model {
  bool textMode = false;
  bool smallImage = false;

  TopicSettings({this.textMode, this.smallImage});

  void update({bool textMode, bool smallImage}) {
    this.textMode = textMode ?? this.textMode;
    this.smallImage = smallImage ?? this.smallImage;
    notifyListeners();
  }
}

class SliverTopicPage extends StatefulWidget {
  final int boardId;

  final int topicId;

  /// 初始化标题(用于在加载完成正式内容之前显示)
  final String title;

  SliverTopicPage({this.boardId, this.topicId, this.title})
      : assert(boardId != null),
        assert(topicId != null);

  @override
  _TopicPageState createState() => _TopicPageState();
}

class _TopicPageState extends State<SliverTopicPage> {
  _DataSource _dataSource;
  ScrollController _scrollController = ScrollController();
  TopicSettings _topicSettings;

  @override
  void initState() {
    super.initState();
    final settings = ApplicationCore.settings;

    _topicSettings = TopicSettings(
        textMode: settings.textMode == 1, smallImage: settings.smallImage == 1);

    _dataSource = _DataSource("主题${widget.topicId}",
        boardId: widget.boardId,
        topicId: widget.topicId,
        order: settings.reverseOrder);
    _dataSource.reload();

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        print("ScrollController Reach Bottom , loadMore ...");
        _dataSource.loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<_DataSource>(
      model: _dataSource,
      child: ScopedModel<TopicSettings>(
        model: _topicSettings,
        child: Scaffold(
//          appBar: PreferredSize(
//              preferredSize: Size.fromHeight(kToolbarHeight),
//              child: GestureDetector(
//                  onDoubleTap: () {
//                    _scrollController.animateTo(0,
//                        duration: Duration(milliseconds: 200),
//                        curve: Curves.easeIn);
//                  },
//                  child: _buildAppBar(context))),
//          body: NestedScrollView(
//            headerSliverBuilder: _buildSliverAppBar,
//            body: _buildPageBody(context),
//          ),
          body: CustomScrollView(
            slivers: <Widget>[
              ..._buildSliverAppBar(context, true),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSliverAppBar(
      BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
        title: Text(ApplicationCore.forum.boards[widget.boardId].board_name),
        centerTitle: true,
        //标题居中
        // expandedHeight: 200.0,
        //展开高度200
        floating: true,
        //不随着滑动隐藏标题
        pinned: false,
        //固定在顶部
//        flexibleSpace: FlexibleSpaceBar(
//          centerTitle: true,
//          title: Text((_dataSource.topic?.title) ?? widget.title ?? ""),
//        ),
      ),

      SliverPersistentHeader(
          pinned: true,
          floating: false,
          delegate: _PersistentHeader(
              child: Container(
                  child:
                      Text((_dataSource.topic?.title) ?? widget.title ?? "")),
              collapsedHeight: kToolbarHeight,
              expandedHeight: kToolbarHeight)),

      SliverToBoxAdapter(child: Container()),

      _buildSliverPostsView(context, _scrollController, _dataSource),

      // _buildPageBody(context)
//    SliverPersistentHeader(
//    delegate: _SliverAppBarDelegate(TabBar(
//    labelColor: Colors.red,
//    unselectedLabelColor: Colors.grey,
//    tabs: [
//    Tab(icon: Icon(Icons.cake), text: '左侧'),
//    Tab(icon: Icon(Icons.golf_course), text: '右侧'),
//    ],
//    controller: TabController(length: 2, vsync: this),
//    )))
    ];
  }

  Widget _buildAppBar(BuildContext context) {
    // final settings = ScopedModel.of<TopicSettings>(context);

    return ScopedModelDescendant<TopicSettings>(
        builder: (context, child, settings) {
      return AppBar(
        title: ScopedModelDescendant<_DataSource>(
          builder: (context, child, model) => Text(
            ApplicationCore.forum.boards[widget.boardId].board_name ??
                (_dataSource.topic?.title) ??
                widget.title ??
                "",
            style: TextStyle(fontSize: 16), // 标题用小字体
          ),
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            offset: Offset(0, kToolbarHeight),
            onSelected: (value) {
              switch (value) {
                case "asc":
                  _scrollController.animateTo(0,
                      duration: Duration(milliseconds: 100),
                      curve: Curves.fastOutSlowIn);
                  _dataSource.order = 0;
                  _dataSource.reload();
                  break;
                case "desc":
                  _scrollController.animateTo(0,
                      duration: Duration(milliseconds: 100),
                      curve: Curves.fastOutSlowIn);
                  _dataSource.order = 1;
                  _dataSource.reload();
                  break;
                case "textMode=false":
                  settings.update(textMode: false);
                  break;
                case "textMode=true":
                  settings.update(textMode: true);
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                ex.PopupMenuItem<String>(
                  value: _dataSource.order == 0 ? "desc" : "asc",
                  child: Text(_dataSource.order == 0 ? "倒序浏览" : "正序浏览"),
                ),
                ex.PopupMenuItem<String>(
                  value: settings.textMode ? "textMode=false" : "textMode=true",
                  child: Text(settings.textMode ? "图文模式" : "无图模式"),
                ),
              ];
            },
          ),
        ],
      );
    });
  }

  _buildPageBody(BuildContext context) {
    return _wrapRefresh(
        _buildPostsView(context, _scrollController, _dataSource), _dataSource);
  }

  Widget _wrapRefresh(Widget widget, _DataSource dataSource) {
    return RefreshIndicator(
        onRefresh: () async {
          await dataSource.reload();
          return Future.value();
        },
        child: widget);
  }

  Widget _buildSliverPostsView(BuildContext context,
      ScrollController controller, _DataSource dataSource) {
    return ScopedModelDescendant<_DataSource>(
      builder: (context, child, model) {
        print("ScopedModelDescendant ${model.name} build ...");

        final itemCount = model.items.length + 3; // 主题帖 + 评分行 + 尾行

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index == 0) {
                // 构建主贴
                return _buildTopicItemView(context, model.topic);
              }
              if (index == 1) {
                return _buildScoreView(context, model.topic);
              }
              if (index == itemCount - 1) {
                if (_dataSource.hasMore()) {
                  return Container(
                    padding: EdgeInsets.only(top: 16, bottom: 16),
                    child: CupertinoButton(
                      child: Text(
                          _dataSource.isLoading() ? "正在加载..." : "加载更多 ..."),
                      onPressed: _dataSource.isLoading()
                          ? null
                          : () {
                              _dataSource.loadMore();
                            },
                    ),
                  );
                } else {
                  return Container(
                    padding: EdgeInsets.only(top: 16, bottom: 16),
                    child: Center(
                        child: Text(
                      "已经到最后了!",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 18),
                    )),
                  );
                }
              }
              // 构建回帖
              return _buildReplyItemView(
                  context, index, model.items[index - 2]);
            },
            childCount: itemCount,
          ),
        );
      },
    );
  }

  Widget _buildPostsView(BuildContext context, ScrollController controller,
      _DataSource dataSource) {
    return ScopedModelDescendant<_DataSource>(
      builder: (context, child, model) {
        print("ScopedModelDescendant ${model.name} build ...");

        final itemCount = model.items.length + 3; // 主题帖 + 评分行 + 尾行

        return ListView.builder(
            controller: controller,
            physics: AlwaysScrollableScrollPhysics(),
            cacheExtent: 0,
            itemCount: itemCount,
            itemBuilder: (context, index) {
              if (index == 0) {
                // 构建主贴
                return _buildTopicItemView(context, model.topic);
              }
              if (index == 1) {
                return _buildScoreView(context, model.topic);
              }
              if (index == itemCount - 1) {
                if (_dataSource.hasMore()) {
                  return Container(
                    padding: EdgeInsets.only(top: 16, bottom: 16),
                    child: CupertinoButton(
                      child: Text(
                          _dataSource.isLoading() ? "正在加载..." : "加载更多 ..."),
                      onPressed: _dataSource.isLoading()
                          ? null
                          : () {
                              _dataSource.loadMore();
                            },
                    ),
                  );
                } else {
                  return Container(
                    padding: EdgeInsets.only(top: 16, bottom: 16),
                    child: Center(
                        child: Text(
                      "已经到最后了!",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 18),
                    )),
                  );
                }
              }
              // 构建回帖
              return _buildReplyItemView(
                  context, index, model.items[index - 2]);
            });
      },
    );
  }

  Widget _buildTopicItemView(BuildContext context, PostTopic topic) {
    if (topic == null)
      return Container(
        height: 120,
      );
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 8, bottom: 8),
      padding: EdgeInsets.only(bottom: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          /// 主题在标题栏显示
//          Container(
//              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//              child: Text(
//                topic.title,
//                style: TextStyle(fontSize: 18),
//              )),
          _buildUserDetailWidget(
              context, topic.icon, topic.user_nick_name, topic.userTitle),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Divider(height: 1),
          ),
          ...topic.content.map((content) => PostContentWidget(content)),
          _buildTopicBottomWidget(context, topic),
        ],
      ),
    );
  }

  _buildReplyItemView(BuildContext context, int index, PostReply model) {
    return Container(
      key: ValueKey(model.reply_id),
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.only(top: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildUserDetailWidget(
              context, model.icon, model.reply_name, model.userTitle,
              floor: model.position),
          Divider(height: 8),
          ...model.reply_content.map((content) => PostContentWidget(content)),
          if (!DataHelper.isIsNullOrWhiteSpaceString(model.quote_content))
            PostQuoteWidget(model),
          _buildReplyBottomWidget(context, model),
        ],
      ),
    );
  }

  _buildTopicBottomWidget(BuildContext context, PostTopic model) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: <Widget>[
          Text(
            DataHelper.toDateTimeOffsetString(model.create_date_value),
            style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          ),
          Spacer(),
          IconWithLabel(
              onPressed: () {},
              icon: Icon(
                Icons.remove_red_eye,
                color: Colors.grey.shade400,
                size: 18,
              ),
              label: Text(model.hits.toString())),
          IconWithLabel(
              onPressed: () {},
              icon: Icon(
                Icons.chat_bubble,
                color: Colors.grey.shade400,
                size: 18,
              ),
              label: Text(model.replies.toString())),
        ],
      ),
    );
  }

  /// 小头像模式用户信息
  _buildUserDetailWidget(
      BuildContext context, String avatar, String nickName, String titleName,
      {int floor}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: UserAvatarWidget(
              avatar,
              width: 24.0,
              height: 24.0,
              borderRadius: 4,
            ),
          ),
          Text(
            nickName,
            style: TextStyle(
                color: Theme.of(context).primaryColorDark, fontSize: 16),
          ),
          Container(width: 4),
          Text(
            titleName,
            style: TextStyle(color: Color(0xffC6A300), fontSize: 11),
          ),
          Spacer(),
          if (floor != null)
            Text(
              "${floor}楼",
              style:
                  TextStyle(color: Theme.of(context).hintColor, fontSize: 13),
            ),
        ],
      ),
    );
  }

  _buildReplyBottomWidget(BuildContext context, PostReply model) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: <Widget>[
          Text(
            DataHelper.toDateTimeOffsetString(model.posts_date_value),
            style: TextStyle(color: Theme.of(context).hintColor, fontSize: 13),
          ),
          Spacer(),
          ReplyTopicWidget(model)
        ],
      ),
    );
  }

  Widget _buildScoreView(BuildContext context, PostTopic topic) {
    List<RateListBody> rates = topic?.rateList?.body ?? [];
    RateListHead head =
        topic?.rateList?.head ?? RateListHead(field1: "", field2: "");
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    width: 80,
                    child: Text(
                      "评分",
                      style: TextStyle(fontSize: 16),
                    )),
                FlatButton.icon(
                  color: Colors.grey.shade300,
                  icon: Icon(Icons.star_half, color: Colors.amberAccent),
                  label: Text("我要评分"),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  onPressed: () {},
                )
              ],
            ),
          ),
          // Container(child: Ro,)
          Container(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(width: 120, child: Text(head.field1 ?? "")),
                Text(
                  head.field2 ?? "",
                  style: TextStyle(color: Theme.of(context).primaryColorDark),
                ),
                Container(width: 120)
              ],
            ),
          ),
          Divider(height: 0),
          for (int i = 0; i < rates.length; i++)
            Container(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(width: 120, child: Text(rates[i].field1)),
                  Text(
                    rates[i].field2,
                    style: TextStyle(color: Theme.of(context).primaryColorDark),
                  ),
                  Container(
                      width: 120,
                      child: Text(rates[i].field3,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: Theme.of(context).primaryColorDark))),
                ],
              ),
            )
        ],
      ),
    );
  }
}

class _PersistentHeader extends SliverPersistentHeaderDelegate {
  Widget child;

  double collapsedHeight;

  double expandedHeight;

  _PersistentHeader({
    @required this.child,
    @required this.collapsedHeight,
    @required this.expandedHeight,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => math.max(expandedHeight, minExtent);

  @override
  // TODO: implement minExtent
  double get minExtent => collapsedHeight;

  @override
  bool shouldRebuild(_PersistentHeader oldDelegate) {
    return expandedHeight != oldDelegate.expandedHeight ||
        collapsedHeight != oldDelegate.collapsedHeight;
  }
}

/// 引用帖子按钮
class PostQuoteWidget extends StatelessWidget {
  final PostReply model;

  PostQuoteWidget(this.model);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.black12),
      child: Text(model.quote_content),
    );
  }
}

/// 回复帖子按钮
class ReplyTopicWidget extends StatelessWidget {
  final PostReply model;

  const ReplyTopicWidget(this.model, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {},
      minWidth: 0,
      padding: EdgeInsets.all(0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: Row(
        children: <Widget>[
          Text("回复",
              style: TextStyle(
                  color: Theme.of(context).primaryColorDark, fontSize: 13)),
          Icon(
            Icons.reply,
            color: Theme.of(context).primaryColorDark,
            size: 18,
          ),
        ],
      ),
    );
  }
}

class PostContentWidget extends StatefulWidget {
  final String debugLabel;
  final PostContent content;

  PostContentWidget(this.content, {this.debugLabel});

  @override
  _PostContentWidgetState createState() => _PostContentWidgetState();
}

class _PostContentWidgetState extends State<PostContentWidget> {
  @override
  Widget build(BuildContext context) {
    switch (widget.content.type) {
      case 0:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: EmojiTextWidget(
              emojiSize: 22,
              text: widget.content.infor,
              textStyle: TextStyle(fontSize: 18, color: Colors.black)),
        );
      case 1:
        return imageSegment(context);
      default:
        return Container();
    }
  }

  Widget textSegment(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          widget.content.infor,
          style: TextStyle(fontSize: 15),
        ));
  }

//  Widget extendTextSegment(BuildContext context) {
//    return Container(
//      margin: EdgeInsets.symmetric(horizontal: 8),
//      child: ExtendedText(
//        widget.content.infor,
//        softWrap: true,
//        overflow: TextOverflow.visible,
//        selectionEnabled: true,
//        onSpecialTextTap: (dynamic parameter) {
//          if (parameter.startsWith("@")) {
//            print("@USER => ${parameter}");
//          }
//        },
//        specialTextSpanBuilder: MobcentSpecialTextSpanBuilder(),
//      ),
//    );
//  }

  Widget imageSegment(BuildContext context) {
    return ScopedModelDescendant<TopicSettings>(
      builder: (context, child, settings) {
        return Container(
          margin: EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 48),
          child: settings.textMode
              ? Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        settings.update(textMode: false);
                      },
                      child: Text(
                        "当前为无图模式,点击显示图片...",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                )
              : PostImageWidget(
                  widget.content.originalInfo,
                  borderRadius: 8,
                ),
        );
      },
    );
  }
}
//
//class EmojiContentWidget extends StatefulWidget {
//  final String content;
//  final String debugLabel;
//
//  EmojiContentWidget({this.content, this.debugLabel});
//
//  @override
//  _EmojiContentWidgetState createState() => _EmojiContentWidgetState();
//}
//
//class _EmojiContentWidgetState extends State<EmojiContentWidget> {
//  List<InlineSpan> _contentItems;
//
//  static List<InlineSpan> _parseContent(String contentString,
//      {bool noEmoji = false}) {
//    final size = 20.0;
//    List<InlineSpan> contentItems = List();
//    contentString.splitMapJoin(RegExp(r"(\[.+?\])"), onMatch: (Match match) {
//      final matchContent = match.group(0);
//      String emojiContent;
//      if (matchContent.startsWith("[mobcent_phiz=")) {
//        if (noEmoji) {
//          return "";
//        }
//        emojiContent =
//            matchContent.replaceAll("[mobcent_phiz=", "")?.replaceAll("]", "");
//
//        final imageProvider = CachedNetworkImageProvider(
//          emojiContent,
//          headers: {
//            HttpHeaders.userAgentHeader:
//                "Mozilla/5.0 (iPhone; CPU iPhone OS 12_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 Appbyme"
//          },
//        );
//        contentItems.add(
//          WidgetSpan(
//            child: Image(
//                image: imageProvider,
//                width: size,
//                height: size,
//                fit: BoxFit.fill),
//          ),
//        );
//      } else {
//        if (noEmoji) {
//          return "";
//        }
//        emojiContent = MobcentForumFaces.findAsset(matchContent);
//        if (emojiContent != null) {
//          contentItems.add(
//            WidgetSpan(
//              child: Image.asset(emojiContent,
//                  width: size, height: size, fit: BoxFit.fill),
//            ),
//          );
//        }
//      }
//      if (emojiContent == null) {
//        contentItems.add(TextSpan(text: matchContent));
//      }
//      return "";
//    }, onNonMatch: (String nonMatch) {
//      contentItems.add(TextSpan(text: nonMatch));
//      return "";
//    });
//    return contentItems;
//  }
//
//  @override
//  void initState() {
//    super.initState();
//    _contentItems = _parseContent(widget.content, noEmoji: true);
//    print("EmojiContentWidget@${widget.debugLabel}::initState ...");
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Text.rich(TextSpan(children: _contentItems));
//  }
//
//  @override
//  void dispose() {
//    print("EmojiContentWidget@${widget.debugLabel}::dispose ...");
//    super.dispose();
//  }
//
//  @override
//  void deactivate() {
//    super.deactivate();
//    print("EmojiContentWidget@${widget.debugLabel}::deactivate ...");
//  }
//}
//
//class MobcentSpecialTextSpanBuilder extends SpecialTextSpanBuilder {
//  @override
//  SpecialText createSpecialText(String flag,
//      {TextStyle textStyle, onTap, int index}) {
//    if (flag == null || flag == "") return null;
//
//    if (isStart(flag, AtText.flag)) {
//      return AtText(textStyle,
//          onTap: onTap, start: index - (AtText.flag.length - 1));
//    } else if (isStart(flag, EmojiText.flag)) {
//      return EmojiText(textStyle, start: index - (EmojiText.flag.length - 1));
//    }
//    return null;
//  }
//
//  @override
//  InlineSpan build(String data, {TextStyle textStyle, onTap}) {
//    return super.build(data, textStyle: textStyle, onTap: onTap);
//  }
//}
//
//class AtText extends SpecialText {
//  static const flag = "@";
//  final int start;
//  final TextStyle textStyle;
//
//  AtText(this.textStyle, {this.start, SpecialTextGestureTapCallback onTap})
//      : super(flag, " ", textStyle, onTap: onTap);
//
//  @override
//  InlineSpan finishText() {
//    TextStyle textStyle =
//        this.textStyle?.copyWith(color: Colors.blue, fontSize: 16.0);
//
//    final String atText = toString();
//
//    return SpecialTextSpan(
//      text: atText,
//      actualText: atText,
//      start: start,
//      style: textStyle,
//    );
//  }
//}
//
//class EmojiText extends SpecialText {
//  static const flag = "[";
//  final int start;
//  final TextStyle textStyle;
//
//  EmojiText(this.textStyle, {this.start}) : super(flag, "]", textStyle);
//
//  @override
//  InlineSpan finishText() {
//    final String key = toString();
//
//    if (key.startsWith("[mobcent_phiz=")) {
//      final imageUrl =
//          key.replaceAll("[mobcent_phiz=", "")?.replaceAll("]", "");
//      final double size = 20.0;
//
//      return ImageSpan(
//        CachedNetworkImageProvider(
//          imageUrl,
//          headers: {
//            HttpHeaders.userAgentHeader:
//                "Mozilla/5.0 (iPhone; CPU iPhone OS 12_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 Appbyme"
//          },
//        ),
//        actualText: key,
//        imageWidth: size,
//        imageHeight: size,
//        start: start,
//        fit: BoxFit.fill,
//        margin: EdgeInsets.only(left: 2.0, top: 2.0, right: 2.0),
//      );
//    }
//
//    var emojiAsset = MobcentForumFaces.findAsset(key);
//
//    if (emojiAsset != null) {
//      //fontsize id define image height
//      //size = 30.0/26.0 * fontSize
//      final double size = 20.0;
//
//      ///fontSize 26 and text height =30.0
//      //final double fontSize = 26.0;
//      return ImageSpan(AssetImage(emojiAsset),
//          actualText: key,
//          imageWidth: size,
//          imageHeight: size,
//          start: start,
//          fit: BoxFit.fill,
//          margin: EdgeInsets.only(left: 2.0, top: 2.0, right: 2.0));
//    }
//
//    return TextSpan(text: toString(), style: textStyle);
//  }
//}
