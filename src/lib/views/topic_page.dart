import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qiqi_bike/common/data_helper.dart';
import 'package:qiqi_bike/core/application.dart';
import 'package:qiqi_bike/core/datasource.dart';
import 'package:qiqi_bike/models/forum/forum_postlist.dart';
import 'package:qiqi_bike/views/board_page.dart';
import 'package:qiqi_bike/views/topic_editor_page.dart';
import 'package:qiqi_bike/views/webview_page.dart';
import 'package:qiqi_bike/widgets/emoji_text_widget.dart';
import 'package:qiqi_bike/widgets/popup_menu_ex.dart' as ex;
import 'package:qiqi_bike/widgets/post_image_widget.dart';
import 'package:qiqi_bike/widgets/user_avatar_widget.dart';
import 'package:scoped_model/scoped_model.dart';

import '../api/mobcent_client.dart';
import 'image_viewer.dart';
import 'user_login_page.dart';

class PostDataModel {
  PostTopic topic;
  List<PostReply> items = [];
}

class PostDataSource extends DataSource<PostDataModel> {
  final int boardId;
  final int topicId;

  PostDataSource({this.boardId = 0, this.topicId, int order})
      : super(initValue: PostDataModel(), order: order ?? 0) {}

  @override
  Future<bool> onLoad(bool isReload) async {
    try {
      var response = await MobcentClient.instance.postList(
          topicId: topicId, authorId: 0, page: this.page, order: order);
      if (!response.noError) {
        this.message = response.head.errInfo;
        return false;
      }
      for (var reply in response.list) {
        fixIosProblem(reply?.reply_content);
      }

      /// 修正总记录数
      this.total =
          response.total_num == null ? null : (response.total_num ?? 1) - 1;

      if (isReload) {
        this.value.items.clear();
      }

      /// 追加新的数据
      this.value.items.addAll(response.list ?? []);

      /// 是否有更多记录
      this.hasMore = !((response.has_next == 0) ||
          (this.total == this.value.items.length));

      /// 只有首次才需要设置主题帖
      this.value.topic ??= response.topic;

      print("VALUE =>${this.value.items.length} ");

      return true;
    } catch (exp) {
      print("$exp");
      this.message = exp.toString();
      return false;
    }
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

class TopicPage extends StatefulWidget {
  final int boardId;

  final int topicId;

  final String title;

  TopicPage({this.boardId, this.topicId, this.title})
      : assert(boardId != null),
        assert(topicId != null);

  @override
  _TopicPageState createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  PostDataSource _dataSource;

  // _DataSource _dataSource;
  ScrollController _scrollController = ScrollController();
  TopicSettings _topicSettings;
  Offset fabPosition = Offset(0, 0);

  @override
  void initState() {
    super.initState();
    final settings = ApplicationCore.settings;

    _topicSettings = TopicSettings(
        textMode: settings.textMode == 1, smallImage: settings.smallImage == 1);

    _dataSource = PostDataSource(
        boardId: widget.boardId,
        topicId: widget.topicId,
        order: settings.reverseOrder);
//    _dataSource = _DataSource("主题${widget.topicId}",
//        boardId: widget.boardId,
//        topicId: widget.topicId,
//        order: settings.reverseOrder);
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
    return ScopedModel<PostDataSource>(
      model: _dataSource,
      child: ScopedModel<TopicSettings>(
        model: _topicSettings,
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: _buildAppBar(context)),
          floatingActionButton: FloatingActionButton(
            mini: true,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    if ((ApplicationCore.session.uid ?? 0) == 0) {
                      /// 登录
                      return UserLoginPage();
                    }

                    /// 普通回帖
                    return TopicEditorPage(
                        boardId: widget.boardId, topicId: widget.topicId);
                  },
                  fullscreenDialog: true));
            },
            child: Icon(Icons.reply),
          ),
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
        title: ScopedModelDescendant<PostDataSource>(
            builder: (context, child, model) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onDoubleTap: () {
              _scrollController.animateTo(0,
                  duration: Duration(milliseconds: 200), curve: Curves.easeIn);
            },
            child: Row(
              children: <Widget>[
                Text(ApplicationCore.forum.boards[model.boardId]?.board_name ??
                    ""),
              ],
            ),
          );
        }),
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
        Scrollbar(
            child: _buildPostsView(context, _scrollController, _dataSource)),
        _dataSource);
  }

  Widget _wrapRefresh(Widget widget, DataSource dataSource) {
    return RefreshIndicator(
        onRefresh: () async {
          await dataSource.reload();
          return Future.value();
        },
        child: widget);
  }

  Widget _buildPostsView(BuildContext context, ScrollController controller,
      DataSource dataSource) {
    return ScopedModelDescendant<PostDataSource>(
      builder: (context, child, ds) {
        final model = ds.value;
        final itemCount = model.items.length + 3; // 主题帖 + 评分行 + 尾行

        return ListView.builder(
            controller: controller,
            physics: AlwaysScrollableScrollPhysics(),
            // cacheExtent: 0,
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
                if (_dataSource.hasMore) {
                  return Container(
                    padding: EdgeInsets.only(top: 16, bottom: 16),
                    child: CupertinoButton(
                      child:
                          Text(_dataSource.isloading ? "正在加载..." : "加载更多 ..."),
                      onPressed: _dataSource.isloading
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
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              margin: const EdgeInsets.only(bottom: 4),
              child: Text(
                widget.title ?? topic?.title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )),
          _buildUserDetailWidget(
              context, topic.icon, topic.user_nick_name, topic.userTitle),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Divider(height: 1),
          ),
          ...topic.content.map((content) => PostContentWidget(
                content,
                onTapImage: (image) async {
                  final images = topic.content
                      .where((item) => item.type == 1)
                      .map((item) => item.originalInfo)
                      .toList();
                  await showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (context) {
                        return ImageViewer(
                            initImage: image,
                            images: images.where((i) => i != null).toList());
                      });
                },
              )),
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
          ...model.reply_content.map((content) => PostContentWidget(
                content,
                onTapImage: (image) async {
                  final images = model.reply_content
                      .where((item) => item.type == 1)
                      .map((item) => item.originalInfo)
                      .toList();
                  await showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (context) {
                        return ImageViewer(
                            initImage: image,
                            images: images.where((i) => i != null).toList());
                      });
                },
              )),
          if (!DataHelper.isIsNullOrWhiteSpaceString(model.quote_content))
            PostQuoteWidget(model),
          _buildReplyBottomWidget(context, model),
        ],
      ),
    );
  }

  _buildTopicBottomWidget(BuildContext context, PostTopic model) {
    final zan = model.extraPanel?.firstWhere((panel) => panel.type == "support",
        orElse: () => ExtraPanel());
    final int zanValue = (zan?.extParams ?? {})["recommendAdd"] ?? 0;
    final int zanAdded = (zan?.extParams ?? {})["isHasRecommendAdd"] ?? 0;

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
                Icons.thumb_up,
                color: zanAdded > 0
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade400,
                size: 18,
              ),
              label: Text(zanValue.toStringAsFixed(0))),
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
          ReplyTopicWidget(
            model,
            onPressed: () {
              Navigator.of(context)
                  .push<bool>(MaterialPageRoute(
                      builder: (context) {
                        if ((ApplicationCore.session.uid ?? 0) == 0) {
                          /// 登录
                          return UserLoginPage();
                        }

                        /// 引用回帖
                        return TopicEditorPage(
                          boardId: widget.boardId,
                          topicId: widget.topicId,
                          replyId: model.reply_posts_id,
                        );
                      },
                      fullscreenDialog: true))
                  .then((value) {
                if (value != null && value) {
                  /// TODO: 因为是在原地弹出的回复页面,因此编辑完成之后,也不需要刷新显示
                  _dataSource.reload();
                }
              });
            },
          )
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
                RawMaterialButton(
//                  color: Colors.grey.shade300,
//                  icon: Icon(Icons.star_half, color: Colors.amberAccent),
//                  label: Text("我要评分"),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.star_half,
                            color: Colors.amberAccent, size: 20),
                        Text(
                          "我要评分",
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  fillColor: Colors.grey.shade200,
                  constraints:
                      const BoxConstraints(minWidth: 88.0, minHeight: 24.0),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  onPressed: () {
                    final url = ApplicationCore.buildActionUrl(
                        "forum/topicrate",
                        extParameters: <String, String>{
                          "fid": widget.boardId.toStringAsFixed(0),
                          "tid": widget.topicId.toStringAsFixed(0),
                          "act": "ping",
                          "pid": "tpc",
                          "type": "ping"
                        });
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) =>
                              WebViewPage(title: "评分", url: url),
                          fullscreenDialog: true),
                    );
                  },
                )
              ],
            ),
          ),
          // Container(child: Ro,)
          GestureDetector(
            onTap: () {
              final url = ApplicationCore.buildActionUrl("forum/ratelistview",
                  extParameters: <String, String>{
                    "fid": widget.boardId.toStringAsFixed(0),
                    "tid": widget.topicId.toStringAsFixed(0)
                  });
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => WebViewPage(
                        title: "评分", url: topic?.rateList.showAllUrl),
                    fullscreenDialog: true),
              );
            },
            child: Offstage(
              offstage: rates.length == 0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(flex: 1, child: Text(head.field1 ?? "")),
                    Text(
                      head.field2 ?? "",
                      style:
                          TextStyle(color: Theme.of(context).primaryColorDark),
                    ),
                    Expanded(
                        flex: 1,
                        child: Text(
                          "查看",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: Theme.of(context).primaryColorDark),
                        )),
                  ],
                ),
              ),
            ),
          ),
          if (rates.length > 0)
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
  final VoidCallback onPressed;

  const ReplyTopicWidget(this.model, {Key key, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
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

class PostContentWidget extends StatelessWidget {
  final String debugLabel;
  final PostContent content;
  final void Function(String image) onTapImage;

  PostContentWidget(this.content, {this.debugLabel, this.onTapImage});

  @override
  Widget build(BuildContext context) {
    switch (content.type) {
      case 0:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: EmojiTextWidget(
              emojiSize: 22,
              text: content.infor,
              textStyle: TextStyle(fontSize: 18, color: Colors.black)),
        );
      case 1:
        return imageSegment(context, onTapImage: this.onTapImage);
      case 4:
        return atSegment(context);
      default:
        return Container();
    }
  }

  Widget textSegment(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          content.infor,
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

  Widget imageSegment(BuildContext context,
      {void Function(String image) onTapImage}) {
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
              : PostImageWidget(content.originalInfo,
                  borderRadius: 8, onTapImage: onTapImage),
        );
      },
    );
  }

  Widget atSegment(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          content.infor,
          style: TextStyle(fontSize: 15, color: Color(0xff001ba0)),
        ));
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
