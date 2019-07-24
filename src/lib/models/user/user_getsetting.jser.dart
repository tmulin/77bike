// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_getsetting.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$UserGetSettingResponseSerializer
    implements Serializer<UserGetSettingResponse> {
  Serializer<_ResponseBody> ___ResponseBodySerializer;
  Serializer<_ResponseBody> get __ResponseBodySerializer =>
      ___ResponseBodySerializer ??= _ResponseBodySerializer();
  Serializer<ResponseHead> __responseHeadSerializer;
  Serializer<ResponseHead> get _responseHeadSerializer =>
      __responseHeadSerializer ??= ResponseHeadSerializer();
  @override
  Map<String, dynamic> toMap(UserGetSettingResponse model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'body', __ResponseBodySerializer.toMap(model.body));
    setMapValue(ret, 'noError', model.noError);
    setMapValue(ret, 'rs', model.rs);
    setMapValue(ret, 'errcode', passProcessor.serialize(model.errcode));
    setMapValue(ret, 'head', _responseHeadSerializer.toMap(model.head));
    return ret;
  }

  @override
  UserGetSettingResponse fromMap(Map map) {
    if (map == null) return null;
    final obj = UserGetSettingResponse();
    obj.body = __ResponseBodySerializer.fromMap(map['body'] as Map);
    obj.rs = map['rs'] as int;
    obj.errcode = passProcessor.deserialize(map['errcode']);
    obj.head = _responseHeadSerializer.fromMap(map['head'] as Map);
    return obj;
  }
}

abstract class _$_ResponseBodySerializer implements Serializer<_ResponseBody> {
  Serializer<_Forum> ___ForumSerializer;
  Serializer<_Forum> get __ForumSerializer =>
      ___ForumSerializer ??= _ForumSerializer();
  Serializer<_Message> ___MessageSerializer;
  Serializer<_Message> get __MessageSerializer =>
      ___MessageSerializer ??= _MessageSerializer();
  Serializer<_Module> ___ModuleSerializer;
  Serializer<_Module> get __ModuleSerializer =>
      ___ModuleSerializer ??= _ModuleSerializer();
  Serializer<_Plugin> ___PluginSerializer;
  Serializer<_Plugin> get __PluginSerializer =>
      ___PluginSerializer ??= _PluginSerializer();
  Serializer<_Portal> ___PortalSerializer;
  Serializer<_Portal> get __PortalSerializer =>
      ___PortalSerializer ??= _PortalSerializer();
  Serializer<_User> ___UserSerializer;
  Serializer<_User> get __UserSerializer =>
      ___UserSerializer ??= _UserSerializer();
  Serializer<_PostInfo> ___PostInfoSerializer;
  Serializer<_PostInfo> get __PostInfoSerializer =>
      ___PostInfoSerializer ??= _PostInfoSerializer();
  @override
  Map<String, dynamic> toMap(_ResponseBody model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'serverTime', model.serverTime);
    setMapValue(ret, 'forum', __ForumSerializer.toMap(model.forum));
    setMapValue(ret, 'message', __MessageSerializer.toMap(model.message));
    setMapValue(
        ret,
        'moduleList',
        codeIterable(model.moduleList,
            (val) => __ModuleSerializer.toMap(val as _Module)));
    setMapValue(ret, 'plugin', __PluginSerializer.toMap(model.plugin));
    setMapValue(ret, 'portal', __PortalSerializer.toMap(model.portal));
    setMapValue(ret, 'user', __UserSerializer.toMap(model.user));
    setMapValue(
        ret,
        'postInfo',
        codeIterable(model.postInfo,
            (val) => __PostInfoSerializer.toMap(val as _PostInfo)));
    return ret;
  }

  @override
  _ResponseBody fromMap(Map map) {
    if (map == null) return null;
    final obj = _ResponseBody();
    obj.serverTime = map['serverTime'] as String;
    obj.forum = __ForumSerializer.fromMap(map['forum'] as Map);
    obj.message = __MessageSerializer.fromMap(map['message'] as Map);
    obj.moduleList = codeIterable<_Module>(map['moduleList'] as Iterable,
        (val) => __ModuleSerializer.fromMap(val as Map));
    obj.plugin = __PluginSerializer.fromMap(map['plugin'] as Map);
    obj.portal = __PortalSerializer.fromMap(map['portal'] as Map);
    obj.user = __UserSerializer.fromMap(map['user'] as Map);
    obj.postInfo = codeIterable<_PostInfo>(map['postInfo'] as Iterable,
        (val) => __PostInfoSerializer.fromMap(val as Map));
    return obj;
  }
}

