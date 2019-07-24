// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_notifylist.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$MessageNotifyListResponseSerializer
    implements Serializer<MessageNotifyListResponse> {
  Serializer<Notify> __notifySerializer;
  Serializer<Notify> get _notifySerializer =>
      __notifySerializer ??= NotifySerializer();
  Serializer<ResponseHead> __responseHeadSerializer;
  Serializer<ResponseHead> get _responseHeadSerializer =>
      __responseHeadSerializer ??= ResponseHeadSerializer();
  @override
  Map<String, dynamic> toMap(MessageNotifyListResponse model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'has_next', model.has_next);
    setMapValue(
        ret,
        'list',
        codeIterable(
            model.list, (val) => _notifySerializer.toMap(val as Notify)));
    setMapValue(ret, 'noError', model.noError);
    setMapValue(ret, 'rs', model.rs);
    setMapValue(ret, 'errcode', passProcessor.serialize(model.errcode));
    setMapValue(ret, 'head', _responseHeadSerializer.toMap(model.head));
    return ret;
  }

  @override
  MessageNotifyListResponse fromMap(Map map) {
    if (map == null) return null;
    final obj = MessageNotifyListResponse();
    obj.has_next = map['has_next'] as int;
    obj.list = codeIterable<Notify>(map['list'] as Iterable,
        (val) => _notifySerializer.fromMap(val as Map));
    obj.rs = map['rs'] as int;
    obj.errcode = passProcessor.deserialize(map['errcode']);
    obj.head = _responseHeadSerializer.fromMap(map['head'] as Map);
    return obj;
  }
}

abstract class _$NotifySerializer implements Serializer<Notify> {
  @override
  Map<String, dynamic> toMap(Notify model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'replied_date_value',
        dateTimeUtcProcessor.serialize(model.replied_date_value));
    setMapValue(ret, 'topic_id', model.topic_id);
    setMapValue(ret, 'board_id', model.board_id);
    setMapValue(ret, 'board_name', model.board_name);
    setMapValue(ret, 'topic_content', model.topic_content);
    setMapValue(ret, 'topic_url', model.topic_url);
    setMapValue(ret, 'topic_subject', model.topic_subject);
    setMapValue(ret, 'reply_content', model.reply_content);
    setMapValue(ret, 'reply_url', model.reply_url);
    setMapValue(ret, 'is_read', model.is_read);
    setMapValue(ret, 'reply_remind_id', model.reply_remind_id);
    setMapValue(ret, 'reply_nick_name', model.reply_nick_name);
    setMapValue(ret, 'user_id', model.user_id);
    setMapValue(ret, 'replied_date', model.replied_date);
    setMapValue(ret, 'icon', model.icon);
    return ret;
  }

  @override
  Notify fromMap(Map map) {
    if (map == null) return null;
    final obj = Notify();
    obj.topic_id = map['topic_id'] as int;
    obj.board_id = map['board_id'] as int;
    obj.board_name = map['board_name'] as String;
    obj.topic_content = map['topic_content'] as String;
    obj.topic_url = map['topic_url'] as String;
    obj.topic_subject = map['topic_subject'] as String;
    obj.reply_content = map['reply_content'] as String;
    obj.reply_url = map['reply_url'] as String;
    obj.is_read = map['is_read'] as int;
    obj.reply_remind_id = map['reply_remind_id'] as int;
    obj.reply_nick_name = map['reply_nick_name'] as String;
    obj.user_id = map['user_id'] as int;
    obj.replied_date = map['replied_date'] as String;
    obj.icon = map['icon'] as String;
    return obj;
  }
}
