import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qiqi_bike/api/mobcent_client.dart';
import 'package:qiqi_bike/common/data_helper.dart';
import 'package:qiqi_bike/core/session.dart';
import 'package:qiqi_bike/core/settings.dart';
import 'package:qiqi_bike/models/forum/forum_topiclist.dart' as tp;
import 'package:qiqi_bike/models/forum/forum_topiclist.dart';
import 'package:qiqi_bike/storage/forum_cache_manager.dart';
import 'package:qiqi_bike/storage/forum_topic_summary.dart';
import 'package:qiqi_bike/views/topic_page.dart';
import 'package:qiqi_bike/views/user_login_page.dart';
import 'package:qiqi_bike/widgets/forum_search_button.dart';
import 'package:qiqi_bike/widgets/topic_image_widget.dart';
import 'package:qiqi_bike/widgets/topic_list_ending.dart';
import 'package:qiqi_bike/widgets/user_avatar_widget.dart';
import 'package:scoped_model/scoped_model.dart';

import 'discovery/user_index_page.dart';
import 'image_viewer.dart';
import 'master_page.dart';

class _DataSource extends Model {
  final int boardId;
  final int filterId;
  final String sortBy;

  /// 数据源名称
  final String name;

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
    if (clear) {
      try {
        TopicKind topicKind = TopicKind.New;
        switch (sortBy) {
          case tp.TopicListAction.sortByNew:
            topicKind = TopicKind.New;
            break;
          case tp.TopicListAction.sortByAll:
            topicKind = TopicKind.All;
            break;
          case tp.TopicListAction.sortByMarrow:
            topicKind = TopicKind.Essence;
            break;
          case tp.TopicListAction.sortByTop:
            topicKind = TopicKind.Top;
            break;
        }
        final topics = await ForumCacheManager.instance.loadTopicSummaries(
            boardId,
            page: 1,
            pageSize: 20,
            topicKind: topicKind);

        if (topics != null && topics.length > 0) {
          this.items.clear();
          this.items.addAll(topics.map((item) => item.toTopic()));
          print("主题缓存数据加载 => ${topics.length}");
        } else {
          print("主题缓存数据不存在 ...");
        }
      } catch (exp) {
        print("主题缓存加载失败 => ${exp}");
      }
    }
    notifyListeners();
    print(
        "DataSource ${name} | B:${boardId} F:${filterId} P:${_nextPage} S:${sortBy} loading ...");
    try {
      var response = await MobcentClient.instance
          .topicList(boardId: boardId, page: _nextPage, sortBy: sortBy);
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

      /// 刷新缓存数据
      try {
        final int totalCount =
            ["all", "new"].contains(sortBy) ? response.total_num : null;
        final int essenceCount = "marrow" == sortBy ? response.total_num : null;
        final boardResult = await ForumCacheManager.instance
            .cacheBoardSummaries(boardId,
                totalCount: totalCount, essenceCount: essenceCount);

        final cacheResult =
            await ForumCacheManager.instance.cacheTopicSummaries(response.list);
      } catch (exp) {
        print("主题缓存更新失败 => ${exp}");
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

class _CachedDataSource extends Model {
  final int boardId;
  final int filterId = 0;
  final TopicKind topicKind;

  /// 数据源名称
  final String name;

  String get sortBy {
    switch (topicKind) {
      case TopicKind.All:
        return TopicListAction.sortByAll;
      case TopicKind.New:
        return TopicListAction.sortByNew;
      case TopicKind.Essence:
        return TopicListAction.sortByMarrow;
      case TopicKind.Top:
        return TopicListAction.sortByTop;
      default:
        return TopicListAction.sortByAll;
    }
  }

  _CachedDataSource(this.name,
      {this.boardId = 0, this.topicKind = TopicKind.New});

  int _itemCount = 0;

  int get itemCount => _itemCount;

  List<tp.Topic> _items = new List();

  List<tp.Topic> get items => _items;

  int _page = 1;
  int _pageSize = 20;

  Future<bool> load() async {
    final int page = _page;
    final int pageSize = _pageSize;
    final result = await _loadFromCache(page, pageSize);

    print(
        "缓存数据源[${name}] 版块${boardId}@${topicKind} :: 加载完成, 记录数 ${this.items.length} / ${this.itemCount}");

    /// 翻页
    _page = page + 1;

    return result;
  }

  Future<bool> _loadFromCache(int page, int pageSize) async {
    /// 从缓存数据库中加载数据
    final board = await ForumCacheManager.instance.getBoardSummary(boardId);
    print(
        "缓存数据源[${name}] 版块${boardId}@${topicKind} :: 记录数 => 全部:${board.total_count}, 精华:${board.essence_count}, 置顶:${board.top_count}");

    switch (this.topicKind) {
      case TopicKind.All:
      case TopicKind.New:
        this._itemCount = board.total_count;
        break;
      case TopicKind.Essence:
        this._itemCount = board.essence_count;
        break;
      case TopicKind.Top:
        this._itemCount = board.top_count;
        break;
    }

    final items = await ForumCacheManager.instance.loadTopicSummaries(boardId,
        page: page, pageSize: pageSize, topicKind: topicKind);

    /// 转换为显示所需的数据模型
    final topics = items.map((item) => item.toTopic()).toList();

    /// 合并新加载的数据到已加载数据列表
    final rangeStart = min((page - 1) * pageSize, _items.length);
    final rangeEnd = min(rangeStart + pageSize - 1, _items.length);
    this._items.replaceRange(rangeStart, rangeEnd, topics);

    /// 触发数据变更通知
    notifyListeners();

    print(
        "缓存数据源[${name}] 版块${boardId}@${topicKind} :: 范围替换 => ${rangeStart} TO ${rangeEnd} | ${topics.length} 记录...");

    /// 启动网络数据异步刷新,不等待刷新结果直接返回
    _refreshCache(page, pageSize);
    return true;
  }

  Future<bool> _refreshCache(int page, int pageSize) async {
    var response = await MobcentClient.instance.topicList(
        boardId: boardId, page: page, pageSize: pageSize, sortBy: sortBy);
    if (response.noError) {
      final int totalCount = [TopicKind.All, TopicKind.New].contains(topicKind)
          ? response.total_num
          : null;
      final int essenceCount =
          TopicKind.Essence == topicKind ? response.total_num : null;
      final int topCount =
          TopicKind.Top == topicKind ? response.total_num : null;

      /// 更新版块内主题数量汇总信息
      final boardResult = await ForumCacheManager.instance.cacheBoardSummaries(
          boardId,
          totalCount: totalCount,
          essenceCount: essenceCount,
          topCount: topCount);

      /// 更新版块内主题摘要信息列表
      final topicsResult =
          await ForumCacheManager.instance.cacheTopicSummaries(response.list);

      /// 触发数据变更通知,重新加载数据
      notifyListeners();
      return true;
    }
  }
}

class IndexPage extends StatefulWidget {
  PageRefreshController controller;

  IndexPage({this.controller});

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  List<_DataSource> _dataSources = List(2);

  // List<_CachedDataSource> _cacheDataSources = List(2);
  List<ScrollController> _scrollControllers = List(2);
  List<GlobalKey<RefreshIndicatorState>> _refreshIndicatorKeys =
      List.generate(2, (_) => GlobalKey<RefreshIndicatorState>());

  @override
  void initState() {
    super.initState();

    widget.controller?.addListener(_refreshPage);

    _dataSources[0] = _DataSource("最新", sortBy: tp.TopicListAction.sortByNew);
    _dataSources[1] =
        _DataSource("精华", sortBy: tp.TopicListAction.sortByMarrow);

//    _cacheDataSources[0] = _CachedDataSource("最新", topicKind: TopicKind.New);
//    _cacheDataSources[0].load();
//
//    _cacheDataSources[1] =
//        _CachedDataSource("精华", topicKind: TopicKind.Essence);
//    _cacheDataSources[1].load();

    _dataSources.forEach((ds) => ds.reload());

    for (int i = 0; i < _scrollControllers.length; i++) {
      final _scrollController = ScrollController();
      _scrollControllers[i] = _scrollController;
      _scrollController.addListener(() {
        final int index = i;
        if (_scrollController.position.maxScrollExtent ==
            _scrollController.position.pixels) {
          print("ScrollController ${index} Reach Bottom , loadMore ...");
          _dataSources[i].loadMore();
          // _cacheDataSources[i].load();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: _buildAppBar(context),
          body: _buildPageBody(context),
        );
      }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller?.removeListener(_refreshPage);
  }

  void _refreshPage() {
    _refreshIndicatorKeys.forEach((_refresher) {
      if (_refresher.currentState?.mounted ?? false)
        _refresher.currentState?.show();
    });
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading:
          ScopedModelDescendant<Session>(builder: (context, child, session) {
        return _buildMyAvatar(context, session);
      }),
      centerTitle: true,
      title: _buildPageTabBar(context),
      titleSpacing: 0,
      // bottom: _buildPageTabBar(context),
      actions: <Widget>[const ForumSearchButton()],
    );
  }

  _buildMyAvatar(BuildContext context, Session session) {
    Widget widget;

    if (session.uid == 0) {
      widget = GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              fullscreenDialog: true, builder: (context) => UserLoginPage()));
        },
        child: Icon(
          Icons.account_circle,
          size: 36,
        ),
      );
    } else {
      widget = UserAvatarWidget(
        session.avatar,
        width: 36,
        height: 36,
        borderRadius: 36,
      );
    }

    return Padding(padding: const EdgeInsets.all(8.0), child: widget);
  }

