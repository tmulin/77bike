import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qiqi_bike/api/mobcent_client.dart';
import 'package:qiqi_bike/common/data_helper.dart';
import 'package:qiqi_bike/core/application.dart';
import 'package:qiqi_bike/core/settings.dart';
import 'package:qiqi_bike/models/forum/forum_topiclist.dart' as tp;
import 'package:qiqi_bike/views/topic_page.dart';
import 'package:qiqi_bike/widgets/forum_search_button.dart';
import 'package:qiqi_bike/widgets/topic_image_widget.dart';
import 'package:qiqi_bike/widgets/topic_list_ending.dart';
import 'package:qiqi_bike/widgets/user_avatar_widget.dart';
import 'package:scoped_model/scoped_model.dart';

import '../core/forum.dart';
import 'image_viewer.dart';

class _DataSource extends Model {
  final int boardId;

  final String sortBy;

  /// 数据源名称
  final String name;

  /// 分类编号
  int filterId;

  _DataSource(this.name, {this.boardId = 0, this.filterId = 0, this.sortBy});

  int _itemCount = 0;
  List<tp.Topic> _items = [];

  int get itemCount => _itemCount;

  List<tp.Topic> get items => _items;

  bool _loading = false;
  int _hasMore = 1;
  int _nextPage = 1;

  bool hasMore() {
    return _hasMore > 0;
  }

  bool isLoading() => _loading;

  Future<bool> loadMore({bool clear = false}) async {
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
      var response = await MobcentClient.instance.topicList(
          boardId: boardId,
          filterId: filterId,
          page: _nextPage,
          sortBy: sortBy);
      if (!response.noError) {
        notifyListeners();
        return false;
      }
      print(
          "DataSource ${name} | B:${boardId} F:${filterId} P:${_nextPage} S:${sortBy} loadMore => GOT ${response.list?.length} Topics ...");

      /// 刷新数据源时,清除旧数据(在刷新成功之后再清除旧数据,避免先清空数据导致的页面闪烁)
      if (clear) {
        this._items.clear();
      }

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
    return await this.loadMore(clear: true);
  }
}

class BoardPage extends StatefulWidget {
  final int boardId;

  final String boardName;

  BoardPage({this.boardId = 0, this.boardName});

  @override
  _BoardPageState createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  Classification _class = Classification();
  List<_DataSource> _dataSources = List(4);
  List<ScrollController> _scrollControllers = List(4);
  List<GlobalKey<RefreshIndicatorState>> _refreshIndicators;

  @override
  void initState() {
    super.initState();

    _dataSources[0] = _DataSource("全部",
        boardId: widget.boardId,
        filterId: _class?.id,
        sortBy: tp.TopicListAction.sortByAll);
    _dataSources[1] = _DataSource("最新",
        boardId: widget.boardId,
        filterId: _class?.id,
        sortBy: tp.TopicListAction.sortByNew);
    _dataSources[2] = _DataSource("精华",
        boardId: widget.boardId, sortBy: tp.TopicListAction.sortByMarrow);
    _dataSources[3] = _DataSource("置顶",
        boardId: widget.boardId, sortBy: tp.TopicListAction.sortByTop);

    _dataSources.forEach((ds) => ds.loadMore());

    /// 刷新组件key
    _refreshIndicators = List();
    for (int i = 0; i < _scrollControllers.length; i++) {
      _refreshIndicators.add(GlobalKey());

      final _scrollController = ScrollController();
      _scrollControllers[i] = _scrollController;
      _scrollController.addListener(() {
        final int index = i;
        if (_scrollController.position.maxScrollExtent ==
            _scrollController.position.pixels) {
          print("ScrollController ${index} Reach Bottom , loadMore ...");
          _dataSources[i].loadMore();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _dataSources.length,
      child: Builder(builder: (context) {
        return ScopedModel<Settings>(
          model: ApplicationCore.settings,
          child: Scaffold(
            backgroundColor: Colors.grey.shade200,
            appBar: _buildAppBar(context),
            body: _buildPageBody(context),
          ),
        );
      }),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: GestureDetector(
        onDoubleTap: () {
          _scrollControllers[DefaultTabController.of(context).index].animateTo(
              0,
              duration: Duration(milliseconds: 200),
              curve: Curves.fastOutSlowIn);
        },
        child: _buildBoardTypeSelection(context),
      ),
      titleSpacing: 0,
      centerTitle: true,
      bottom: PreferredSize(
          child: _buildPageTabBar(context), preferredSize: Size.fromHeight(25)),
      actions: <Widget>[const ForumSearchButton()],
    );
  }

  final virtualClasses = <Classification>[
    Classification(name: "全部"),
    Classification(name: "")
  ];

  Widget _buildBoardTypeSelection(BuildContext context) {
    final classes = [
      ...virtualClasses,
      ...(ApplicationCore.forum.boardClasses[widget.boardId] ?? [])
    ];
    return GestureDetector(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(this._class?.id == null
              ? widget.boardName
              : (this._class?.name ?? widget.boardName)),
          if (classes.length > 2) Icon(Icons.arrow_drop_down),
        ],
      ),
      onTap: classes.length == 2
          ? null
          : () async {
              final selectedClassification =
                  await showModalBottomSheet<Classification>(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                      margin: EdgeInsets.only(bottom: 8),
                      child: ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            if (classes[index].name == "") {
                              return Container(
                                height: 8,
                                color: Colors.grey.shade300,
                              );
                            }
                            return ListTile(
                                dense: true,
                                title: Text(classes[index].name),
                                trailing: Icon(Icons.check_circle_outline,
                                    color: classes[index].id == this._class?.id
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey.shade300),
                                onTap: () {
                                  Navigator.pop<Classification>(
                                      context, classes[index]);
                                });
                          },
                          separatorBuilder: (context, index) => Divider(
                                height: 0,
                                color: Colors.grey.shade300,
                              ),
                          itemCount: classes.length));
                },
              );
              final bool changed =
                  this._class?.id != selectedClassification?.id;

