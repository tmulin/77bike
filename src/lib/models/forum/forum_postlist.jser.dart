// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forum_postlist.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$PostListResponseSerializer
    implements Serializer<PostListResponse> {
  Serializer<PostTopic> __postTopicSerializer;
  Serializer<PostTopic> get _postTopicSerializer =>
      __postTopicSerializer ??= PostTopicSerializer();
  Serializer<PostReply> __postReplySerializer;
  Serializer<PostReply> get _postReplySerializer =>
      __postReplySerializer ??= PostReplySerializer();
  Serializer<ResponseHead> __responseHeadSerializer;
  Serializer<ResponseHead> get _responseHeadSerializer =>
      __responseHeadSerializer ??= ResponseHeadSerializer();
  @override
  Map<String, dynamic> toMap(PostListResponse model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'boardId', model.boardId);
    setMapValue(ret, 'forumName', model.forumName);
    setMapValue(ret, 'topic', _postTopicSerializer.toMap(model.topic));
    setMapValue(
        ret,
        'list',
        codeIterable(
            model.list, (val) => _postReplySerializer.toMap(val as PostReply)));
    setMapValue(ret, 'img_url', model.img_url);
    setMapValue(ret, 'forumTopicUrl', model.forumTopicUrl);
    setMapValue(ret, 'page', model.page);
    setMapValue(ret, 'has_next', model.has_next);
    setMapValue(ret, 'total_num', model.total_num);
    setMapValue(ret, 'noError', model.noError);
    setMapValue(ret, 'rs', model.rs);
    setMapValue(ret, 'errcode', passProcessor.serialize(model.errcode));
    setMapValue(ret, 'head', _responseHeadSerializer.toMap(model.head));
    return ret;
  }

  @override
  PostListResponse fromMap(Map map) {
    if (map == null) return null;
    final obj = PostListResponse();
    obj.boardId = map['boardId'] as String;
    obj.forumName = map['forumName'] as String;
    obj.topic = _postTopicSerializer.fromMap(map['topic'] as Map);
    obj.list = codeIterable<PostReply>(map['list'] as Iterable,
        (val) => _postReplySerializer.fromMap(val as Map));
    obj.img_url = map['img_url'] as String;
    obj.forumTopicUrl = map['forumTopicUrl'] as String;
    obj.page = map['page'] as int;
    obj.has_next = map['has_next'] as int;
    obj.total_num = map['total_num'] as int;
    obj.rs = map['rs'] as int;
    obj.errcode = passProcessor.deserialize(map['errcode']);
    obj.head = _responseHeadSerializer.fromMap(map['head'] as Map);
    return obj;
  }
}

