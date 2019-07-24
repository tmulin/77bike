// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forum_topicadmin.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$PublishTopicRequestSerializer
    implements Serializer<PublishTopicRequest> {
  Serializer<PublishTopicRequestBody> __publishTopicRequestBodySerializer;
  Serializer<PublishTopicRequestBody> get _publishTopicRequestBodySerializer =>
      __publishTopicRequestBodySerializer ??=
          PublishTopicRequestBodySerializer();
  @override
  Map<String, dynamic> toMap(PublishTopicRequest model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(
        ret, 'body', _publishTopicRequestBodySerializer.toMap(model.body));
    return ret;
  }

  @override
  PublishTopicRequest fromMap(Map map) {
    if (map == null) return null;
    final obj = PublishTopicRequest();
    obj.body = _publishTopicRequestBodySerializer.fromMap(map['body'] as Map);
    return obj;
  }
}

abstract class _$PublishTopicRequestBodySerializer
    implements Serializer<PublishTopicRequestBody> {
  @override
  Map<String, dynamic> toMap(PublishTopicRequestBody model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'json',
        codeMap(model.json, (val) => passProcessor.serialize(val)));
    return ret;
  }

  @override
  PublishTopicRequestBody fromMap(Map map) {
    if (map == null) return null;
    final obj = PublishTopicRequestBody();
    obj.json = codeMap<dynamic>(
        map['json'] as Map, (val) => passProcessor.deserialize(val));
    return obj;
  }
}

abstract class _$PublishTopicModelSerializer
    implements Serializer<PublishTopicModel> {
  @override
  Map<String, dynamic> toMap(PublishTopicModel model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'fid', model.fid);
    setMapValue(ret, 'tid', model.tid);
    setMapValue(ret, 'typeId', model.typeId);
    setMapValue(ret, 'replyId', model.replyId);
    setMapValue(ret, 'location', model.location);
    setMapValue(ret, 'aid', model.aid);
    setMapValue(ret, 'title', model.title);
    setMapValue(ret, 'content', model.content);
    setMapValue(ret, 'longitude', model.longitude);
    setMapValue(ret, 'latitude', model.latitude);
    setMapValue(ret, 'isQuote', model.isQuote);
    setMapValue(ret, 'isHidden', model.isHidden);
    setMapValue(ret, 'isAnonymous', model.isAnonymous);
    setMapValue(ret, 'isOnlyAuthor', model.isOnlyAuthor);
    setMapValue(ret, 'isShowPostion', model.isShowPostion);
    return ret;
  }

  @override
  PublishTopicModel fromMap(Map map) {
    if (map == null) return null;
    final obj = PublishTopicModel();
    obj.fid = map['fid'] as int;
    obj.tid = map['tid'] as int;
    obj.typeId = map['typeId'] as int;
    obj.replyId = map['replyId'] as int;
    obj.location = map['location'] as String;
    obj.aid = map['aid'] as String;
    obj.title = map['title'] as String;
    obj.content = map['content'] as String;
    obj.longitude = map['longitude'] as String;
    obj.latitude = map['latitude'] as String;
    obj.isQuote = map['isQuote'] as int;
    obj.isHidden = map['isHidden'] as int;
    obj.isAnonymous = map['isAnonymous'] as int;
    obj.isOnlyAuthor = map['isOnlyAuthor'] as int;
    obj.isShowPostion = map['isShowPostion'] as int;
    return obj;
  }
}

abstract class _$PostContentSerializer implements Serializer<PostContent> {
  @override
  Map<String, dynamic> toMap(PostContent model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'type', model.type);
    setMapValue(ret, 'infor', model.infor);
    return ret;
  }

  @override
  PostContent fromMap(Map map) {
    if (map == null) return null;
    final obj = PostContent();
    obj.type = map['type'] as int;
    obj.infor = map['infor'] as String;
    return obj;
  }
}
