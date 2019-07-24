// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_login.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$UserLoginResponseSerializer
    implements Serializer<UserLoginResponse> {
  Serializer<ResponseHead> __responseHeadSerializer;
  Serializer<ResponseHead> get _responseHeadSerializer =>
      __responseHeadSerializer ??= ResponseHeadSerializer();
  @override
  Map<String, dynamic> toMap(UserLoginResponse model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'uid', model.uid);
    setMapValue(ret, 'token', model.token);
    setMapValue(ret, 'secret', model.secret);
    setMapValue(ret, 'avatar', model.avatar);
    setMapValue(ret, 'userName', model.userName);
    setMapValue(ret, 'noError', model.noError);
    setMapValue(ret, 'rs', model.rs);
    setMapValue(ret, 'errcode', passProcessor.serialize(model.errcode));
    setMapValue(ret, 'head', _responseHeadSerializer.toMap(model.head));
    return ret;
  }

  @override
  UserLoginResponse fromMap(Map map) {
    if (map == null) return null;
    final obj = UserLoginResponse();
    obj.uid = map['uid'] as int;
    obj.token = map['token'] as String;
    obj.secret = map['secret'] as String;
    obj.avatar = map['avatar'] as String;
    obj.userName = map['userName'] as String;
    obj.rs = map['rs'] as int;
    obj.errcode = passProcessor.deserialize(map['errcode']);
    obj.head = _responseHeadSerializer.fromMap(map['head'] as Map);
    return obj;
  }
}
