import 'dart:convert';

import 'package:qiqi_bike/models/forum/forum_topiclist.dart';

class ForumBoardSummary {
  static const String tableName = "forum_board_summaries";
  static const String columnBoardId = "board_id";
  static const String columnLastUpdateTime = "last_update_time";

  /// 帖子总数量
  static const String columnTotalCount = "total_count";

  /// 精华帖数量
  static const String columnEssenceCount = "essence_count";

  /// 置顶帖数量
  static const String columnTopCount = "top_count";

  ForumBoardSummary({this.board_id});

  /// 版块编号(0表示首页全站)
  int board_id;

  /// 数据最后更新时间
  int last_update_time;

  /// 全部帖数量
  int total_count;

  /// 精华帖数量
  int essence_count;

  /// 置顶帖数量
  int top_count;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      columnBoardId: board_id,
      columnTotalCount: total_count,
      columnEssenceCount: essence_count,
      columnTopCount: total_count,
      columnLastUpdateTime: last_update_time,
    };
  }

  ForumBoardSummary.fromMap(Map model) {
    board_id = model[columnBoardId] ?? 0;
    total_count = model[columnTotalCount] ?? -1;
    essence_count = model[columnEssenceCount] ?? -1;
    top_count = model[columnTopCount] ?? -1;
    last_update_time = model[columnLastUpdateTime] ?? 0;
  }
}

enum TopicKind {
  /// 查看全部
  All,

  /// 查看最新
  New,

  /// 精华
  Essence,

  /// 置顶
  Top
}

class ForumTopicSummary {
  static const String tableName = "forum_topic_summaries";
  static const String columnTopicId = "topic_id";
  static const String columnBoardId = "board_id";
  static const String columnLastReplyDate = "last_reply_date";
  static const String columnLastUpdateTime = "last_update_time";
  static const String columnData = "data";
  static const String columnIsEssence = "is_essence";
  static const String columnIsTop = "is_top";

  /// 主题编号
  int topic_id;

  /// 版块编号
  int board_id;

  /// 是否是精华帖
  int is_essence;

  /// 是否是置顶帖
  int is_top;

  /// 主题最后回复时间
  int last_reply_date;

  /// 数据最后更新时间
  int last_update_time;

  /// 原始数据对象json格式表示
  String data;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      columnTopicId: topic_id,
      columnBoardId: board_id,
      columnIsEssence: is_essence ?? 0,
      columnIsTop: is_top ?? 0,
      columnLastReplyDate: last_reply_date,
      columnLastUpdateTime: last_update_time,
      columnData: data
    };
  }

  ForumTopicSummary.fromMap(Map model) {
    topic_id = model[columnTopicId];
    board_id = model[columnBoardId];
    is_essence = model[columnIsEssence];
    is_top = model[columnIsTop];
    last_reply_date = model[columnLastReplyDate];
    last_update_time = model[columnLastUpdateTime];
    data = model[columnData];
  }

  ForumTopicSummary.fromTopic(Topic topic) {
    topic_id = topic.topic_id;
    board_id = topic.board_id;
    is_essence = topic.essence;
    is_top = topic.top;
    last_reply_date = int.tryParse(topic.last_reply_date);
    last_update_time = DateTime.now().millisecondsSinceEpoch;
    data = json.encode(TopicSerializer().toMap(topic));
  }

  Topic toTopic() {
    if (this.data == null) return null;
    return TopicSerializer().fromMap(json.decode(this.data));
  }
}
