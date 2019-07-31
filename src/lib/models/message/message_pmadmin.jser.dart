// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_pmadmin.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$MessagePmAdminResponseSerializer
    implements Serializer<MessagePmAdminResponse> {
  Serializer<ResponseBody> __responseBodySerializer;
  Serializer<ResponseBody> get _responseBodySerializer =>
      __responseBodySerializer ??= ResponseBodySerializer();
  Serializer<ResponseHead> __responseHeadSerializer;
  Serializer<ResponseHead> get _responseHeadSerializer =>
      __responseHeadSerializer ??= ResponseHeadSerializer();
  @override
  Map<String, dynamic> toMap(MessagePmAdminResponse model) {
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
  MessagePmAdminResponse fromMap(Map map) {
    if (map == null) return null;
    final obj = MessagePmAdminResponse();
    obj.body = _responseBodySerializer.fromMap(map['body'] as Map);
    obj.rs = map['rs'] as int;
    obj.errcode = passProcessor.deserialize(map['errcode']);
    obj.head = _responseHeadSerializer.fromMap(map['head'] as Map);
    return obj;
  }
}

abstract class _$ResponseBodySerializer implements Serializer<ResponseBody> {
  @override
  Map<String, dynamic> toMap(ResponseBody model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'plid', model.plid);
    setMapValue(ret, 'pmid', model.pmid);
    setMapValue(ret, 'sendTime', model.sendTime);
    return ret;
  }

  @override
  ResponseBody fromMap(Map map) {
    if (map == null) return null;
    final obj = ResponseBody();
    obj.plid = map['plid'] as int;
    obj.pmid = map['pmid'] as int;
    obj.sendTime = map['sendTime'] as String;
    return obj;
  }
}
