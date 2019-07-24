import 'dart:convert';

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

  _DataSource(this.name, {this.boardId = 0, this.topicId, this.order = 0}){
    var response = PostListResponseSerializer().fromMap(_samples);
    _topic = response.topic;
    print("topic ${_topic.title}");
    _items.addAll(response.list.take(3));
  }

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

  Future<bool> loadMore({bool clear = false}) async {
    notifyListeners();
    return true;
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

      print(jsonEncode(PostListResponseSerializer().toMap(response)));

      /// 页码+1
      this._nextPage++;
      this._itemCount = (response.total_num ?? 1) - 1;
      this._items.addAll(response.list ?? []);
      this._hasMore = response.has_next;

      /// 只有首次才需要设置主题帖
      this._topic ??= response.topic;
      notifyListeners();
    } finally {
      _loading = false;
    }
    return true;
  }

  Future<bool> reload() async {
    return true;
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

class DemoTopicPage extends StatefulWidget {
  final int boardId;

  final int topicId;

  DemoTopicPage({this.boardId = 31, this.topicId = 301614})
      : assert(boardId != null),
        assert(topicId != null);

  @override
  _TopicPageState createState() => _TopicPageState();
}

class _TopicPageState extends State<DemoTopicPage> {
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
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: GestureDetector(
                  onDoubleTap: () {
                    _scrollController.animateTo(0,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeIn);
                  },
                  child: _buildAppBar(context))),
          body: _buildPageBody(context),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    // final settings = ScopedModel.of<TopicSettings>(context);

    return ScopedModelDescendant<TopicSettings>(
        builder: (context, child, settings) {
      return AppBar(
        title: ScopedModelDescendant<_DataSource>(
          builder: (context, child, model) =>
              Text((_dataSource.topic?.title) ?? "..."),
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

  Widget _buildPostsView(BuildContext context, ScrollController controller,
      _DataSource dataSource) {
    return ScopedModelDescendant<_DataSource>(
      builder: (context, child, model) {
        print("ScopedModelDescendant ${model.name} build ...");
        print("ScopedModelDescendant ${model.topic.title} build ...");
        print("ScopedModelDescendant ${model.topic.content.length} build ...");

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

var _samples = {
  "boardId": "31",
  "forumName": "公路山地",
  "topic": {
    "create_date_value": "2019-06-16T01:46:54.000Z",
    "activityInfo": null,
    "content": [
      {
        "aid": null,
        "infor": "开门见山\r\n碳圈：方远c3碟刹圈（开口）\r\n花鼓：久裕411+412（桶轴中锁）\r\n辐条：cx ray",
        "originalInfo": null,
        "type": 0
      },
      {
        "aid": 1329587,
        "infor":
            "http://bbs.77bike.com/mobcent/app/runtime/images/xgsize/Mon_1906/31_52_cbcd8e7627e6353.jpg",
        "originalInfo":
            "http://bbs.77bike.com/attachment/thumb/Mon_1906/31_52_cbcd8e7627e6353.jpg",
        "type": 1
      },
      {
        "aid": null,
        "infor": "\r\n\r\n\r\n重量1319g\r\n",
        "originalInfo": null,
        "type": 0
      },
      {
        "aid": 1329588,
        "infor":
            "http://bbs.77bike.com/mobcent/app/runtime/images/xgsize/Mon_1906/31_52_c3c1ca50af178bf.jpg",
        "originalInfo":
            "http://bbs.77bike.com/attachment/thumb/Mon_1906/31_52_c3c1ca50af178bf.jpg",
        "type": 1
      },
      // [mobcent_phiz=http://bbs.77bike.com/images/post/smile/qq/12.gif]
      // {
      //   "aid": null,
      //   "infor":
      //       "\r\n\r\n\r\n经常看到有人说碟刹重，[mobcent_phiz=http://bbs.77bike.com/images/post/smile/qq/12.gif]我真的不知道碟刹重在哪里\r\n\r\n造价约5000整\r\n\r\n这对轮组是群里白云帮扛把子的\r\n为了让我暂停训练给他编轮组，骑游假装抽筋让我拉爆，演的真好！[ 此帖被光光在2019-06-16 10:34重新编辑 ]",
      //   "originalInfo": null,
      //   "type": 0
      // },
      {
        "aid": null,
        "infor":
            "\r\n\r\n\r\n经常看到有人说碟刹重，我真的不知道碟刹重在哪里[mobcent_phiz=http://bbs.77bike.com/images/post/smile/qq/12.gif]\r\n\r\n造价约5000整\r\n\r\n这对轮组是群里白云帮扛把子的\r\n为了让我暂停训练给他编轮组，骑游假装抽筋让我拉爆，演的真好！[ 此帖被光光在2019-06-16 10:34重新编辑 ]",
        "originalInfo": null,
        "type": 0
      }
    ],
    "create_date": "1560649614000",
    "essence": 0,
    "extraPanel": [],
    "falg": 0,
    "gender": 0,
    "hits": 1259,
    "icon": "http://bbs.77bike.com/attachment/upload/52/52.jpg",
    "is_favor": 0,
    "level": null,
    "location": "",
    "mobileSign": "",
    "rateList": {
      "ping": "",
      "head": {"field1": "共1条评分", "field2": "威望+7,"},
      "body": [
        {"field1": "azuretears", "field2": "威望 +7", "field3": "06-18"}
      ],
      "showAllUrl":
          "http://bbs.77bike.com/mobcent/app/web/index.php?r=forum/ratelistview&fid=31&tid=301614&sdkVersion=2.4.0&accessToken=&accessSecret="
    },
    "replies": 60,
    "reply_posts_id": 0,
    "reply_status": 1,
    "sortId": 42,
    "status": 1,
    "title": "[公路秀车]【预感】将成为公式化的公路碟刹碳刀",
    "topic_id": 301614,
    "type": "normal",
    "userTitle": "论坛版主",
    "user_nick_name": "光光",
    "user_id": 52
  },
  "list": [
    {
      "posts_date_value": "2019-07-19T08:06:11.000Z",
      "gender": 2,
      "level": 2.7325,
      "location": "",
      "icon": "http://bbs.77bike.com/attachment/upload/middle/56/107556.jpg",
      "position": 60,
      "posts_date": "1563523571000",
      "mobileSign": "",
      "is_quote": 0,
      "quote_pid": "",
      "quote_content": "",
      "quote_user_name": "",
      "reply_content": [
        {
          "aid": null,
          "infor": "这个讨论让我想起装2个小时nbr的恐惧~",
          "originalInfo": null,
          "type": 0
        }
      ],
      "reply_id": 107556,
      "reply_name": "鸡龟骨滚羹",
      "reply_posts_id": 4962795,
      "reply_status": 1,
      "reply_type": "normal",
      "status": 1,
      "title": "",
      "userTitle": "高二",
      "role_num": ""
    },
    {
      "posts_date_value": "2019-07-19T08:03:55.000Z",
      "gender": 2,
      "level": 2.7325,
      "location": "",
      "icon": "http://bbs.77bike.com/attachment/upload/middle/56/107556.jpg",
      "position": 59,
      "posts_date": "1563523435000",
      "mobileSign": "",
      "is_quote": 0,
      "quote_pid": "",
      "quote_content": "",
      "quote_user_name": "",
      "reply_content": [
        {
          "aid": null,
          "infor":
              "[mobcent_phiz=http://bbs.77bike.com/images/post/smile/qq/3.gif] 白云帮消费力恐怖啊~",
          "originalInfo": null,
          "type": 0
        }
      ],
      "reply_id": 107556,
      "reply_name": "鸡龟骨滚羹",
      "reply_posts_id": 4962794,
      "reply_status": 1,
      "reply_type": "normal",
      "status": 1,
      "title": "",
      "userTitle": "高二",
      "role_num": ""
    },
    {
      "posts_date_value": "2019-07-17T06:04:15.000Z",
      "gender": 1,
      "level": 6.6557142857143,
      "location": "",
      "icon": "http://bbs.77bike.com/attachment/upload/middle/90/33590.jpg",
      "position": 58,
      "posts_date": "1563343455000",
      "mobileSign": "",
      "is_quote": 0,
      "quote_pid": "",
      "quote_content": "",
      "quote_user_name": "",
      "reply_content": [
        {
          "aid": null,
          "infor": "精彩辩论啊\r\n\r\n来自[Android]手机客户端",
          "originalInfo": null,
          "type": 0
        }
      ],
      "reply_id": 33590,
      "reply_name": "琴飞扬",
      "reply_posts_id": 4962288,
      "reply_status": 1,
      "reply_type": "normal",
      "status": 1,
      "title": "",
      "userTitle": "大学生",
      "role_num": ""
    },
    {
      "posts_date_value": "2019-06-27T02:17:59.000Z",
      "gender": 0,
      "level": null,
      "location": "",
      "icon": "http://bbs.77bike.com/attachment/upload/52/52.jpg",
      "position": 57,
      "posts_date": "1561601879000",
      "mobileSign": "",
      "is_quote": 1,
      "quote_pid": "",
      "quote_content":
          "alanyu:\n\n果真是逻辑能力差。浙江沪的路面，铺设好维护好的那些是全国一流你不否认吧？用好的vs好的有问题吗？然后太~子~尖，雨骑，虞山，烂vs烂有问题吗？听说太~子~尖已经修好了，我没能享受到。至于太~子~尖修好前路有多差，你随便问问就知道。我一开始就提到的“国内公路党喜欢走的常规路面”，到了你这就成了“全国的路面”。\n\n来阵风确实不止10W了，可惜风不会一直有，绕的圈也只有是1.3km 1小时+，常用圈之一。P1 130W，rubino 140W不到，我可不是胖子要150W才能维持30速度。4000之前同轮子没有两条一起用过我没法比较。",
      "quote_user_name": "alanyu",
      "reply_content": [
        {
          "aid": null,
          "infor":
              "\r\n问题就在于你有什么资格代表国内公路党？\r\n一开口就欧洲公路党，国内公路党？谁愿意被你代表？\r\n骑个太 子尖而已，天天当大事说。欧洲是你说的，结果也就是个瑞士而已，剩下全靠科学上网？\r\n还国内公路党喜欢走的常规路面，什么叫常规路面，国内没烂路？国内没修路？\r\n你为什么那么怕国内公路党走烂路？是怕发现他们没用真空胎也可以走烂路吧！\r\n\r\n国内就是如此，我周围的朋友，几乎全部开口胎，也的确有用过真空胎的，最后全部换成开口胎。\r\n然后你又要说：“你们这是浅藏辄止！”\r\n人家真空爆胎都摔到髋骨骨折了，再不止命都没了[mobcent_phiz=http://bbs.77bike.com/images/post/smile/qq/86.gif]\r\n\r\n真不知道你哪里来的勇气敢用功率计去人肉测胎阻\r\n你这么厉害，那些实验室都可以关门了，寄几条胎给你评测就行啦。\r\n你测试环境每次都一样吗\r\n每圈的风速风向都一样吗\r\n每次温度湿度都一样吗\r\n你每次的胎压都控制一样吗\r\n你每次体重都一样吗\r\n你每次穿的骑行服都一样吗\r\n你每次用的姿势都一样吗\r\n你每次水壶里的水装的容量都一样吗\r\n你就能保证你每次功率计的测量状态一模一样吗[mobcent_phiz=http://bbs.77bike.com/images/post/smile/qq/83.gif]\r\n\r\n你又给真空胎加了一个玄学优势，抓地力，增加了多少抓地力呢，非常明确又是多明确呢\r\n真的是张口就来。\r\n\r\n1真空胎换胎手不痛那是有鬼了，你真以为没人用过真空胎？编瞎话要有底线\r\n\r\n2刺鼻的化学液体无 毒无污染？那你天天吸一下好了。你自己作死无所谓，别害别人\r\n换胎就换胎，为什么要扯到大保健，其实太简单了，你也怕自补液对人 体有害，所以才要带手套\r\n抱歉，开口胎真不需要带手套，偷换概念没意思。\r\n\r\n3多备几种外胎经常换就是有色眼镜？这是开口胎的优势，无论什么眼镜也改变不了\r\n真空胎你经常换几对胎试试，满屏幕的自补液和刺鼻气温其实带个口罩更好\r\n\r\n4吃过真空胎亏换回开口胎有问题吗？\r\n用真空胎路边爆胎，换不了胎，回不了家的\r\n真空胎爆胎摔骨折了\r\n用真空胎自补液弄得家里又脏又臭\r\n你有什么权利说别人浅藏辄止？？？\r\n不过有一点你说对了，真空胎就是个坑，还深到膝盖了，哈哈哈\r\n\r\n5精度指的是真空气密性精度，你理解成劣质圈，哈哈哈，来搞笑的吗\r\n你这逻辑也是无敌，气密性有问题就一定是劣质产品\r\n反正出了事都是临时工[mobcent_phiz=http://bbs.77bike.com/images/post/smile/qq/86.gif]\r\n深圳那条gp5000漏气漏的满盆气泡，一定是劣质马牌\r\n\r\n6瞬间漏气必然是真空最快\r\n管胎和开口是2层结构，管胎也是有内胎的\r\n只有真空是一层外胎。漏气必然最快\r\n\r\n吃过真空胎的亏，这可是实实在在的亏，看得见摸得着\r\n为了玄学体验去吃实体的亏，不知道这算不算智商税[mobcent_phiz=http://bbs.77bike.com/images/post/smile/qq/83.gif]\r\n\r\n\r\n\r\n\r\n",
          "originalInfo": null,
          "type": 0
        }
      ],
      "reply_id": 52,
      "reply_name": "光光",
      "reply_posts_id": 4960160,
      "reply_status": 1,
      "reply_type": "normal",
      "status": 1,
      "title": "回 alanyu 的帖子",
      "userTitle": "论坛版主",
      "role_num": ""
    },
    {
      "posts_date_value": "2019-06-26T21:11:55.000Z",
      "gender": 0,
      "level": 1.67,
      "location": "",
      "icon": "http://bbs.77bike.com/images/face/none.gif",
      "position": 56,
      "posts_date": "1561583515000",
      "mobileSign": "",
      "is_quote": 1,
      "quote_pid": "",
      "quote_content":
          "光光:江浙沪国内属于一流，所以你骑过江浙沪就等于去过全国？\n这次怎么不来同事帮忙了？\n\n功率计能测滚阻，这是我见过最可笑的言论，你功率计精度多少啊\n....... (2019-06-26 20:44) ",
      "quote_user_name": "光光",
      "reply_content": [
        {
          "aid": null,
          "infor":
              "\r\n果真是逻辑能力差。浙江沪的路面，铺设好维护好的那些是全国一流你不否认吧？用好的vs好的有问题吗？然后太~子~尖，雨骑，虞山，烂vs烂有问题吗？听说太~子~尖已经修好了，我没能享受到。至于太~子~尖修好前路有多差，你随便问问就知道。我一开始就提到的“国内公路党喜欢走的常规路面”，到了你这就成了“全国的路面”。\r\n\r\n来阵风确实不止10W了，可惜风不会一直有，绕的圈也只有是1.3km 1小时+，常用圈之一。P1 130W，rubino 140W不到，我可不是胖子要150W才能维持30速度。4000之前同轮子没有两条一起用过我没法比较。\r\n功率计精度在一定范围内，要么整体偏大要么整体偏小。忽然一段偏大又一段偏小，那叫电子垃圾。别用什么精度来偷换概念。\r\n除去滚阻，才想到还有个优点就是抓地力，P1和5000TL的抓地力>race A evo 3+4000，压弯体会是非常明确地\r\n\r\n1，5~10分钟这个量就摆在这里，你想说多就是多。手痛？我不知道你怎么会手痛，大概是以为真空胎要靠大力出奇迹。\r\n\r\n2，粉末是什么鬼？ doc blue要么液体要么凝固，液体直接餐巾纸。我并没有不承认自补液难闻，但是污染？大概世文马牌自补液的欧盟认证都是假的。至于“大宝剑”，自己回滚原文去看我为什么要提到“大宝剑”和“手套”，别断章取义。哦对了，你断章取义确实很厉害\r\n\r\n3，戴着有色眼镜不承认优点只放大缺点的人当然嫌麻烦。\r\n\r\n3.5，悬崖勒马？我看你是前面有个刚到膝盖的水坑就退缩了。\r\n\r\n4，圈的精度？为什么要买劣质圈？你作为一个编圈高手，难道会用低精度或被辐条拉波浪的圈？\r\n气嘴问题？同样为什么要劣质气嘴？淘宝上的台产气嘴不贵，气密性也很好。补胎液摇匀？我自己倒是不怎么摇doc blue。再想想你提到的粉末，污染，怕用的是国内一些颗粒自补液吧。胎的精度？那么是我运气那么好，使用、测试的那么多胎，都是顶尖的精度？哦不对，我的倍耐力还是条次品，没多久就鼓包了，肢解以后纤维层有问题，可就是这次品都能保持气密性。\r\n\r\n5，瞬间漏气？口子大了开口管胎真空全都是瞬间漏气。这还能怪胎上了？我自己也经历过前轮开口胎被割裂爆了直接后轮飞起来，不过速度不太快没出大事。更多是扎个小洞，“呲~~~”滚了十几米瘪掉的。真空扎了好几次，自补液没补上的就两次，一次是侧面大口子大概3秒没气，一次正面被三角钉干了，“呲~~”十几米。",
          "originalInfo": null,
          "type": 0
        }
      ],
      "reply_id": 163033,
      "reply_name": "alanyu",
      "reply_posts_id": 4960022,
      "reply_status": 1,
      "reply_type": "normal",
      "status": 1,
      "title": "回 光光 的帖子",
      "userTitle": "小学一年级",
      "role_num": ""
    },
    {
      "posts_date_value": "2019-06-26T15:36:58.000Z",
      "gender": 1,
      "level": 1.92928,
      "location": "",
      "icon": "http://bbs.77bike.com/attachment/upload/55/5055.jpg",
      "position": 55,
      "posts_date": "1561563418000",
      "mobileSign": "",
      "is_quote": 0,
      "quote_pid": "",
      "quote_content": "",
      "quote_user_name": "",
      "reply_content": [
        {
          "aid": null,
          "infor": "除了骑车强，连辩论都咁强。。。厉害。。。",
          "originalInfo": null,
          "type": 0
        }
      ],
      "reply_id": 5055,
      "reply_name": "dog12",
      "reply_posts_id": 4959978,
      "reply_status": 1,
      "reply_type": "normal",
      "status": 1,
      "title": "",
      "userTitle": "硕士",
      "role_num": ""
    },
    {
      "posts_date_value": "2019-06-26T12:44:33.000Z",
      "gender": 0,
      "level": null,
      "location": "",
      "icon": "http://bbs.77bike.com/attachment/upload/52/52.jpg",
      "position": 54,
      "posts_date": "1561553073000",
      "mobileSign": "",
      "is_quote": 1,
      "quote_pid": "",
      "quote_content":
          "alanyu:浙江沪好的路面在国内是不是属于国内一流的？用国内一流的路面对比欧洲一流的瑞士路面，瑞士差一点。太~尖~路修好前那路面还是雨骑。或者说你属于国内少部分的CX gravel党专挑烂路骑？那我无话可说，至少我还是尽可能避免超级烂路。\n\n滚阻差异，有功率计的正常人都能骑出来，P1  ..(2019-06-26 19:29)",
      "quote_user_name": "alanyu",
      "reply_content": [
        {
          "aid": null,
          "infor":
              "\r\n江浙沪国内属于一流，所以你骑过江浙沪就等于去过全国？\r\n这次怎么不来同事帮忙了？\r\n\r\n功率计能测滚阻，这是我见过最可笑的言论，你功率计精度多少啊\r\n2%的误差150w都正负差6w了，来阵风都不值10w了\r\n\r\n再说你竟然用p1和rubino pro对比，是一个级别的东西吗，能不能有点自信？\r\n\r\n1装胎多5-10分钟就不算时间吗？快拆也就比拧螺母快几分钟呢\r\n有撬胎棒和没撬胎棒不算差距吗？\r\n手痛和手不痛不敢提吗？\r\n论坛多少人用nbr装胎痛不欲生，真空系统比nbr更恐怖\r\n\r\n2自补液你怎么打包回收，用什么装，怎么储存？液体和粉 末打包方便吗？要花多长时间？\r\n好想看你打包自补液的样子[mobcent_phiz=http://bbs.77bike.com/images/post/smile/qq/13.gif]\r\n压根就没人说过给车保健的事，换胎哪里来的油污\r\n也只有真空胎换胎才会有自补液污染，开口胎哪来的污染，哪来的手套\r\n真空胎这些麻烦，正常人都看得出，有色眼镜的人才选择性忽略\r\n\r\n3同理1，换一条胎都嫌烦，两条一起换试试？\r\n\r\n3.5打气你说能打进就打进吧，哈哈，反正说真空胎换胎不麻烦也是你\r\n真空胎第一次打气试过的人都知道是个什么鬼体验，好了，这里你又可以发挥说别人浅尝辄止\r\n这不叫浅尝辄止，这叫悬崖勒马，不伺候这种大爷\r\n\r\n4.打气一天一次很奇怪吗？\r\n圈的精度，胎的精度，圈和胎的精度匹配\r\n真空气嘴的瑕疵，自补液没摇匀\r\n任何一个环节有问题，漏气。\r\n不过那种喜欢伺候大爷的人应该也不会觉得麻烦[mobcent_phiz=http://bbs.77bike.com/images/post/smile/qq/20.gif]\r\n\r\n我还要再加一条\r\n5真空胎爆胎是很危险的\r\n真空胎爆胎往往是瞬间漏气，人根本没有反应的时间\r\n上个月的brm200，有人就是用真空胎在终点前爆胎，前轮瞬间瘪掉\r\n来不及反应摔车，髋骨骨折\r\n这人事后在群里说，如果有内胎，不会这么快失控。打死再不用真空胎\r\n\r\n",
          "originalInfo": null,
          "type": 0
        }
      ],
      "reply_id": 52,
      "reply_name": "光光",
      "reply_posts_id": 4959876,
      "reply_status": 1,
      "reply_type": "normal",
      "status": 1,
      "title": "回 alanyu 的帖子",
      "userTitle": "论坛版主",
      "role_num": ""
    },
    {
      "posts_date_value": "2019-06-26T11:29:01.000Z",
      "gender": 0,
      "level": 1.67,
      "location": "",
      "icon": "http://bbs.77bike.com/images/face/none.gif",
      "position": 53,
      "posts_date": "1561548541000",
      "mobileSign": "",
      "is_quote": 1,
      "quote_pid": "",
      "quote_content":
          "光光:原来在你眼中，骑过江浙沪就等于全国\n难怪你骑过瑞士就等于欧洲\n剩下全靠同事对吧？再不行上上网上上论坛，完全可以点评全世界路况了！\n\n....... (2019-06-26 18:58) ",
      "quote_user_name": "光光",
      "reply_content": [
        {
          "aid": null,
          "infor":
              "\r\n浙江沪好的路面在国内是不是属于国内一流的？用国内一流的路面对比欧洲一流的瑞士路面，瑞士差一点。太~尖~路修好前那路面还是雨骑。或者说你属于国内少部分的CX gravel党专挑烂路骑？那我无话可说，至少我还是尽可能避免超级烂路。\r\n\r\n滚阻差异，有功率计的正常人都能骑出来，P1 只需要30速度单飞绕圈，就按我正常的胎压打法，相比rubino pro 节省6~10W。\r\n\r\n1，装胎。你继续带着有色眼镜说话就是了，我给出了具体时间，真空慢5~10分钟\r\n\r\n2，自补液餐巾纸我确实打包回收，骑行吃香蕉香蕉皮都得带到正确的有机垃圾桶扔\r\n我写的是“给保健车子的时候”戴手套，到了你这天天戴手套？曲解文字真是厉害啊。油污难洗，自补液用过的doc blue和effetto都可以用餐巾纸擦掉。\r\n\r\n3，开口是可以用几套外胎，我没有否认，但是我真空也一样用两套。只不过以前用开口也不会碰超轻胎。\r\n\r\n3.5，目前P1,AC0,5000TL,RACE0,CINTURATO都是用落地气筒打气，包括新胎。要什么气泵。5000TL甚至优化的非常好，用GM81这种便携式气筒都能打起来。只有FORMULA RBCC需要气瓶，但同时这个胎各方面性能也不值他的价位。\r\n\r\n4，漏气一天一次？自补液是不是公路？高压嘴和胎垫有没有装好？我现在用过测试过的公路真空，包括P1,AC0,FORMULA RBCC,5000TL,RACE0,CINTURATO，加上doc blue从气密性上都可以一周一次。尝试过用effetto山地很好用的补胎液，可惜是山地用的只能封30psi。\r\n\r\n\r\n浅尝辄止的人就少口嗨。\r\n",
          "originalInfo": null,
          "type": 0
        }
      ],
      "reply_id": 163033,
      "reply_name": "alanyu",
      "reply_posts_id": 4959831,
      "reply_status": 1,
      "reply_type": "normal",
      "status": 1,
      "title": "回 光光 的帖子",
      "userTitle": "小学一年级",
      "role_num": ""
    },
    {
      "posts_date_value": "2019-06-26T10:58:48.000Z",
      "gender": 0,
      "level": null,
      "location": "",
      "icon": "http://bbs.77bike.com/attachment/upload/52/52.jpg",
      "position": 52,
      "posts_date": "1561546728000",
      "mobileSign": "",
      "is_quote": 1,
      "quote_pid": "",
      "quote_content":
          "alanyu:张口就来？\n那也是你张口就来，好歹我住在瑞士知道这里的路况，德国英国波兰出差去过，有各国的同事分享经验，去论坛上看看大家的观点。你全靠YY欧洲路面真tm好，还不信别人的说法。\n\n国内江浙沪范围的国道省道乡道村道，其中铺装路面，国内可不像这里的城市路面维护少，几条刚刚 ..(2019-06-26 17:19)",
      "quote_user_name": "alanyu",
      "reply_content": [
        {
          "aid": null,
          "infor":
              "\r\n原来在你眼中，骑过江浙沪就等于全国\r\n难怪你骑过瑞士就等于欧洲\r\n剩下全靠同事对吧？再不行上上网上上论坛，完全可以点评全世界路况了！\r\n\r\n看来玩公路真空胎还要先玩山地真空才能懂\r\n我还刚好是玩过山地真空胎，所以我绝对不会碰公路真空胎\r\n所以优点是不是说完了？说来说去就所谓的路感吧，你千万别说你还能感受到滚阻差异啊[mobcent_phiz=http://bbs.77bike.com/images/post/smile/qq/13.gif]\r\n\r\n\r\n缺点1 装胎困难\r\n要技巧正好说明有难度\r\n开口胎我徒手就能轻松拆装，不需要技巧，不需要撬胎棒，甚至都不需要时间，敢比吗。\r\n你问问上海车店老板，敢比吗\r\n\r\n2自补液污染问题\r\n我就想问户外爆胎你自补液残渣残液怎么处理，瑞士可以倒在路边吗？\r\n你会打包回收吗？你是揣兜里，还是放包里？\r\n我用开口胎，为什么要带手套？\r\n我用开口胎，哪里来的油污？\r\n你用真空胎，所以你要带手套，所以你必须接受满手刺鼻性化学品。明白差距了吗？\r\n\r\n3无法简单换胎\r\n玩真空胎还要准备几对轮子？这就是真空胎的硬伤，和管胎一样，换胎麻烦，不得不准备几套轮组。\r\n一套轮组为什么不能用几套外胎？开口胎就可以啊！\r\n下雨我就用带花纹的胎，晴天就光胎，长途就换耐力胎\r\n开口胎就是这么方便，真空胎敢比吗\r\n\r\n我这里还要加个问题3.5\r\n3.5真空胎第一次打气的问题\r\n家里没气泵别玩真空胎了\r\n真空胎第一次打气，气筒是不可能的，气瓶不一定成功\r\n当然你有钱颗买一箱气瓶慢慢试，总会成功一次\r\n所以结合问题3，如果家里没气泵，换一次胎，就要出门去找气泵。有意思吗？\r\n\r\n4漏气问题\r\n漏气严重的一天打一次，比如刚出的gp5000\r\n深圳一哥们第一天gp5000真空走起，第二天老老实实装回内胎\r\n\r\n这5个和骑车密切相关的问题，一个也回避不了\r\n换个胎你还要去找上海车店老板\r\n这是骑车，还是在伺候大爷呢？\r\n\r\n到底是谁在避重就轻?\r\n\r\n",
          "originalInfo": null,
          "type": 0
        }
      ],
      "reply_id": 52,
      "reply_name": "光光",
      "reply_posts_id": 4959819,
      "reply_status": 1,
      "reply_type": "normal",
      "status": 1,
      "title": "回 alanyu 的帖子",
      "userTitle": "论坛版主",
      "role_num": ""
    }
  ],
  "img_url": "",
  "forumTopicUrl": "http://bbs.77bike.com/m/index.php?a=read&tid=301614",
  "page": 1,
  "has_next": 1,
  "total_num": 61,
  "noError": true,
  "rs": 1,
  "errcode": 0,
  "head": {
    "alert": 0,
    "errCode": 0,
    "errInfo": "调用成功,没有任何错误",
    "version": "2.4.0.1"
  }
};
