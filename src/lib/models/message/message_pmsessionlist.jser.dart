// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_pmsessionlist.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$MessagePmSessionListResponseSerializer
    implements Serializer<MessagePmSessionListResponse> {
  Serializer<ResponseBody> __responseBodySerializer;
  Serializer<ResponseBody> get _responseBodySerializer =>
      __responseBodySerializer ??= ResponseBodySerializer();
  Serializer<ResponseHead> __responseHeadSerializer;
  Serializer<ResponseHead> get _responseHeadSerializer =>
      __responseHeadSerializer ??= ResponseHeadSerializer();
  @override
  Map<String, dynamic> toMap(MessagePmSessionListResponse model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'body', _responseBodySerializer.toMap(model.body));
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
  MessagePmSessionListResponse fromMap(Map map) {
    if (map == null) return null;
    final obj = MessagePmSessionListResponse();
    obj.body = _responseBodySerializer.fromMap(map['body'] as Map);
    obj.page = map['page'] as int;
    obj.has_next = map['has_next'] as int;
    obj.total_num = map['total_num'] as int;
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
  @override
  Map<String, dynamic> toMap(ResponseBody model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(
        ret,
        'list',
        codeIterable(
            model.list, (val) => _pmSessionSerializer.toMap(val as PmSession)));
    return ret;
  }

  @override
  ResponseBody fromMap(Map map) {
    if (map == null) return null;
    final obj = ResponseBody();
    obj.list = codeIterable<PmSession>(map['list'] as Iterable,
        (val) => _pmSessionSerializer.fromMap(val as Map));
    return obj;
  }
}

abstract class _$PmSessionSerializer implements Serializer<PmSession> {
  @override
  Map<String, dynamic> toMap(PmSession model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'lastDatelineValue',
        dateTimeUtcProcessor.serialize(model.lastDatelineValue));
    setMapValue(ret, 'pmid', model.pmid);
    setMapValue(ret, 'plid', model.plid);
    setMapValue(ret, 'lastUserId', model.lastUserId);
    setMapValue(ret, 'lastUserName', model.lastUserName);
    setMapValue(ret, 'lastSummary', model.lastSummary);
    setMapValue(ret, 'lastDateline', model.lastDateline);
    setMapValue(ret, 'toUserAvatar', model.toUserAvatar);
    setMapValue(ret, 'toUserId', model.toUserId);
    setMapValue(ret, 'toUserName', model.toUserName);
    setMapValue(ret, 'toUserIsBlack', model.toUserIsBlack);
    return ret;
  }

  @override
  PmSession fromMap(Map map) {
    if (map == null) return null;
    final obj = PmSession();
    obj.pmid = map['pmid'] as int;
    obj.plid = map['plid'] as int;
    obj.lastUserId = map['lastUserId'] as int;
    obj.lastUserName = map['lastUserName'] as String;
    obj.lastSummary = map['lastSummary'] as String;
    obj.lastDateline = map['lastDateline'] as String;
    obj.toUserAvatar = map['toUserAvatar'] as String;
    obj.toUserId = map['toUserId'] as int;
    obj.toUserName = map['toUserName'] as String;
    obj.toUserIsBlack = map['toUserIsBlack'] as int;
    return obj;
  }
}
