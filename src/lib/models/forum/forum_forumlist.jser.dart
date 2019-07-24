// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forum_forumlist.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$ForumListResponseSerializer
    implements Serializer<ForumListResponse> {
  Serializer<BoardCategory> __boardCategorySerializer;
  Serializer<BoardCategory> get _boardCategorySerializer =>
      __boardCategorySerializer ??= BoardCategorySerializer();
  Serializer<ResponseHead> __responseHeadSerializer;
  Serializer<ResponseHead> get _responseHeadSerializer =>
      __responseHeadSerializer ??= ResponseHeadSerializer();
  @override
  Map<String, dynamic> toMap(ForumListResponse model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(
        ret,
        'list',
        codeIterable(model.list,
            (val) => _boardCategorySerializer.toMap(val as BoardCategory)));
    setMapValue(ret, 'online_user_num', model.online_user_num);
    setMapValue(ret, 'img_url', model.img_url);
    setMapValue(ret, 'td_visitors', model.td_visitors);
    setMapValue(ret, 'noError', model.noError);
    setMapValue(ret, 'rs', model.rs);
    setMapValue(ret, 'errcode', passProcessor.serialize(model.errcode));
    setMapValue(ret, 'head', _responseHeadSerializer.toMap(model.head));
    return ret;
  }

  @override
  ForumListResponse fromMap(Map map) {
    if (map == null) return null;
    final obj = ForumListResponse();
    obj.list = codeIterable<BoardCategory>(map['list'] as Iterable,
        (val) => _boardCategorySerializer.fromMap(val as Map));
    obj.online_user_num = map['online_user_num'] as int;
    obj.img_url = map['img_url'] as String;
    obj.td_visitors = map['td_visitors'] as int;
    obj.rs = map['rs'] as int;
    obj.errcode = passProcessor.deserialize(map['errcode']);
    obj.head = _responseHeadSerializer.fromMap(map['head'] as Map);
    return obj;
  }
}

abstract class _$BoardCategorySerializer implements Serializer<BoardCategory> {
  Serializer<Board> __boardSerializer;
  Serializer<Board> get _boardSerializer =>
      __boardSerializer ??= BoardSerializer();
  @override
  Map<String, dynamic> toMap(BoardCategory model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'board_category_id', model.board_category_id);
    setMapValue(ret, 'board_category_name', model.board_category_name);
    setMapValue(ret, 'board_category_type', model.board_category_type);
    setMapValue(
        ret,
        'board_list',
        codeIterable(
            model.board_list, (val) => _boardSerializer.toMap(val as Board)));
    return ret;
  }

  @override
  BoardCategory fromMap(Map map) {
    if (map == null) return null;
    final obj = BoardCategory();
    obj.board_category_id = map['board_category_id'] as int;
    obj.board_category_name = map['board_category_name'] as String;
    obj.board_category_type = map['board_category_type'] as int;
    obj.board_list = codeIterable<Board>(map['board_list'] as Iterable,
        (val) => _boardSerializer.fromMap(val as Map));
    return obj;
  }
}

abstract class _$BoardSerializer implements Serializer<Board> {
  @override
  Map<String, dynamic> toMap(Board model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'last_posts_date_value',
        dateTimeUtcProcessor.serialize(model.last_posts_date_value));
    setMapValue(ret, 'board_id', model.board_id);
    setMapValue(ret, 'board_name', model.board_name);
    setMapValue(ret, 'description', model.description);
    setMapValue(ret, 'board_child', model.board_child);
    setMapValue(ret, 'board_img', model.board_img);
    setMapValue(ret, 'board_content', model.board_content);
    setMapValue(ret, 'td_posts_num', model.td_posts_num);
    setMapValue(ret, 'topic_total_num', model.topic_total_num);
    setMapValue(ret, 'posts_total_num', model.posts_total_num);
    setMapValue(ret, 'last_posts_date', model.last_posts_date);
    setMapValue(ret, 'forumRedirect', model.forumRedirect);
    setMapValue(ret, 'is_focus', model.is_focus);
    return ret;
  }

  @override
  Board fromMap(Map map) {
    if (map == null) return null;
    final obj = Board();
    obj.board_id = map['board_id'] as int;
    obj.board_name = map['board_name'] as String;
    obj.description = map['description'] as String;
    obj.board_child = map['board_child'] as int;
    obj.board_img = map['board_img'] as String;
    obj.board_content = map['board_content'] as int;
    obj.td_posts_num = map['td_posts_num'] as int;
    obj.topic_total_num = map['topic_total_num'] as int;
    obj.posts_total_num = map['posts_total_num'] as int;
    obj.last_posts_date = map['last_posts_date'] as String;
    obj.forumRedirect = map['forumRedirect'] as String;
    obj.is_focus = map['is_focus'] as int;
    return obj;
  }
}
