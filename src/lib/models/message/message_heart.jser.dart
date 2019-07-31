// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_heart.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$MessageHeartResponseSerializer
    implements Serializer<MessageHeartResponse> {
  Serializer<ResponseBody> __responseBodySerializer;
  Serializer<ResponseBody> get _responseBodySerializer =>
      __responseBodySerializer ??= ResponseBodySerializer();
  Serializer<ResponseHead> __responseHeadSerializer;
  Serializer<ResponseHead> get _responseHeadSerializer =>
      __responseHeadSerializer ??= ResponseHeadSerializer();
  @override
  Map<String, dynamic> toMap(MessageHeartResponse model) {
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
  MessageHeartResponse fromMap(Map map) {
    if (map == null) return null;
    final obj = MessageHeartResponse();
    obj.body = _responseBodySerializer.fromMap(map['body'] as Map);
    obj.rs = map['rs'] as int;
    obj.errcode = passProcessor.deserialize(map['errcode']);
    obj.head = _responseHeadSerializer.fromMap(map['head'] as Map);
    return obj;
  }
}

abstract class _$ResponseBodySerializer implements Serializer<ResponseBody> {
  Serializer<HeartPeriod> __heartPeriodSerializer;
  Serializer<HeartPeriod> get _heartPeriodSerializer =>
      __heartPeriodSerializer ??= HeartPeriodSerializer();
  Serializer<CountTime> __countTimeSerializer;
  Serializer<CountTime> get _countTimeSerializer =>
      __countTimeSerializer ??= CountTimeSerializer();
  Serializer<PmInfo> __pmInfoSerializer;
  Serializer<PmInfo> get _pmInfoSerializer =>
      __pmInfoSerializer ??= PmInfoSerializer();
  @override
  Map<String, dynamic> toMap(ResponseBody model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(
        ret, 'externInfo', _heartPeriodSerializer.toMap(model.externInfo));
    setMapValue(
        ret, 'friendInfo', _countTimeSerializer.toMap(model.friendInfo));
    setMapValue(ret, 'replyInfo', _countTimeSerializer.toMap(model.replyInfo));
    setMapValue(ret, 'atMeInfo', _countTimeSerializer.toMap(model.atMeInfo));
    setMapValue(
        ret,
        'pmInfos',
        codeIterable(
            model.pmInfos, (val) => _pmInfoSerializer.toMap(val as PmInfo)));
    return ret;
  }

  @override
  ResponseBody fromMap(Map map) {
    if (map == null) return null;
    final obj = ResponseBody();
    obj.externInfo = _heartPeriodSerializer.fromMap(map['externInfo'] as Map);
    obj.friendInfo = _countTimeSerializer.fromMap(map['friendInfo'] as Map);
    obj.replyInfo = _countTimeSerializer.fromMap(map['replyInfo'] as Map);
    obj.atMeInfo = _countTimeSerializer.fromMap(map['atMeInfo'] as Map);
    obj.pmInfos = codeIterable<PmInfo>(map['pmInfos'] as Iterable,
        (val) => _pmInfoSerializer.fromMap(val as Map));
    return obj;
  }
}

abstract class _$HeartPeriodSerializer implements Serializer<HeartPeriod> {
  @override
  Map<String, dynamic> toMap(HeartPeriod model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'heartPeriodValue', model.heartPeriodValue);
    setMapValue(ret, 'pmPeriodValue', model.pmPeriodValue);
    setMapValue(ret, 'heartPeriod', model.heartPeriod);
    setMapValue(ret, 'pmPeriod', model.pmPeriod);
    return ret;
  }

  @override
  HeartPeriod fromMap(Map map) {
    if (map == null) return null;
    final obj = HeartPeriod();
    obj.heartPeriod = map['heartPeriod'] as String;
    obj.pmPeriod = map['pmPeriod'] as String;
    return obj;
  }
}

abstract class _$CountTimeSerializer implements Serializer<CountTime> {
  @override
  Map<String, dynamic> toMap(CountTime model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'count', model.count);
    setMapValue(ret, 'time', model.time);
    return ret;
  }

  @override
  CountTime fromMap(Map map) {
    if (map == null) return null;
    final obj = CountTime();
    obj.count = map['count'] as int;
    obj.time = map['time'] as String;
    return obj;
  }
}

abstract class _$PmInfoSerializer implements Serializer<PmInfo> {
  @override
  Map<String, dynamic> toMap(PmInfo model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'fromUid', model.fromUid);
    setMapValue(ret, 'name', model.name);
    setMapValue(ret, 'avatar', model.avatar);
    setMapValue(ret, 'plid', model.plid);
    setMapValue(ret, 'hasPrev', model.hasPrev);
    setMapValue(ret, 'msgList',
        codeIterable(model.msgList, (val) => passProcessor.serialize(val)));
    return ret;
  }

  @override
  PmInfo fromMap(Map map) {
    if (map == null) return null;
    final obj = PmInfo();
    obj.fromUid = map['fromUid'] as int;
    obj.name = map['name'] as String;
    obj.avatar = map['avatar'] as String;
    obj.plid = map['plid'] as int;
    obj.hasPrev = map['hasPrev'] as int;
    obj.msgList = codeIterable<dynamic>(
        map['msgList'] as Iterable, (val) => passProcessor.deserialize(val));
    return obj;
  }
}