abstract class _$PostTopicSerializer implements Serializer<PostTopic> {
  Serializer<PostContent> __postContentSerializer;
  Serializer<PostContent> get _postContentSerializer =>
      __postContentSerializer ??= PostContentSerializer();
  Serializer<ExtraPanel> __extraPanelSerializer;
  Serializer<ExtraPanel> get _extraPanelSerializer =>
      __extraPanelSerializer ??= ExtraPanelSerializer();
  Serializer<RateList> __rateListSerializer;
  Serializer<RateList> get _rateListSerializer =>
      __rateListSerializer ??= RateListSerializer();
  @override
  Map<String, dynamic> toMap(PostTopic model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'create_date_value',
        dateTimeUtcProcessor.serialize(model.create_date_value));
    setMapValue(
        ret, 'activityInfo', passProcessor.serialize(model.activityInfo));
    setMapValue(
        ret,
        'content',
        codeIterable(model.content,
            (val) => _postContentSerializer.toMap(val as PostContent)));
    setMapValue(ret, 'create_date', model.create_date);
    setMapValue(ret, 'essence', model.essence);
    setMapValue(
        ret,
        'extraPanel',
        codeIterable(model.extraPanel,
            (val) => _extraPanelSerializer.toMap(val as ExtraPanel)));
    setMapValue(ret, 'falg', model.falg);
    setMapValue(ret, 'gender', model.gender);
    setMapValue(ret, 'hits', model.hits);
    setMapValue(ret, 'icon', model.icon);
    setMapValue(ret, 'is_favor', model.is_favor);
    setMapValue(ret, 'level', model.level);
    setMapValue(ret, 'location', model.location);
    setMapValue(ret, 'mobileSign', model.mobileSign);
    setMapValue(ret, 'rateList', _rateListSerializer.toMap(model.rateList));
    setMapValue(ret, 'replies', model.replies);
    setMapValue(ret, 'reply_posts_id', model.reply_posts_id);
    setMapValue(ret, 'reply_status', model.reply_status);
    setMapValue(ret, 'sortId', model.sortId);
    setMapValue(ret, 'status', model.status);
    setMapValue(ret, 'title', model.title);
    setMapValue(ret, 'topic_id', model.topic_id);
    setMapValue(ret, 'type', model.type);
    setMapValue(ret, 'userTitle', model.userTitle);
    setMapValue(ret, 'user_nick_name', model.user_nick_name);
    setMapValue(ret, 'user_id', model.user_id);
    return ret;
  }

  @override
  PostTopic fromMap(Map map) {
    if (map == null) return null;
    final obj = PostTopic();
    obj.activityInfo = passProcessor.deserialize(map['activityInfo']);
    obj.content = codeIterable<PostContent>(map['content'] as Iterable,
        (val) => _postContentSerializer.fromMap(val as Map));
    obj.create_date = map['create_date'] as String;
    obj.essence = map['essence'] as int;
    obj.extraPanel = codeIterable<ExtraPanel>(map['extraPanel'] as Iterable,
        (val) => _extraPanelSerializer.fromMap(val as Map));
    obj.falg = map['falg'] as int;
    obj.gender = map['gender'] as int;
    obj.hits = map['hits'] as int;
    obj.icon = map['icon'] as String;
    obj.is_favor = map['is_favor'] as int;
    obj.level = map['level'] as num;
    obj.location = map['location'] as String;
    obj.mobileSign = map['mobileSign'] as String;
    obj.rateList = _rateListSerializer.fromMap(map['rateList'] as Map);
    obj.replies = map['replies'] as int;
    obj.reply_posts_id = map['reply_posts_id'] as int;
    obj.reply_status = map['reply_status'] as int;
    obj.sortId = map['sortId'] as int;
    obj.status = map['status'] as int;
    obj.title = map['title'] as String;
    obj.topic_id = map['topic_id'] as int;
    obj.type = map['type'] as String;
    obj.userTitle = map['userTitle'] as String;
    obj.user_nick_name = map['user_nick_name'] as String;
    obj.user_id = map['user_id'] as int;
    return obj;
  }
}

abstract class _$RateListSerializer implements Serializer<RateList> {
  Serializer<RateListHead> __rateListHeadSerializer;
  Serializer<RateListHead> get _rateListHeadSerializer =>
      __rateListHeadSerializer ??= RateListHeadSerializer();
  Serializer<RateListBody> __rateListBodySerializer;
  Serializer<RateListBody> get _rateListBodySerializer =>
      __rateListBodySerializer ??= RateListBodySerializer();
  @override
  Map<String, dynamic> toMap(RateList model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'ping', model.ping);
    setMapValue(ret, 'head', _rateListHeadSerializer.toMap(model.head));
    setMapValue(
        ret,
        'body',
        codeIterable(model.body,
            (val) => _rateListBodySerializer.toMap(val as RateListBody)));
    setMapValue(ret, 'showAllUrl', model.showAllUrl);
    return ret;
  }

  @override
  RateList fromMap(Map map) {
    if (map == null) return null;
    final obj = RateList();
    obj.ping = map['ping'] as String;
    obj.head = _rateListHeadSerializer.fromMap(map['head'] as Map);
    obj.body = codeIterable<RateListBody>(map['body'] as Iterable,
        (val) => _rateListBodySerializer.fromMap(val as Map));
    obj.showAllUrl = map['showAllUrl'] as String;
    return obj;
  }
}

abstract class _$RateListHeadSerializer implements Serializer<RateListHead> {
  @override
  Map<String, dynamic> toMap(RateListHead model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'field1', model.field1);
    setMapValue(ret, 'field2', model.field2);
    return ret;
  }

  @override
  RateListHead fromMap(Map map) {
    if (map == null) return null;
    final obj = RateListHead();
    obj.field1 = map['field1'] as String;
    obj.field2 = map['field2'] as String;
    return obj;
  }
}

abstract class _$RateListBodySerializer implements Serializer<RateListBody> {
  @override
  Map<String, dynamic> toMap(RateListBody model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'field1', model.field1);
    setMapValue(ret, 'field2', model.field2);
    setMapValue(ret, 'field3', model.field3);
    return ret;
  }

  @override
  RateListBody fromMap(Map map) {
    if (map == null) return null;
    final obj = RateListBody();
    obj.field1 = map['field1'] as String;
    obj.field2 = map['field2'] as String;
    obj.field3 = map['field3'] as String;
    return obj;
  }
}

