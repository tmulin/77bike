import 'dart:async';

import 'package:qiqi_bike/models/forum/forum_postlist.dart';
import 'package:qiqi_bike/models/forum/forum_topiclist.dart';
import 'package:sqflite/sqflite.dart';

import 'forum_topic_model.dart';
import 'forum_topic_summary.dart';

class ForumCacheManager {
  factory ForumCacheManager() => _getInstance();

  static ForumCacheManager get instance => _getInstance();
  static ForumCacheManager _instance;

  static ForumCacheManager _getInstance() {
    if (_instance == null) {
      _instance = ForumCacheManager._internal();
    }
    return _instance;
  }

  Database _database;

  ForumCacheManager._internal() {}

  Future<bool> initialize() async {
    try {
      _database = await openDatabase("forum.db",
          version: 1, onCreate: onCreate, onUpgrade: onUpgrade, onOpen: onOpen);
      return true;
    } catch (exp) {
      print("论坛缓存[数据库]:: 打开失败 => ${exp}");
      return false;
    }
  }

  FutureOr<void> onOpen(Database db) {
    print("论坛缓存[数据库]:: 打开数据库...");
  }

  Future<void> onCreate(Database db, int version) async {
    print("论坛缓存[数据库]:: 创建数据库 => ${version}");
    final createBoardSummaries = '''
    CREATE TABLE IF NOT EXISTS '${ForumBoardSummary.tableName}' (
      ${ForumBoardSummary.columnBoardId} integer primary key,
      ${ForumBoardSummary.columnTotalCount} integer,
      ${ForumBoardSummary.columnEssenceCount} integer,
      ${ForumBoardSummary.columnTopCount} integer,
      ${ForumBoardSummary.columnLastUpdateTime} integer
      );
    ''';

    await db.execute(createBoardSummaries);

    final createTopicSummaries = '''
    CREATE TABLE IF NOT EXISTS '${ForumTopicSummary.tableName}' (
      ${ForumTopicSummary.columnTopicId} integer primary key,
      ${ForumTopicSummary.columnBoardId} integer,
      ${ForumTopicSummary.columnIsEssence} integer,
      ${ForumTopicSummary.columnIsTop} integer,
      ${ForumTopicSummary.columnLastReplyDate} integer,
      ${ForumTopicSummary.columnLastUpdateTime} integer,
      ${ForumTopicSummary.columnData} text
      );
    ''';

    await db.execute(createTopicSummaries);

    final createTopics = '''
    CREATE TABLE IF NOT EXISTS '${ForumTopicModel.tableName}' (
      ${ForumTopicModel.columnTopicId} integer primary key,
      ${ForumTopicModel.columnBoardId} integer,
      ${ForumTopicModel.columnSortId} integer,
      ${ForumTopicModel.columnTotalReplies} integer,
      ${ForumTopicModel.columnCreateDate} integer,
      ${ForumTopicModel.columnLastUpdateTime} integer,
      ${ForumTopicModel.columnData} text
      );
    ''';

    await db.execute(createTopics);

    final createReplies = '''
    CREATE TABLE IF NOT EXISTS '${ForumReplyModel.tableName}' (
      ${ForumReplyModel.columnReplyId} integer primary key,
      ${ForumReplyModel.columnTopicId} integer,
      ${ForumReplyModel.columnPosition} integer,
      ${ForumReplyModel.columnReplyDate} integer,
      ${ForumReplyModel.columnLastUpdateTime} integer,
      ${ForumReplyModel.columnData} text
      );
    ''';
    await db.execute(createReplies);
  }

  Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("论坛缓存[数据库]:: 升级数据库 => 旧版本 ${oldVersion} | 新版本 ${newVersion}");
    // onCreate(db, newVersion);
  }

  Future<bool> _putTopicSummary(ForumTopicSummary topic) async {
    await _database.insert(ForumTopicSummary.tableName, topic.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return true;
  }

  Future<ForumTopicSummary> _getTopicSummary(int topic_id) async {
    List<Map> maps = await _database.query(ForumTopicSummary.tableName,
        where: '${ForumTopicSummary.columnTopicId} = ?', whereArgs: [topic_id]);
    if (maps.length > 0) {
      return ForumTopicSummary.fromMap(maps.first);
    }
    return null;
  }

  Future<bool> cacheBoardSummaries(int boardId,
      {int totalCount, int essenceCount, int topCount}) async {
    if (boardId == null) return true;
    if (totalCount == null && essenceCount == null && topCount == null)
      return true;
    try {
      var exists = await _database.query(ForumBoardSummary.tableName,
          where: "${ForumBoardSummary.columnBoardId} = ?",
          whereArgs: [boardId]);

      var boardSummary =
          ForumBoardSummary.fromMap(exists.length == 0 ? {} : exists.first);
      boardSummary.board_id = boardId;
      boardSummary.last_update_time = DateTime.now().millisecondsSinceEpoch;
      if (totalCount != null) boardSummary.total_count = totalCount;
      if (essenceCount != null) boardSummary.essence_count = essenceCount;
      if (topCount != null) boardSummary.top_count = topCount;

      print("论坛缓存[版块汇总] 准备更新 => ${{
        "totalCount": totalCount,
        "essenceCount": essenceCount,
        "topCount": topCount
      }}");

      _database.insert(ForumBoardSummary.tableName, boardSummary.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);

      print("论坛缓存[版块汇总] 更新成功 => ${boardSummary.toMap()}");

      return true;
    } catch (exp) {
      print("论坛缓存[版块汇总] 更新失败 => EXCEPTION ${exp}");
      return false;
    }
  }

  Future<bool> cacheTopicSummaries(List<Topic> topics) async {
    if (topics == null || topics.length == 0) return true;
    try {
      final models =
          topics.map((topic) => ForumTopicSummary.fromTopic(topic)).toList();

      final batch = _database.batch();
      for (var model in models) {
        batch.insert(ForumTopicSummary.tableName, model.toMap());
      }
      final results = await batch.commit(continueOnError: true);

      final total = await _database.rawQuery('''
      SELECT COUNT('${ForumTopicSummary.columnTopicId}') as 'total'
      FROM ${ForumTopicSummary.tableName}
      ''');

      print(
          "论坛缓存[主题摘要] 合并完成 => ${results.length} | 总缓存数 = ${total[0]["total"]}");

      return true;
    } catch (exp) {
      print("论坛缓存[主题摘要] 合并失败 => EXCEPTION ${exp}");
      return false;
    }
  }

  Future<List<ForumTopicSummary>> loadTopicSummaries(int boardId,
      {int page = 1,
      int pageSize = 10,
      TopicKind topicKind = TopicKind.All}) async {
    try {
      String where;
      List<dynamic> whereArgs = [];
      List<String> whereClauses = [];

      String orderBy = "${ForumTopicSummary.columnTopicId} DESC";

      if (topicKind == TopicKind.All) {
        /// 全部tab页按照最后回复时间排序
        orderBy = "${ForumTopicSummary.columnLastReplyDate} DESC";
      }

      if (boardId > 0) {
        whereClauses.add("${ForumTopicSummary.columnBoardId} = ?");
        whereArgs.add(boardId);
      }
      if (topicKind == TopicKind.Essence) {
        /// TODO: 只查询精华帖
        whereClauses.add("${ForumTopicSummary.columnIsEssence} = ?");
        whereArgs.add(1);
      } else if (topicKind == TopicKind.Top) {
        /// TODO: 只查询置顶帖
        whereClauses.add("${ForumTopicSummary.columnIsTop} = ?");
        whereArgs.add(1);
      }
      if (whereClauses.length == 0) {
        whereClauses = null;
      } else {
        where = whereClauses.join(" AND ");
      }

      final items = await _database.query(ForumTopicSummary.tableName,
          where: where,
          whereArgs: whereArgs,
          limit: pageSize,
          orderBy: orderBy,
          offset: (page - 1) * pageSize);

      final models =
          items.map((item) => ForumTopicSummary.fromMap(item)).toList();

      return models;
    } catch (exp) {
      print("论坛缓存[主题摘要] 加载失败 => ${exp}");
      return null;
    }
  }

  Future<ForumBoardSummary> getBoardSummary(int boardId) async {
    try {
      var models = await _database.query(ForumBoardSummary.tableName,
          where: "${ForumBoardSummary.columnBoardId} = ?",
          whereArgs: [boardId]);

      var boardSummary = ForumBoardSummary.fromMap(models.length == 0
          ? {ForumBoardSummary.columnBoardId: boardId}
          : models.first);

      return boardSummary;
    } catch (exp) {
      print("论坛缓存[主题汇总] 加载失败 => ${exp}");
      return ForumBoardSummary(board_id: boardId);
    }
  }

  Future<bool> cacheTopicPosts(int boardId, int topicId, PostTopic topic,
      List<PostReply> replies) async {
    if (topic == null && (replies == null || replies.length == 0)) return true;
    if (topic != null) {
      assert(topicId == topic.topic_id);
    }
    try {
      final models = replies
          .map((reply) => ForumReplyModel.fromReply(reply, topicId: topicId))
          .toList();

      final batch = _database.batch();

      if (topic != null) {
        batch.insert(ForumTopicModel.tableName,
            ForumTopicModel.fromTopic(topic, boardId: boardId).toMap());
      }

      for (var model in models) {
        batch.insert(ForumReplyModel.tableName, model.toMap());
      }
      final results = await batch.commit(continueOnError: true);

      final totalTopics = await _database.rawQuery('''
      SELECT COUNT('${ForumTopicModel.columnTopicId}') as 'total'
      FROM ${ForumTopicModel.tableName}
      ''');

      final totalReplies = await _database.rawQuery('''
      SELECT COUNT('${ForumReplyModel.columnReplyId}') as 'total'
      FROM ${ForumReplyModel.tableName}
      ''');

      print(
          "论坛缓存[主题详情] 合并完成 => ${results.length} | 总缓存数 = 主题 ${totalTopics[0]["total"]}, 回复 ${totalReplies[0]["total"]}");

      return true;
    } catch (exp) {
      print("论坛缓存[主题详情] 合并失败 => EXCEPTION ${exp}");
      return false;
    }
  }

  Future<ForumTopicModel> loadTopic(int topicId) async {
    try {
      final models = await _database.query(ForumTopicModel.tableName,
          where: "${ForumTopicModel.columnTopicId} = ?", whereArgs: [topicId]);
      final topic =
          ForumTopicModel.fromMap(models.isNotEmpty ? models.first : {});
      return topic;
    } catch (exp) {
      print("论坛缓存[主题数据] 加载失败 => EXCEPTION $exp");
      return null;
    }
  }

  Future<List<ForumReplyModel>> loadTopicReplies(int topicId,
      {int page = 1, int pageSize = 10, int order = 0}) async {
    try {
      final models = await _database.query(ForumReplyModel.tableName,
          where: "${ForumReplyModel.columnTopicId} = ?",
          whereArgs: [topicId],
          orderBy:
              "${ForumReplyModel.columnReplyId} ${order == 0 ? "ASC" : "DESC"}",
          limit: pageSize,
          offset: (page - 1) * pageSize);
      final replies =
          models.map((model) => ForumReplyModel.fromMap(model)).toList();
      return replies;
    } catch (exp) {
      print("论坛缓存[回帖列表] 加载失败 => EXCEPTION $exp");
      return null;
    }
  }

  Future<bool> dispose() async {
    if (_database != null) {
      await _database.close();
      _database = null;
    }
    return true;
  }
}