              setState(() {
                this._class = selectedClassification ?? Classification();
              });
              if (changed) {
                await this._dataSources.take(2).forEach((ds) async {
                  ds.filterId = this._class?.id;
                  await ds.reload();
                });
              }
            },
    );
  }

  _buildPageTabBar(BuildContext context) {
    return TabBar(
      indicatorSize: TabBarIndicatorSize.label,
      labelPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      tabs: this._dataSources.map((ds) => Text(ds.name)).toList(),
    );
  }

  _buildPageBody(BuildContext context) {
    return TabBarView(children: <Widget>[
      _wrapRefresh(
          _buildTopicsView(context, _scrollControllers[0], _dataSources[0]),
          _dataSources[0],
          key: _refreshIndicators[0]),
      _wrapRefresh(
          _buildTopicsView(context, _scrollControllers[1], _dataSources[1]),
          _dataSources[1],
          key: _refreshIndicators[1]),
      _wrapRefresh(
          _buildTopicsView(context, _scrollControllers[2], _dataSources[2]),
          _dataSources[2],
          key: _refreshIndicators[2]),
      _wrapRefresh(
          _buildTopicsView(context, _scrollControllers[3], _dataSources[3]),
          _dataSources[3],
          key: _refreshIndicators[3]),
    ]);
  }

  Widget _wrapRefresh(Widget widget, _DataSource dataSource, {Key key}) {
    return RefreshIndicator(
        key: key,
        onRefresh: () async {
          await dataSource.reload();
          return Future.delayed(Duration(milliseconds: 100));
        },
        child: widget);
  }

  Widget _buildTopicsView(BuildContext context, ScrollController controller,
      _DataSource dataSource) {
    return ScopedModel(
      model: dataSource,
      child: ScopedModelDescendant<_DataSource>(
        builder: (context, child, model) {
          print("ScopedModelDescendant ${model.name} build ...");

          final itemCount = model.items.length + 1;

          return ListView.builder(
            key: PageStorageKey(model.name),
            controller: controller,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              if (index == itemCount - 1) {
                return TopicListEnding(
                    dataSource.hasMore(), dataSource.isLoading(), () {
                  dataSource.loadMore();
                });
              }

              return _warpTopicItemView(
                _buildTopicItemView(
                    context, index, model.items[index], dataSource.sortBy),
                model.items[index],
              );
            },
          );
        },
      ),
    );
  }

  Widget _warpTopicItemView(Widget itemView, tp.Topic model) {
    Tag tag;
    tag ??= model.top == 0
        ? null
        : Tag(
            label: "顶",
            color: Colors.blue,
          );
    tag ??= model.essence == 0 ? null : Tag(label: "精");
    if (tag == null) {
      return itemView;
    }
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        itemView,
        Positioned(
          top: 8,
          right: 4,
          child: tag,
        )
      ],
    );
  }

  Widget _buildTopicItemView(
      BuildContext context, int index, tp.Topic model, String kind) {
    print("_buildTopicItemView [${index}] => ${model.title} ...");

    Widget widget;

    bool textMode = ScopedModel.of<Settings>(context).textMode == 1;

    if (kind == tp.TopicListAction.sortByNew) {
      widget = Container(
        margin: EdgeInsets.only(top: 8),
        constraints: BoxConstraints(minHeight: 120),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _builtTopicTitleWidget(context, model),
            _buildUserDetailWidgetMini(context, model),
            _buildTopicContentWidget(context, model),
            if (!textMode) _buildTopicImagesWidget(context, model),
            _buildTopicBottomWidget(context, model),
          ],
        ),
      );
    } else {
      /// 帖子主图
      Widget image;

      if (!textMode && !DataHelper.isIsNullOrWhiteSpaceString(model.pic_path))
        image = Container(
          width: MediaQuery.of(context).size.width / 4 - 8,
          padding: EdgeInsets.only(right: 8),
          child: TopicImageWidget(model.pic_path, aspectRatio: 1,
              onTapImage: (image) async {
            await showDialog(
                barrierDismissible: true,
                context: context,
                builder: (context) {
                  return ImageViewer(
                      initImage: image,
                      images: (model.imageList ?? [])
                          .where((i) => i != null)
                          .toList());
                });
          }),
        );

      widget = Container(
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
                      _buildUserDetailWidgetMini(context, model),
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
    }

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
                    )));
          },
          child: widget,
        ),
      ),
    );
  }

  /// 小头像模式用户信息
  _buildUserDetailWidgetMini(BuildContext context, tp.Topic model) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: UserAvatarWidget(
            model.userAvatar,
            width: 24.0,
            height: 24.0,
            borderRadius: 4,
          ),
        ),
        Text(
          model.user_nick_name,
          style: TextStyle(color: Colors.grey.shade800, fontSize: 16),
        ),
      ],
    );
  }

  _builtTopicTitleWidget(BuildContext context, tp.Topic model) {
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

  _buildTopicContentWidget(BuildContext context, tp.Topic model,
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

  _buildTopicImagesWidget(BuildContext context, tp.Topic model) {
    /// 根据屏幕宽度计算图片宽度,并预留16px边距
    final width = MediaQuery.of(context).size.width / 3;
    final images = List<String>();
    images.addAll((model.imageList ?? []).take(3));
    if (images.length == 0 &&
        !DataHelper.isIsNullOrWhiteSpaceString(model.pic_path))
      images.add(model.pic_path);

    if (images.length == 0) {
      return Container(
        height: 0,
      );
    }

    images.addAll(List<String>.filled(3 - images.length, null));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          ...images.map(
            (url) => Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: TopicImageWidget(url,

                    /// 正方形
                    aspectRatio: 1, onTapImage: (image) async {
                  await showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (context) {
                        return ImageViewer(
                            initImage: image,
                            images: (model.imageList ?? [])
                                .where((i) => i != null)
                                .toList());
                      });
                }),
              ),
            ),
          )
        ],
      ),
    );
  }

  _buildTopicBottomWidget(BuildContext context, tp.Topic model) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: <Widget>[
          Text(DataHelper.toDateTimeOffsetString(model.last_reply_date_value)),
          Spacer(),
          IconWithLabel(
              onPressed: () {},
              icon: Icon(
                Icons.thumb_up,
                color: Colors.grey.shade400,
                size: 18,
              ),
              label: Text(model.recommendAdd.toString())),
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
}

class IconWithLabel extends StatelessWidget {
  final Widget icon;

  final Widget label;

  IconWithLabel({this.icon, this.label, void Function() onPressed});

  @override
  Widget build(BuildContext context) {
    final widget = Container(
        constraints: BoxConstraints(minWidth: 60),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[icon, Container(width: 8), label],
        ));
    return widget;
  }
}

class Tag extends StatelessWidget {
  final Color color;
  final String label;

  Tag({this.color, this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: color ?? Colors.red,
        padding: EdgeInsets.symmetric(horizontal: 2),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ));
  }
}
