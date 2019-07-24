// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$MobcentResponseSerializer
    implements Serializer<MobcentResponse> {
  final _intOrEmptyStringField = const IntOrEmptyStringField();
  Serializer<ResponseHead> __responseHeadSerializer;
  Serializer<ResponseHead> get _responseHeadSerializer =>
      __responseHeadSerializer ??= ResponseHeadSerializer();
  @override
  Map<String, dynamic> toMap(MobcentResponse model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'noError', model.noError);
    setMapValue(ret, 'rs', _intOrEmptyStringField.serialize(model.rs));
    setMapValue(
        ret, 'errcode', _intOrEmptyStringField.serialize(model.errcode));
    setMapValue(ret, 'head', _responseHeadSerializer.toMap(model.head));
    return ret;
  }

  @override
  MobcentResponse fromMap(Map map) {
    if (map == null) return null;
    final obj = MobcentResponse();
    obj.rs = _intOrEmptyStringField.deserialize(map['rs']);
    obj.errcode = _intOrEmptyStringField.deserialize(map['errcode']);
    obj.head = _responseHeadSerializer.fromMap(map['head'] as Map);
    return obj;
  }
}

abstract class _$ResponseHeadSerializer implements Serializer<ResponseHead> {
  final _intOrEmptyStringField = const IntOrEmptyStringField();
  @override
  Map<String, dynamic> toMap(ResponseHead model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'alert', _intOrEmptyStringField.serialize(model.alert));
    setMapValue(
        ret, 'errCode', _intOrEmptyStringField.serialize(model.errCode));
    setMapValue(ret, 'errInfo', model.errInfo);
    setMapValue(ret, 'version', model.version);
    return ret;
  }

  @override
  ResponseHead fromMap(Map map) {
    if (map == null) return null;
    final obj = ResponseHead();
    obj.alert = _intOrEmptyStringField.deserialize(map['alert']);
    obj.errCode = _intOrEmptyStringField.deserialize(map['errCode']);
    obj.errInfo = map['errInfo'] as String;
    obj.version = map['version'] as String;
    return obj;
  }
}
