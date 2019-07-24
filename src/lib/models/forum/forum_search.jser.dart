// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forum_search.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$ForumSearchResponseSerializer
    implements Serializer<ForumSearchResponse> {
  Serializer<SearchTopic> __searchTopicSerializer;
  Serializer<SearchTopic> get _searchTopicSerializer =>
      __searchTopicSerializer ??= SearchTopicSerializer();
  Serializer<ResponseHead> __responseHeadSerializer;
  Serializer<ResponseHead> get _responseHeadSerializer =>
      __responseHeadSerializer ??= ResponseHeadSerializer();
  @override
  Map<String, dynamic> toMap(ForumSearchResponse model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'page', model.page);
    setMapValue(ret, 'has_next', model.has_next);
    setMapValue(ret, 'total_num', model.total_num);
    setMapValue(ret, 'searchid', model.searchid);
    setMapValue(
        ret,
        'list',
        codeIterable(model.list,
            (val) => _searchTopicSerializer.toMap(val as SearchTopic)));
    setMapValue(ret, 'noError', model.noError);
    setMapValue(ret, 'rs', model.rs);
    setMapValue(ret, 'errcode', passProcessor.serialize(model.errcode));
    setMapValue(ret, 'head', _responseHeadSerializer.toMap(model.head));
    return ret;
  }

  @override
  ForumSearchResponse fromMap(Map map) {
    if (map == null) return null;
    final obj = ForumSearchResponse();
    obj.page = map['page'] as int;
    obj.has_next = map['has_next'] as int;
    obj.total_num = map['total_num'] as int;
    obj.searchid = map['searchid'] as int;
    obj.list = codeIterable<SearchTopic>(map['list'] as Iterable,
        (val) => _searchTopicSerializer.fromMap(val as Map));
    obj.rs = map['rs'] as int;
    obj.errcode = passProcessor.deserialize(map['errcode']);
    obj.head = _responseHeadSerializer.fromMap(map['head'] as Map);
    return obj;
  }
}

abstract class _$SearchTopicSerializer implements Serializer<SearchTopic> {
  @override
  Map<String, dynamic> toMap(SearchTopic model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'last_reply_date_value',
        dateTimeUtcProcessor.serialize(model.last_reply_date_value));
    setMapValue(ret, 'board_id', model.board_id);
    setMapValue(ret, 'topic_id', model.topic_id);
    setMapValue(ret, 'type_id', model.type_id);
    setMapValue(ret, 'sort_id', model.sort_id);
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
    setMapValue(ret, 'pic_path', model.pic_path);
    return ret;
  }

  @override
  SearchTopic fromMap(Map map) {
    if (map == null) return null;
    final obj = SearchTopic();
    obj.board_id = map['board_id'] as int;
    obj.topic_id = map['topic_id'] as int;
    obj.type_id = map['type_id'] as int;
    obj.sort_id = map['sort_id'] as int;
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
    obj.pic_path = map['pic_path'] as String;
    return obj;
  }
}
