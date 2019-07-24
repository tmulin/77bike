// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forum_sendattachmentex.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$SendAttachmentResponseSerializer
    implements Serializer<SendAttachmentResponse> {
  Serializer<ResponseBody> __responseBodySerializer;
  Serializer<ResponseBody> get _responseBodySerializer =>
      __responseBodySerializer ??= ResponseBodySerializer();
  Serializer<ResponseHead> __responseHeadSerializer;
  Serializer<ResponseHead> get _responseHeadSerializer =>
      __responseHeadSerializer ??= ResponseHeadSerializer();
  @override
  Map<String, dynamic> toMap(SendAttachmentResponse model) {
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
  SendAttachmentResponse fromMap(Map map) {
    if (map == null) return null;
    final obj = SendAttachmentResponse();
    obj.body = _responseBodySerializer.fromMap(map['body'] as Map);
    obj.rs = map['rs'] as int;
    obj.errcode = passProcessor.deserialize(map['errcode']);
    obj.head = _responseHeadSerializer.fromMap(map['head'] as Map);
    return obj;
  }
}

abstract class _$ResponseBodySerializer implements Serializer<ResponseBody> {
  Serializer<Attachment> __attachmentSerializer;
  Serializer<Attachment> get _attachmentSerializer =>
      __attachmentSerializer ??= AttachmentSerializer();
  @override
  Map<String, dynamic> toMap(ResponseBody model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(
        ret,
        'attachment',
        codeIterable(model.attachment,
            (val) => _attachmentSerializer.toMap(val as Attachment)));
    setMapValue(ret, 'externInfo', passProcessor.serialize(model.externInfo));
    return ret;
  }

  @override
  ResponseBody fromMap(Map map) {
    if (map == null) return null;
    final obj = ResponseBody();
    obj.attachment = codeIterable<Attachment>(map['attachment'] as Iterable,
        (val) => _attachmentSerializer.fromMap(val as Map));
    obj.externInfo = passProcessor.deserialize(map['externInfo']);
    return obj;
  }
}

abstract class _$AttachmentSerializer implements Serializer<Attachment> {
  @override
  Map<String, dynamic> toMap(Attachment model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'id', model.id);
    setMapValue(ret, 'urlName', model.urlName);
    return ret;
  }

  @override
  Attachment fromMap(Map map) {
    if (map == null) return null;
    final obj = Attachment();
    obj.id = map['id'] as int;
    obj.urlName = map['urlName'] as String;
    return obj;
  }
}
