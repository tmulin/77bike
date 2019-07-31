// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_pmsession.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$MessagePmSessionResponseSerializer
    implements Serializer<MessagePmSessionResponse> {
  Serializer<ResponseBody> __responseBodySerializer;
  Serializer<ResponseBody> get _responseBodySerializer =>
      __responseBodySerializer ??= ResponseBodySerializer();
  Serializer<ResponseHead> __responseHeadSerializer;
  Serializer<ResponseHead> get _responseHeadSerializer =>
      __responseHeadSerializer ??= ResponseHeadSerializer();
  @override
  Map<String, dynamic> toMap(MessagePmSessionResponse model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'body', _responseBodySerializer.toMap(model.body));
    setMapValue(ret, 'noError', model.noError);
    setMapValue(ret, 'rs', model.rs);
    setMapValue(ret, 'errcode', passProcessor.serialize(model.errcode));
    setMapValue(ret, 'head', _responseHeadSerializer.toMap(model.head));
    return ret;
  }

  @override
  MessagePmSessionResponse fromMap(Map map) {
    if (map == null) return null;
    final obj = MessagePmSessionResponse();
    obj.body = _responseBodySerializer.fromMap(map['body'] as Map);
    obj.rs = map['rs'] as int;
    obj.errcode = passProcessor.deserialize(map['errcode']);
    obj.head = _responseHeadSerializer.fromMap(map['head'] as Map);
    return obj;
  }
}

abstract class _$ResponseBodySerializer implements Serializer<ResponseBody> {
  Serializer<PmSession> __pmSessionSerializer;
  Serializer<PmSession> get _pmSessionSerializer =>
      __pmSessionSerializer ??= PmSessionSerializer();
  Serializer<PmUserInfo> __pmUserInfoSerializer;
  Serializer<PmUserInfo> get _pmUserInfoSerializer =>
      __pmUserInfoSerializer ??= PmUserInfoSerializer();
  @override
  Map<String, dynamic> toMap(ResponseBody model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(
        ret,
        'pmList',
        codeIterable(model.pmList,
            (val) => _pmSessionSerializer.toMap(val as PmSession)));
    setMapValue(ret, 'userInfo', _pmUserInfoSerializer.toMap(model.userInfo));
    return ret;
  }

  @override
  ResponseBody fromMap(Map map) {
    if (map == null) return null;
    final obj = ResponseBody();
    obj.pmList = codeIterable<PmSession>(map['pmList'] as Iterable,
        (val) => _pmSessionSerializer.fromMap(val as Map));
    obj.userInfo = _pmUserInfoSerializer.fromMap(map['userInfo'] as Map);
    return obj;
  }
}

abstract class _$PmSessionSerializer implements Serializer<PmSession> {
  Serializer<PmMessage> __pmMessageSerializer;
  Serializer<PmMessage> get _pmMessageSerializer =>
      __pmMessageSerializer ??= PmMessageSerializer();
  @override
  Map<String, dynamic> toMap(PmSession model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'fromUid', model.fromUid);
    setMapValue(ret, 'name', model.name);
    setMapValue(ret, 'avatar', model.avatar);
    setMapValue(ret, 'plid', model.plid);
    setMapValue(ret, 'hasPrev', model.hasPrev);
    setMapValue(
        ret,
        'msgList',
        codeIterable(model.msgList,
            (val) => _pmMessageSerializer.toMap(val as PmMessage)));
    return ret;
  }

  @override
  PmSession fromMap(Map map) {
    if (map == null) return null;
    final obj = PmSession();
    obj.fromUid = map['fromUid'] as int;
    obj.name = map['name'] as String;
    obj.avatar = map['avatar'] as String;
    obj.plid = map['plid'] as int;
    obj.hasPrev = map['hasPrev'] as int;
    obj.msgList = codeIterable<PmMessage>(map['msgList'] as Iterable,
        (val) => _pmMessageSerializer.fromMap(val as Map));
    return obj;
  }
}

abstract class _$PmMessageSerializer implements Serializer<PmMessage> {
  @override
  Map<String, dynamic> toMap(PmMessage model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'sender', model.sender);
    setMapValue(ret, 'mid', model.mid);
    setMapValue(ret, 'type', model.type);
    setMapValue(ret, 'content', model.content);
    setMapValue(ret, 'time', model.time);
    return ret;
  }

  @override
  PmMessage fromMap(Map map) {
    if (map == null) return null;
    final obj = PmMessage();
    obj.sender = map['sender'] as int;
    obj.mid = map['mid'] as int;
    obj.type = map['type'] as String;
    obj.content = map['content'] as String;
    obj.time = map['time'] as String;
    return obj;
  }
}

abstract class _$PmUserInfoSerializer implements Serializer<PmUserInfo> {
  @override
  Map<String, dynamic> toMap(PmUserInfo model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'uid', model.uid);
    setMapValue(ret, 'name', model.name);
    setMapValue(ret, 'avatar', model.avatar);
    return ret;
  }

  @override
  PmUserInfo fromMap(Map map) {
    if (map == null) return null;
    final obj = PmUserInfo();
    obj.uid = map['uid'] as int;
    obj.name = map['name'] as String;
    obj.avatar = map['avatar'] as String;
    return obj;
  }
}
