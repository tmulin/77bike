// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forum_topiclist.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$TopicListResponseSerializer
    implements Serializer<TopicListResponse> {
  Serializer<ClassificationType> __classificationTypeSerializer;
  Serializer<ClassificationType> get _classificationTypeSerializer =>
      __classificationTypeSerializer ??= ClassificationTypeSerializer();
  Serializer<ForumInfo> __forumInfoSerializer;
  Serializer<ForumInfo> get _forumInfoSerializer =>
      __forumInfoSerializer ??= ForumInfoSerializer();
  Serializer<Topic> __topicSerializer;
  Serializer<Topic> get _topicSerializer =>
      __topicSerializer ??= TopicSerializer();
  Serializer<TopTopic> __topTopicSerializer;
  Serializer<TopTopic> get _topTopicSerializer =>
      __topTopicSerializer ??= TopTopicSerializer();
  Serializer<ResponseHead> __responseHeadSerializer;
  Serializer<ResponseHead> get _responseHeadSerializer =>
      __responseHeadSerializer ??= ResponseHeadSerializer();
  @override
  Map<String, dynamic> toMap(TopicListResponse model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'anno_list',
        codeIterable(model.anno_list, (val) => passProcessor.serialize(val)));
    setMapValue(ret, 'board_category_id', model.board_category_id);
    setMapValue(ret, 'board_category_name', model.board_category_name);
    setMapValue(ret, 'board_list',
        codeIterable(model.board_list, (val) => passProcessor.serialize(val)));
    setMapValue(ret, 'board_category_type', model.board_category_type);
    setMapValue(
        ret,
        'classificationTop_list',
        codeIterable(model.classificationTop_list,
            (val) => passProcessor.serialize(val)));
    setMapValue(
        ret,
        'classificationType_list',
        codeIterable(
            model.classificationType_list,
            (val) => _classificationTypeSerializer
                .toMap(val as ClassificationType)));
    setMapValue(ret, 'forumInfo', _forumInfoSerializer.toMap(model.forumInfo));
    setMapValue(ret, 'has_next', model.has_next);
    setMapValue(ret, 'isOnlyTopicType', model.isOnlyTopicType);
    setMapValue(
        ret,
        'list',
        codeIterable(
            model.list, (val) => _topicSerializer.toMap(val as Topic)));
    setMapValue(
        ret,
        'newTopicPanel',
        codeIterable(
            model.newTopicPanel, (val) => passProcessor.serialize(val)));
    setMapValue(ret, 'page', model.page);
    setMapValue(
        ret,
        'topTopicList',
        codeIterable(model.topTopicList,
            (val) => _topTopicSerializer.toMap(val as TopTopic)));
    setMapValue(ret, 'total_num', model.total_num);
    setMapValue(ret, 'noError', model.noError);
    setMapValue(ret, 'rs', model.rs);
    setMapValue(ret, 'errcode', passProcessor.serialize(model.errcode));
    setMapValue(ret, 'head', _responseHeadSerializer.toMap(model.head));
    return ret;
  }

  @override
  TopicListResponse fromMap(Map map) {
    if (map == null) return null;
    final obj = TopicListResponse();
    obj.anno_list = codeIterable<dynamic>(
        map['anno_list'] as Iterable, (val) => passProcessor.deserialize(val));
    obj.board_category_id = map['board_category_id'] as int;
    obj.board_category_name = map['board_category_name'] as String;
    obj.board_list = codeIterable<dynamic>(
        map['board_list'] as Iterable, (val) => passProcessor.deserialize(val));
    obj.board_category_type = map['board_category_type'] as int;
    obj.classificationTop_list = codeIterable<dynamic>(
        map['classificationTop_list'] as Iterable,
        (val) => passProcessor.deserialize(val));
    obj.classificationType_list = codeIterable<ClassificationType>(
        map['classificationType_list'] as Iterable,
        (val) => _classificationTypeSerializer.fromMap(val as Map));
    obj.forumInfo = _forumInfoSerializer.fromMap(map['forumInfo'] as Map);
    obj.has_next = map['has_next'] as int;
    obj.isOnlyTopicType = map['isOnlyTopicType'] as int;
    obj.list = codeIterable<Topic>(
        map['list'] as Iterable, (val) => _topicSerializer.fromMap(val as Map));
    obj.newTopicPanel = codeIterable<dynamic>(map['newTopicPanel'] as Iterable,
        (val) => passProcessor.deserialize(val));
    obj.page = map['page'] as int;
    obj.topTopicList = codeIterable<TopTopic>(map['topTopicList'] as Iterable,
        (val) => _topTopicSerializer.fromMap(val as Map));
    obj.total_num = map['total_num'] as int;
    obj.rs = map['rs'] as int;
    obj.errcode = passProcessor.deserialize(map['errcode']);
    obj.head = _responseHeadSerializer.fromMap(map['head'] as Map);
    return obj;
  }
}