abstract class _$_ForumSerializer implements Serializer<_Forum> {
  @override
  Map<String, dynamic> toMap(_Forum model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'isSummaryShow', model.isSummaryShow);
    setMapValue(ret, 'isTodayPostCount', model.isTodayPostCount);
    setMapValue(ret, 'postlistOrderby', model.postlistOrderby);
    setMapValue(ret, 'postAudioLimit', model.postAudioLimit);
    return ret;
  }

  @override
  _Forum fromMap(Map map) {
    if (map == null) return null;
    final obj = _Forum();
    obj.isSummaryShow = map['isSummaryShow'] as int;
    obj.isTodayPostCount = map['isTodayPostCount'] as int;
    obj.postlistOrderby = map['postlistOrderby'] as int;
    obj.postAudioLimit = map['postAudioLimit'] as int;
    return obj;
  }
}

abstract class _$_MessageSerializer implements Serializer<_Message> {
  @override
  Map<String, dynamic> toMap(_Message model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'allowPostImage', model.allowPostImage);
    setMapValue(ret, 'pmAudioLimit', model.pmAudioLimit);
    return ret;
  }

  @override
  _Message fromMap(Map map) {
    if (map == null) return null;
    final obj = _Message();
    obj.allowPostImage = map['allowPostImage'] as int;
    obj.pmAudioLimit = map['pmAudioLimit'] as int;
    return obj;
  }
}

abstract class _$_ModuleSerializer implements Serializer<_Module> {
  @override
  Map<String, dynamic> toMap(_Module model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'moduleId', model.moduleId);
    setMapValue(ret, 'moduleName', model.moduleName);
    return ret;
  }

  @override
  _Module fromMap(Map map) {
    if (map == null) return null;
    final obj = _Module();
    obj.moduleId = map['moduleId'] as int;
    obj.moduleName = map['moduleName'] as String;
    return obj;
  }
}

abstract class _$_PluginSerializer implements Serializer<_Plugin> {
  @override
  Map<String, dynamic> toMap(_Plugin model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'qqconnect', model.qqconnect);
    setMapValue(ret, 'dsu_paulsign', model.dsu_paulsign);
    setMapValue(ret, 'wxconnect', model.wxconnect);
    setMapValue(
        ret, 'isMobileRegisterValidation', model.isMobileRegisterValidation);
    return ret;
  }

  @override
  _Plugin fromMap(Map map) {
    if (map == null) return null;
    final obj = _Plugin();
    obj.qqconnect = map['qqconnect'] as int;
    obj.dsu_paulsign = map['dsu_paulsign'] as int;
    obj.wxconnect = map['wxconnect'] as int;
    obj.isMobileRegisterValidation = map['isMobileRegisterValidation'] as int;
    return obj;
  }
}

abstract class _$_PortalSerializer implements Serializer<_Portal> {
  @override
  Map<String, dynamic> toMap(_Portal model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'isSummaryShow', model.isSummaryShow);
    return ret;
  }

  @override
  _Portal fromMap(Map map) {
    if (map == null) return null;
    final obj = _Portal();
    obj.isSummaryShow = map['isSummaryShow'] as int;
    return obj;
  }
}

abstract class _$_UserSerializer implements Serializer<_User> {
  @override
  Map<String, dynamic> toMap(_User model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'allowAt', model.allowAt);
    setMapValue(ret, 'allowRegister', model.allowRegister);
    setMapValue(ret, 'wapRegisterUrl', model.wapRegisterUrl);
    return ret;
  }

  @override
  _User fromMap(Map map) {
    if (map == null) return null;
    final obj = _User();
    obj.allowAt = map['allowAt'] as int;
    obj.allowRegister = map['allowRegister'] as int;
    obj.wapRegisterUrl = map['wapRegisterUrl'] as String;
    return obj;
  }
}

abstract class _$_PostInfoSerializer implements Serializer<_PostInfo> {
  Serializer<Topic> __topicSerializer;
  Serializer<Topic> get _topicSerializer =>
      __topicSerializer ??= TopicSerializer();
  Serializer<Post> __postSerializer;
  Serializer<Post> get _postSerializer => __postSerializer ??= PostSerializer();
  @override
  Map<String, dynamic> toMap(_PostInfo model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'fid', model.fid);
    setMapValue(ret, 'topic', _topicSerializer.toMap(model.topic));
    setMapValue(ret, 'post', _postSerializer.toMap(model.post));
    return ret;
  }

  @override
  _PostInfo fromMap(Map map) {
    if (map == null) return null;
    final obj = _PostInfo();
    obj.fid = map['fid'] as int;
    obj.topic = _topicSerializer.fromMap(map['topic'] as Map);
    obj.post = _postSerializer.fromMap(map['post'] as Map);
    return obj;
  }
}