  _buildPageTabBar(BuildContext context) {
    return TabBar(
      isScrollable: true,
      indicatorSize: TabBarIndicatorSize.label,
      labelPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      tabs: this._dataSources.map((ds) => Text(ds.name)).toList(),
    );
  }

  _buildPageBody(BuildContext context) {
    return TabBarView(children: <Widget>[
      _wrapRefresh(
          _buildTopicsView(context, _scrollControllers[0], _dataSources[0]), 0),
      _wrapRefresh(
          _buildTopicsView(context, _scrollControllers[1], _dataSources[1]), 1),
    ]);
  }

  Widget _wrapRefresh(Widget widget, index) {
    return RefreshIndicator(
        key: _refreshIndicatorKeys[index],
        displacement: 20,
        onRefresh: () async {
          await _dataSources[index].reload();
          _scrollControllers[index].animateTo(0,
              duration: Duration(milliseconds: 300), curve: Curves.bounceInOut);

//          await _cacheDataSources[0].load();
//          await _cacheDataSources[1].load();

          return Future.value();
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
              // cacheExtent: 0,
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: itemCount,
              itemBuilder: (context, index) {
                if (index == itemCount - 1) {
                  // 构建结尾
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
              });
        },
      ),
    );
  }

  Widget _warpTopicItemView(Widget itemView, tp.Topic model) {
    Tag tag;
    tag ??= model.top == 0
        ? null
        : const Tag(
            label: "顶",
            color: Colors.blue,
          );
    tag ??= model.essence == 0 ? null : const Tag(label: "精");
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
                      title: model.title,
                    )));
          },
          child: TopicItemWidget(index, model, kind),
        ),
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

  const Tag({this.color, this.label});

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

class TopicItemWidget extends StatelessWidget {
  final tp.Topic model;

  final int index;

  final String kind;

  TopicItemWidget(this.index, this.model, this.kind);

  @override
  Widget build(BuildContext context) {
    print("TopicItemWidget [${index}] => ${model.title} ...");

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
                      title: model.title,
                    )));
          },
          child: widget,
        ),
      ),
    );
  }
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

/// 小头像模式用户信息
_buildUserDetailWidgetMini(BuildContext context, tp.Topic model) {
  final showUserHomePage = () {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => UserIndexPage(
              userId: model.user_id,
              userName: model.user_nick_name,
              userAvatar: model.userAvatar,
            )));
  };
  return Row(
    children: <Widget>[
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: showUserHomePage,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
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
        ),
      ),
    ],
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