abstract class _$TopicSerializer implements Serializer<Topic> {
  @override
  Map<String, dynamic> toMap(Topic model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'last_reply_date_value',
        dateTimeUtcProcessor.serialize(model.last_reply_date_value));
    setMapValue(ret, 'board_id', model.board_id);
    setMapValue(ret, 'topic_id', model.topic_id);
    setMapValue(ret, 'title', model.title);
    setMapValue(ret, 'subject', model.subject);
    setMapValue(ret, 'user_id', model.user_id);
    setMapValue(ret, 'last_reply_date', model.last_reply_date);
    setMapValue(ret, 'user_nick_name', model.user_nick_name);
    setMapValue(ret, 'hits', model.hits);
    setMapValue(ret, 'replies', model.replies);
    setMapValue(ret, 'status', model.status);
    setMapValue(ret, 'essence', model.essence);
    setMapValue(ret, 'top', model.top);
    setMapValue(ret, 'hot', model.hot);
    setMapValue(ret, 'vote', model.vote);
    setMapValue(ret, 'type', model.type);
    setMapValue(ret, 'pic_path', model.pic_path);
    setMapValue(ret, 'ratio', model.ratio);
    setMapValue(ret, 'userAvatar', model.userAvatar);
    setMapValue(ret, 'isHasRecommendAdd', model.isHasRecommendAdd);
    setMapValue(ret, 'recommendAdd', model.recommendAdd);
    setMapValue(ret, 'imageList',
        codeIterable(model.imageList, (val) => val as String));
    setMapValue(ret, 'gender', model.gender);
    setMapValue(ret, 'sourceWebUrl', model.sourceWebUrl);
    return ret;
  }

  @override
  Topic fromMap(Map map) {
    if (map == null) return null;
    final obj = Topic();
    obj.board_id = map['board_id'] as int;
    obj.topic_id = map['topic_id'] as int;
    obj.title = map['title'] as String;
    obj.subject = map['subject'] as String;
    obj.user_id = map['user_id'] as int;
    obj.last_reply_date = map['last_reply_date'] as String;
    obj.user_nick_name = map['user_nick_name'] as String;
    obj.hits = map['hits'] as int;
    obj.replies = map['replies'] as int;
    obj.status = map['status'] as int;
    obj.essence = map['essence'] as int;
    obj.top = map['top'] as int;
    obj.hot = map['hot'] as int;
    obj.vote = map['vote'] as int;
    obj.type = map['type'] as String;
    obj.pic_path = map['pic_path'] as String;
    obj.ratio = map['ratio'] as String;
    obj.userAvatar = map['userAvatar'] as String;
    obj.isHasRecommendAdd = map['isHasRecommendAdd'] as int;
    obj.recommendAdd = map['recommendAdd'] as int;
    obj.imageList = codeIterable<String>(
        map['imageList'] as Iterable, (val) => val as String);
    obj.gender = map['gender'] as int;
    obj.sourceWebUrl = map['sourceWebUrl'] as String;
    return obj;
  }
}

abstract class _$ForumInfoSerializer implements Serializer<ForumInfo> {
  @override
  Map<String, dynamic> toMap(ForumInfo model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'id', passProcessor.serialize(model.id));
    setMapValue(ret, 'title', model.title);
    setMapValue(ret, 'description', model.description);
    setMapValue(ret, 'icon', model.icon);
    return ret;
  }

  @override
  ForumInfo fromMap(Map map) {
    if (map == null) return null;
    final obj = ForumInfo();
    obj.id = passProcessor.deserialize(map['id']);
    obj.title = map['title'] as String;
    obj.description = map['description'] as String;
    obj.icon = map['icon'] as String;
    return obj;
  }
}

abstract class _$TopTopicSerializer implements Serializer<TopTopic> {
  @override
  Map<String, dynamic> toMap(TopTopic model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'id', model.id);
    setMapValue(ret, 'title', model.title);
    return ret;
  }

  @override
  TopTopic fromMap(Map map) {
    if (map == null) return null;
    final obj = TopTopic();
    obj.id = map['id'] as int;
    obj.title = map['title'] as String;
    return obj;
  }
}
