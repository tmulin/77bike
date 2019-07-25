// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_albumlist.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$UserAlbumlistResponseSerializer
    implements Serializer<UserAlbumlistResponse> {
  Serializer<UserAlbum> __userAlbumSerializer;
  Serializer<UserAlbum> get _userAlbumSerializer =>
      __userAlbumSerializer ??= UserAlbumSerializer();
  Serializer<ResponseHead> __responseHeadSerializer;
  Serializer<ResponseHead> get _responseHeadSerializer =>
      __responseHeadSerializer ??= ResponseHeadSerializer();
  @override
  Map<String, dynamic> toMap(UserAlbumlistResponse model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'page', model.page);
    setMapValue(ret, 'has_next', model.has_next);
    setMapValue(ret, 'total_num', model.total_num);
    setMapValue(
        ret,
        'list',
        codeIterable(
            model.list, (val) => _userAlbumSerializer.toMap(val as UserAlbum)));
    setMapValue(ret, 'noError', model.noError);
    setMapValue(ret, 'rs', model.rs);
    setMapValue(ret, 'errcode', passProcessor.serialize(model.errcode));
    setMapValue(ret, 'head', _responseHeadSerializer.toMap(model.head));
    return ret;
  }

  @override
  UserAlbumlistResponse fromMap(Map map) {
    if (map == null) return null;
    final obj = UserAlbumlistResponse();
    obj.page = map['page'] as int;
    obj.has_next = map['has_next'] as int;
    obj.total_num = map['total_num'] as int;
    obj.list = codeIterable<UserAlbum>(map['list'] as Iterable,
        (val) => _userAlbumSerializer.fromMap(val as Map));
    obj.rs = map['rs'] as int;
    obj.errcode = passProcessor.deserialize(map['errcode']);
    obj.head = _responseHeadSerializer.fromMap(map['head'] as Map);
    return obj;
  }
}

abstract class _$UserPhotolistResponseSerializer
    implements Serializer<UserPhotolistResponse> {
  Serializer<UserPhoto> __userPhotoSerializer;
  Serializer<UserPhoto> get _userPhotoSerializer =>
      __userPhotoSerializer ??= UserPhotoSerializer();
  Serializer<ResponseHead> __responseHeadSerializer;
  Serializer<ResponseHead> get _responseHeadSerializer =>
      __responseHeadSerializer ??= ResponseHeadSerializer();
  @override
  Map<String, dynamic> toMap(UserPhotolistResponse model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'page', model.page);
    setMapValue(ret, 'has_next', model.has_next);
    setMapValue(ret, 'total_num', model.total_num);
    setMapValue(
        ret,
        'list',
        codeIterable(
            model.list, (val) => _userPhotoSerializer.toMap(val as UserPhoto)));
    setMapValue(ret, 'noError', model.noError);
    setMapValue(ret, 'rs', model.rs);
    setMapValue(ret, 'errcode', passProcessor.serialize(model.errcode));
    setMapValue(ret, 'head', _responseHeadSerializer.toMap(model.head));
    return ret;
  }

  @override
  UserPhotolistResponse fromMap(Map map) {
    if (map == null) return null;
    final obj = UserPhotolistResponse();
    obj.page = map['page'] as int;
    obj.has_next = map['has_next'] as int;
    obj.total_num = map['total_num'] as int;
    obj.list = codeIterable<UserPhoto>(map['list'] as Iterable,
        (val) => _userPhotoSerializer.fromMap(val as Map));
    obj.rs = map['rs'] as int;
    obj.errcode = passProcessor.deserialize(map['errcode']);
    obj.head = _responseHeadSerializer.fromMap(map['head'] as Map);
    return obj;
  }
}

abstract class _$UserAlbumSerializer implements Serializer<UserAlbum> {
  @override
  Map<String, dynamic> toMap(UserAlbum model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'release_date_value',
        dateTimeUtcProcessor.serialize(model.release_date_value));
    setMapValue(ret, 'last_update_date_value',
        dateTimeUtcProcessor.serialize(model.last_update_date_value));
    setMapValue(ret, 'album_id', model.album_id);
    setMapValue(ret, 'user_id', model.user_id);
    setMapValue(ret, 'release_date', model.release_date);
    setMapValue(ret, 'title', model.title);
    setMapValue(ret, 'info', model.info);
    setMapValue(ret, 'user_nick_name', model.user_nick_name);
    setMapValue(ret, 'last_update_date', model.last_update_date);
    setMapValue(ret, 'thumb_pic', model.thumb_pic);
    return ret;
  }

  @override
  UserAlbum fromMap(Map map) {
    if (map == null) return null;
    final obj = UserAlbum();
    obj.album_id = map['album_id'] as int;
    obj.user_id = map['user_id'] as int;
    obj.release_date = map['release_date'] as String;
    obj.title = map['title'] as String;
    obj.info = map['info'] as String;
    obj.user_nick_name = map['user_nick_name'] as String;
    obj.last_update_date = map['last_update_date'] as String;
    obj.thumb_pic = map['thumb_pic'] as String;
    return obj;
  }
}

abstract class _$UserPhotoSerializer implements Serializer<UserPhoto> {
  @override
  Map<String, dynamic> toMap(UserPhoto model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'release_date_value',
        dateTimeUtcProcessor.serialize(model.release_date_value));
    setMapValue(ret, 'last_update_date_value',
        dateTimeUtcProcessor.serialize(model.last_update_date_value));
    setMapValue(ret, 'album_id', model.album_id);
    setMapValue(ret, 'pic_id', model.pic_id);
    setMapValue(ret, 'user_id', model.user_id);
    setMapValue(ret, 'last_update_date', model.last_update_date);
    setMapValue(ret, 'release_date', model.release_date);
    setMapValue(ret, 'user_nick_name', model.user_nick_name);
    setMapValue(ret, 'hot', model.hot);
    setMapValue(ret, 'replies', model.replies);
    setMapValue(ret, 'thumb_pic', model.thumb_pic);
    setMapValue(ret, 'origin_pic', model.origin_pic);
    return ret;
  }

  @override
  UserPhoto fromMap(Map map) {
    if (map == null) return null;
    final obj = UserPhoto();
    obj.album_id = map['album_id'] as int;
    obj.pic_id = map['pic_id'] as int;
    obj.user_id = map['user_id'] as int;
    obj.last_update_date = map['last_update_date'] as String;
    obj.release_date = map['release_date'] as String;
    obj.user_nick_name = map['user_nick_name'] as String;
    obj.hot = map['hot'] as int;
    obj.replies = map['replies'] as int;
    obj.thumb_pic = map['thumb_pic'] as String;
    obj.origin_pic = map['origin_pic'] as String;
    return obj;
  }
}
