import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:qiqi_bike/models/forum/forum_postlist.dart';

class ForumTopicModel {
  static const String tableName = "forum_topics";

  /// 主题编号
  static const String columnTopicId = "topic_id";

  /// 版块编号
  static const String columnBoardId = "board_id";

  /// 子分类编号
  static const String columnSortId = "sort_id";

  /// 总回帖数
  static const String columnTotalReplies = "total_replies";

  /// 主题创建时间
  static const String columnCreateDate = "create_date";
  static const String columnLastUpdateTime = "last_update_time";
  static const String columnData = "data";

  /// 主题编号
  int topic_id;

  /// 版块编号
  int board_id;

  int sort_id;

  int total_replies;

  /// 主题创建时间
  int create_date;

  /// 数据最后更新时间
  int last_update_time;

  /// 原始数据对象json格式表示
  String data;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      columnTopicId: topic_id,
      columnBoardId: board_id,
      columnSortId: sort_id,
      columnTotalReplies: total_replies,
      columnCreateDate: create_date,
      columnLastUpdateTime: last_update_time,
      columnData: data
    };
  }

  ForumTopicModel.fromMap(Map model) {
    topic_id = model[columnTopicId];
    board_id = model[columnBoardId];
    sort_id = model[columnSortId];
    total_replies = model[columnTotalReplies];
    create_date = model[columnCreateDate];
    last_update_time = model[columnLastUpdateTime];
    data = model[columnData];
  }

  ForumTopicModel.fromTopic(PostTopic topic, {int boardId = 0}) {
    board_id = boardId ?? 0;
    topic_id = topic.topic_id;
    sort_id = topic.sortId;
    total_replies = topic.replies;
    create_date = int.tryParse(topic.create_date);
    last_update_time = DateTime.now().millisecondsSinceEpoch;
    data = json.encode(PostTopicSerializer().toMap(topic));
  }

  PostTopic toTopic() {
    if (this.data == null) return null;
    return PostTopicSerializer().fromMap(json.decode(this.data));
  }
}

class ForumReplyModel {
  static const String tableName = "forum_replies";
  static const String columnReplyId = "reply_id";
  static const String columnTopicId = "topic_id";
  static const String columnPosition = "position";
  static const String columnReplyDate = "reply_date";
  static const String columnLastUpdateTime = "last_update_time";
  static const String columnData = "data";

  /// 回帖编号(reply_posts_id)
  int reply_id;

  /// 主题编号
  int topic_id;

  /// 楼层编号
  int position;

  /// 回复时间
  int reply_date;

  /// 数据最后更新时间
  int last_update_time;

  /// 原始数据对象json格式表示
  String data;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      columnReplyId: reply_id,
      columnTopicId: topic_id,
      columnPosition: position,
      columnReplyDate: reply_date,
      columnLastUpdateTime: last_update_time,
      columnData: data
    };
  }

  ForumReplyModel.fromMap(Map model) {
    reply_id = model[columnReplyId];
    topic_id = model[columnTopicId];
    position = model[columnPosition];
    reply_date = model[columnReplyDate];
    last_update_time = model[columnLastUpdateTime];
    data = model[columnData];
  }

  ForumReplyModel.fromReply(PostReply reply, {@required int topicId}) {
    topic_id = topicId;
    reply_id = reply.reply_posts_id;
    position = reply.position;
    reply_date = int.tryParse(reply.posts_date);
    last_update_time = DateTime.now().millisecondsSinceEpoch;
    data = json.encode(PostReplySerializer().toMap(reply));
  }

  PostReply toReply() {
    if (this.data == null) return null;
    return PostReplySerializer().fromMap(json.decode(this.data));
  }
}