abstract class _$ExtraPanelSerializer implements Serializer<ExtraPanel> {
  @override
  Map<String, dynamic> toMap(ExtraPanel model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'action', model.action);
    setMapValue(ret, 'title', model.title);
    setMapValue(ret, 'type', model.type);
    setMapValue(ret, 'extParams',
        codeMap(model.extParams, (val) => passProcessor.serialize(val)));
    return ret;
  }

  @override
  ExtraPanel fromMap(Map map) {
    if (map == null) return null;
    final obj = ExtraPanel();
    obj.action = map['action'] as String;
    obj.title = map['title'] as String;
    obj.type = map['type'] as String;
    obj.extParams = codeMap<dynamic>(
        map['extParams'] as Map, (val) => passProcessor.deserialize(val));
    return obj;
  }
}

abstract class _$PostContentSerializer implements Serializer<PostContent> {
  @override
  Map<String, dynamic> toMap(PostContent model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'aid', model.aid);
    setMapValue(ret, 'infor', model.infor);
    setMapValue(ret, 'originalInfo', model.originalInfo);
    setMapValue(ret, 'url', model.url);
    setMapValue(ret, 'type', model.type);
    return ret;
  }

  @override
  PostContent fromMap(Map map) {
    if (map == null) return null;
    final obj = PostContent();
    obj.aid = map['aid'] as int;
    obj.infor = map['infor'] as String;
    obj.originalInfo = map['originalInfo'] as String;
    obj.url = map['url'] as String;
    obj.type = map['type'] as int;
    return obj;
  }
}

abstract class _$PostReplySerializer implements Serializer<PostReply> {
  Serializer<PostContent> __postContentSerializer;
  Serializer<PostContent> get _postContentSerializer =>
      __postContentSerializer ??= PostContentSerializer();
  @override
  Map<String, dynamic> toMap(PostReply model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'posts_date_value',
        dateTimeUtcProcessor.serialize(model.posts_date_value));
    setMapValue(ret, 'gender', model.gender);
    setMapValue(ret, 'level', model.level);
    setMapValue(ret, 'location', model.location);
    setMapValue(ret, 'icon', model.icon);
    setMapValue(ret, 'position', model.position);
    setMapValue(ret, 'posts_date', model.posts_date);
    setMapValue(ret, 'mobileSign', model.mobileSign);
    setMapValue(ret, 'is_quote', model.is_quote);
    setMapValue(ret, 'quote_pid', passProcessor.serialize(model.quote_pid));
    setMapValue(ret, 'quote_content', model.quote_content);
    setMapValue(ret, 'quote_user_name', model.quote_user_name);
    setMapValue(
        ret,
        'reply_content',
        codeIterable(model.reply_content,
            (val) => _postContentSerializer.toMap(val as PostContent)));
    setMapValue(ret, 'reply_id', model.reply_id);
    setMapValue(ret, 'reply_name', model.reply_name);
    setMapValue(ret, 'reply_posts_id', model.reply_posts_id);
    setMapValue(ret, 'reply_status', model.reply_status);
    setMapValue(ret, 'reply_type', model.reply_type);
    setMapValue(ret, 'status', model.status);
    setMapValue(ret, 'title', model.title);
    setMapValue(ret, 'userTitle', model.userTitle);
    setMapValue(ret, 'role_num', passProcessor.serialize(model.role_num));
    return ret;
  }

  @override
  PostReply fromMap(Map map) {
    if (map == null) return null;
    final obj = PostReply();
    obj.gender = map['gender'] as int;
    obj.level = map['level'] as num;
    obj.location = map['location'] as String;
    obj.icon = map['icon'] as String;
    obj.position = map['position'] as int;
    obj.posts_date = map['posts_date'] as String;
    obj.mobileSign = map['mobileSign'] as String;
    obj.is_quote = map['is_quote'] as int;
    obj.quote_pid = passProcessor.deserialize(map['quote_pid']);
    obj.quote_content = map['quote_content'] as String;
    obj.quote_user_name = map['quote_user_name'] as String;
    obj.reply_content = codeIterable<PostContent>(
        map['reply_content'] as Iterable,
        (val) => _postContentSerializer.fromMap(val as Map));
    obj.reply_id = map['reply_id'] as int;
    obj.reply_name = map['reply_name'] as String;
    obj.reply_posts_id = map['reply_posts_id'] as int;
    obj.reply_status = map['reply_status'] as int;
    obj.reply_type = map['reply_type'] as String;
    obj.status = map['status'] as int;
    obj.title = map['title'] as String;
    obj.userTitle = map['userTitle'] as String;
    obj.role_num = passProcessor.deserialize(map['role_num']);
    return obj;
  }
}
