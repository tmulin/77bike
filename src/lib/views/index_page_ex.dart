import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qiqi_bike/api/mobcent_client.dart';
import 'package:qiqi_bike/common/data_helper.dart';
import 'package:qiqi_bike/models/forum/forum_topiclist.dart' as tp;
import 'package:qiqi_bike/views/topic_page.dart';
import 'package:qiqi_bike/widgets/topic_image_widget.dart';
import 'package:qiqi_bike/widgets/user_avatar_widget.dart';
import 'package:scoped_model/scoped_model.dart';

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

  Future<bool> loadMore() async {
    if (_loading) {
      print(
          "DataSource ${name} | B:${boardId} F:${filterId} P:${_nextPage} S:${sortBy} loading in progress, ignore ...");
      return true;
    }
    _loading = true;
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
    this._items.clear();
    return await this.loadMore();
  }
}

class IndexPageEx extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPageEx> {
  List<_DataSource> _dataSources = List(2);

  List<ScrollController> _scrollControllers = List(2);

  @override
  void initState() {
    super.initState();

    _dataSources[0] = _DataSource("最新", sortBy: tp.TopicListAction.sortByNew);
    _dataSources[1] =
        _DataSource("精华", sortBy: tp.TopicListAction.sortByMarrow);

    _dataSources.forEach((ds) => ds.loadMore());

    for (int i = 0; i < _scrollControllers.length; i++) {
      final _scrollController = ScrollController();
      _scrollControllers[i] = _scrollController;
      _scrollController.addListener(() {
        final int index = i;
//        print("[$i] position.pixels => ${_scrollController.position.pixels}");
//        print(
//            "[$i] position.maxScrollExtent => ${_scrollController.position.maxScrollExtent}");
        if (_scrollController.position.maxScrollExtent -
                _scrollController.position.pixels <
            4) {
          print("ScrollController ${index} Reach Bottom , loadMore ...");
          _dataSources[i].loadMore();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: _buildPageTabBar(context),
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // appBar: appBar,
        body: NestedScrollView(
          // controller: _scrollControllers[0],
          headerSliverBuilder: _buildSliverHeader,
          body: _buildPageBody(context),
        ),
      ),
    );
  }

  List<Widget> _buildSliverHeader(
      BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
        snap: true,
        pinned: true,
        floating: true,
        title: Container(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.all(8),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
        titleSpacing: 0,
        forceElevated: innerBoxIsScrolled,
        bottom: _buildPageTabBar(context),
      ),
    ];
  }

  Widget _buildPageTabBar(BuildContext context) {
    return TabBar(
      labelPadding: kTabLabelPadding.add(EdgeInsets.only(top: 16, bottom: 8)),
      indicatorSize: TabBarIndicatorSize.label,
      tabs: this._dataSources.map((ds) => Text(ds.name)).toList(),
    );
  }

  _buildPageBody(BuildContext context) {
    return TabBarView(children: <Widget>[
      _wrapRefresh(
          _buildTopicsView(context, _scrollControllers[0], _dataSources[0]),
          _dataSources[0]),
      _wrapRefresh(
          _buildTopicsView(context, _scrollControllers[1], _dataSources[1]),
          _dataSources[1]),
    ]);
  }

  Widget _wrapRefresh(Widget widget, _DataSource dataSource) {
    return RefreshIndicator(
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
          print(
              "ScopedModelDescendant ${model.name}|${dataSource.name} build ...");

          return ListView.builder(
            key: PageStorageKey<String>(dataSource.name),
            // controller: controller,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: model.items.length,
            itemBuilder: (context, index) => _warpTopicItemView(
              _buildTopicItemView(
                  context, index, model.items[index], dataSource.sortBy),
              model.items[index],
            ),
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

    if (kind == tp.TopicListAction.sortByNew) {
      widget = Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 8),
        constraints: BoxConstraints(minHeight: 120),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _builtTopicTitleWidget(context, model),
            _buildUserDetailWidgetMini(context, model),
            _buildTopicContentWidget(context, model),
            _buildTopicImagesWidget(context, model),
            _buildTopicBottomWidget(context, model),
          ],
        ),
      );
    } else {
      /// 帖子主图
      final image = DataHelper.isIsNullOrWhiteSpaceString(model.pic_path)
          ? null
          : Container(
              width: MediaQuery.of(context).size.width / 4 - 8,
              padding: EdgeInsets.only(right: 8),
              child: TopicImageWidget(
                model.pic_path,
                aspectRatio: 1,
              ),
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
                child: TopicImageWidget(
                  url,

                  /// 正方形
                  aspectRatio: 1,
                ),
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

class _SliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverPersistentHeaderDelegate(this._tabBar);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      child: _tabBar,
      color: Colors.white,
    );
  }

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
