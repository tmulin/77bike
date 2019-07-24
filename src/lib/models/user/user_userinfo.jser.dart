// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_userinfo.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$UserInfoResponseSerializer
    implements Serializer<UserInfoResponse> {
  final _intOrEmptyStringField = const IntOrEmptyStringField();
  Serializer<_ResponseBody> ___ResponseBodySerializer;
  Serializer<_ResponseBody> get __ResponseBodySerializer =>
      ___ResponseBodySerializer ??= _ResponseBodySerializer();
  Serializer<ResponseHead> __responseHeadSerializer;
  Serializer<ResponseHead> get _responseHeadSerializer =>
      __responseHeadSerializer ??= ResponseHeadSerializer();
  @override
  Map<String, dynamic> toMap(UserInfoResponse model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'body', __ResponseBodySerializer.toMap(model.body));
    setMapValue(ret, 'credits', model.credits);
    setMapValue(ret, 'email', model.email);
    setMapValue(ret, 'essence_num', model.essence_num);
    setMapValue(ret, 'follow_num', model.follow_num);
    setMapValue(ret, 'friend_num', model.friend_num);
    setMapValue(ret, 'gender', model.gender);
    setMapValue(ret, 'gold_num', model.gold_num);
    setMapValue(ret, 'icon', model.icon);
    setMapValue(ret, 'is_black', model.is_black);
    setMapValue(ret, 'is_follow', model.is_follow);
    setMapValue(ret, 'isFriend', model.isFriend);
    setMapValue(ret, 'level', model.level);
    setMapValue(ret, 'name', model.name);
    setMapValue(ret, 'photo_num', model.photo_num);
    setMapValue(ret, 'reply_posts_num', model.reply_posts_num);
    setMapValue(ret, 'score', _intOrEmptyStringField.serialize(model.score));
    setMapValue(ret, 'status', model.status);
    setMapValue(ret, 'topic_num', model.topic_num);
    setMapValue(ret, 'userTitle', model.userTitle);
    setMapValue(ret, 'noError', model.noError);
    setMapValue(ret, 'rs', model.rs);
    setMapValue(ret, 'errcode', passProcessor.serialize(model.errcode));
    setMapValue(ret, 'head', _responseHeadSerializer.toMap(model.head));
    return ret;
  }

  @override
  UserInfoResponse fromMap(Map map) {
    if (map == null) return null;
    final obj = UserInfoResponse();
    obj.body = __ResponseBodySerializer.fromMap(map['body'] as Map);
    obj.credits = map['credits'] as int;
    obj.email = map['email'] as String;
    obj.essence_num = map['essence_num'] as int;
    obj.follow_num = map['follow_num'] as int;
    obj.friend_num = map['friend_num'] as int;
    obj.gender = map['gender'] as int;
    obj.gold_num = map['gold_num'] as int;
    obj.icon = map['icon'] as String;
    obj.is_black = map['is_black'] as int;
    obj.is_follow = map['is_follow'] as int;
    obj.isFriend = map['isFriend'] as int;
    obj.level = map['level'] as num;
    obj.name = map['name'] as String;
    obj.photo_num = map['photo_num'] as int;
    obj.reply_posts_num = map['reply_posts_num'] as int;
    obj.score = _intOrEmptyStringField.deserialize(map['score']);
    obj.status = map['status'] as int;
    obj.topic_num = map['topic_num'] as int;
    obj.userTitle = map['userTitle'] as String;
    obj.rs = map['rs'] as int;
    obj.errcode = passProcessor.deserialize(map['errcode']);
    obj.head = _responseHeadSerializer.fromMap(map['head'] as Map);
    return obj;
  }
}

abstract class _$_ResponseBodySerializer implements Serializer<_ResponseBody> {
  Serializer<CreditItem> __creditItemSerializer;
  Serializer<CreditItem> get _creditItemSerializer =>
      __creditItemSerializer ??= CreditItemSerializer();
  Serializer<ProfileItem> __profileItemSerializer;
  Serializer<ProfileItem> get _profileItemSerializer =>
      __profileItemSerializer ??= ProfileItemSerializer();
  @override
  Map<String, dynamic> toMap(_ResponseBody model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(
        ret,
        'creditList',
        codeIterable(model.creditList,
            (val) => _creditItemSerializer.toMap(val as CreditItem)));
    setMapValue(
        ret,
        'creditShowList',
        codeIterable(model.creditShowList,
            (val) => _creditItemSerializer.toMap(val as CreditItem)));
    setMapValue(
        ret,
        'profileList',
        codeIterable(model.profileList,
            (val) => _profileItemSerializer.toMap(val as ProfileItem)));
    return ret;
  }

  @override
  _ResponseBody fromMap(Map map) {
    if (map == null) return null;
    final obj = _ResponseBody();
    obj.creditList = codeIterable<CreditItem>(map['creditList'] as Iterable,
        (val) => _creditItemSerializer.fromMap(val as Map));
    obj.creditShowList = codeIterable<CreditItem>(
        map['creditShowList'] as Iterable,
        (val) => _creditItemSerializer.fromMap(val as Map));
    obj.profileList = codeIterable<ProfileItem>(map['profileList'] as Iterable,
        (val) => _profileItemSerializer.fromMap(val as Map));
    return obj;
  }
}

abstract class _$CreditItemSerializer implements Serializer<CreditItem> {
  @override
  Map<String, dynamic> toMap(CreditItem model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'type', passProcessor.serialize(model.type));
    setMapValue(ret, 'title', model.title);
    setMapValue(ret, 'data', model.data);
    return ret;
  }

  @override
  CreditItem fromMap(Map map) {
    if (map == null) return null;
    final obj = CreditItem();
    obj.type = passProcessor.deserialize(map['type']);
    obj.title = map['title'] as String;
    obj.data = map['data'] as int;
    return obj;
  }
}

abstract class _$ProfileItemSerializer implements Serializer<ProfileItem> {
  @override
  Map<String, dynamic> toMap(ProfileItem model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'type', passProcessor.serialize(model.type));
    setMapValue(ret, 'title', model.title);
    setMapValue(ret, 'data', model.data);
    return ret;
  }

  @override
  ProfileItem fromMap(Map map) {
    if (map == null) return null;
    final obj = ProfileItem();
    obj.type = passProcessor.deserialize(map['type']);
    obj.title = map['title'] as String;
    obj.data = map['data'] as String;
    return obj;
  }
}