abstract class _$PostSerializer implements Serializer<Post> {
  @override
  Map<String, dynamic> toMap(Post model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'isHidden', model.isHidden);
    setMapValue(ret, 'isAnonymous', model.isAnonymous);
    setMapValue(ret, 'isOnlyAuthor', model.isOnlyAuthor);
    setMapValue(ret, 'allowPostAttachment', model.allowPostAttachment);
    setMapValue(ret, 'allowPostImage', model.allowPostImage);
    return ret;
  }

  @override
  Post fromMap(Map map) {
    if (map == null) return null;
    final obj = Post();
    obj.isHidden = map['isHidden'] as int;
    obj.isAnonymous = map['isAnonymous'] as int;
    obj.isOnlyAuthor = map['isOnlyAuthor'] as int;
    obj.allowPostAttachment = map['allowPostAttachment'] as int;
    obj.allowPostImage = map['allowPostImage'] as int;
    return obj;
  }
}

abstract class _$TopicSerializer implements Serializer<Topic> {
  Serializer<ClassificationType> __classificationTypeSerializer;
  Serializer<ClassificationType> get _classificationTypeSerializer =>
      __classificationTypeSerializer ??= ClassificationTypeSerializer();
  Serializer<NewTopicPanel> __newTopicPanelSerializer;
  Serializer<NewTopicPanel> get _newTopicPanelSerializer =>
      __newTopicPanelSerializer ??= NewTopicPanelSerializer();
  @override
  Map<String, dynamic> toMap(Topic model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'isHidden', model.isHidden);
    setMapValue(ret, 'isAnonymous', model.isAnonymous);
    setMapValue(ret, 'isOnlyAuthor', model.isOnlyAuthor);
    setMapValue(ret, 'allowPostAttachment', model.allowPostAttachment);
    setMapValue(ret, 'allowPostImage', model.allowPostImage);
    setMapValue(
        ret,
        'classificationType_list',
        codeIterable(
            model.classificationType_list,
            (val) => _classificationTypeSerializer
                .toMap(val as ClassificationType)));
    setMapValue(ret, 'isOnlyTopicType', model.isOnlyTopicType);
    setMapValue(
        ret,
        'newTopicPanel',
        codeIterable(model.newTopicPanel,
            (val) => _newTopicPanelSerializer.toMap(val as NewTopicPanel)));
    return ret;
  }

  @override
  Topic fromMap(Map map) {
    if (map == null) return null;
    final obj = Topic();
    obj.isHidden = map['isHidden'] as int;
    obj.isAnonymous = map['isAnonymous'] as int;
    obj.isOnlyAuthor = map['isOnlyAuthor'] as int;
    obj.allowPostAttachment = map['allowPostAttachment'] as int;
    obj.allowPostImage = map['allowPostImage'] as int;
    obj.classificationType_list = codeIterable<ClassificationType>(
        map['classificationType_list'] as Iterable,
        (val) => _classificationTypeSerializer.fromMap(val as Map));
    obj.isOnlyTopicType = map['isOnlyTopicType'] as int;
    obj.newTopicPanel = codeIterable<NewTopicPanel>(
        map['newTopicPanel'] as Iterable,
        (val) => _newTopicPanelSerializer.fromMap(val as Map));
    return obj;
  }
}

abstract class _$ClassificationTypeSerializer
    implements Serializer<ClassificationType> {
  @override
  Map<String, dynamic> toMap(ClassificationType model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'classificationType_id', model.classificationType_id);
    setMapValue(ret, 'classificationType_name', model.classificationType_name);
    return ret;
  }

  @override
  ClassificationType fromMap(Map map) {
    if (map == null) return null;
    final obj = ClassificationType();
    obj.classificationType_id = map['classificationType_id'] as int;
    obj.classificationType_name = map['classificationType_name'] as String;
    return obj;
  }
}

abstract class _$NewTopicPanelSerializer implements Serializer<NewTopicPanel> {
  @override
  Map<String, dynamic> toMap(NewTopicPanel model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'type', model.type);
    setMapValue(ret, 'title', model.title);
    return ret;
  }

  @override
  NewTopicPanel fromMap(Map map) {
    if (map == null) return null;
    final obj = NewTopicPanel();
    obj.type = map['type'] as String;
    obj.title = map['title'] as String;
    return obj;
  }
}
