// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_initui.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$AppInitUIResponseSerializer
    implements Serializer<AppInitUIResponse> {
  Serializer<_ResponseBody> ___ResponseBodySerializer;
  Serializer<_ResponseBody> get __ResponseBodySerializer =>
      ___ResponseBodySerializer ??= _ResponseBodySerializer();
  Serializer<ResponseHead> __responseHeadSerializer;
  Serializer<ResponseHead> get _responseHeadSerializer =>
      __responseHeadSerializer ??= ResponseHeadSerializer();
  @override
  Map<String, dynamic> toMap(AppInitUIResponse model) {
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
  AppInitUIResponse fromMap(Map map) {
    if (map == null) return null;
    final obj = AppInitUIResponse();
    obj.body = __ResponseBodySerializer.fromMap(map['body'] as Map);
    obj.rs = map['rs'] as int;
    obj.errcode = passProcessor.deserialize(map['errcode']);
    obj.head = _responseHeadSerializer.fromMap(map['head'] as Map);
    return obj;
  }
}

abstract class _$_ResponseBodySerializer implements Serializer<_ResponseBody> {
  Serializer<Module> __moduleSerializer;
  Serializer<Module> get _moduleSerializer =>
      __moduleSerializer ??= ModuleSerializer();
  Serializer<Navigation> __navigationSerializer;
  Serializer<Navigation> get _navigationSerializer =>
      __navigationSerializer ??= NavigationSerializer();
  @override
  Map<String, dynamic> toMap(_ResponseBody model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(
        ret,
        'moduleList',
        codeIterable(
            model.moduleList, (val) => _moduleSerializer.toMap(val as Module)));
    setMapValue(
        ret, 'navigation', _navigationSerializer.toMap(model.navigation));
    return ret;
  }

  @override
  _ResponseBody fromMap(Map map) {
    if (map == null) return null;
    final obj = _ResponseBody();
    obj.moduleList = codeIterable<Module>(map['moduleList'] as Iterable,
        (val) => _moduleSerializer.fromMap(val as Map));
    obj.navigation = _navigationSerializer.fromMap(map['navigation'] as Map);
    return obj;
  }
}

abstract class _$ModuleSerializer implements Serializer<Module> {
  @override
  Map<String, dynamic> toMap(Module model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'id', model.id);
    setMapValue(ret, 'type', model.type);
    setMapValue(ret, 'style', model.style);
    setMapValue(ret, 'title', model.title);
    setMapValue(ret, 'icon', model.icon);
    return ret;
  }

  @override
  Module fromMap(Map map) {
    if (map == null) return null;
    final obj = Module();
    obj.id = map['id'] as int;
    obj.type = map['type'] as String;
    obj.style = map['style'] as String;
    obj.title = map['title'] as String;
    obj.icon = map['icon'] as String;
    return obj;
  }
}

abstract class _$NavigationSerializer implements Serializer<Navigation> {
  Serializer<NavItem> __navItemSerializer;
  Serializer<NavItem> get _navItemSerializer =>
      __navItemSerializer ??= NavItemSerializer();
  @override
  Map<String, dynamic> toMap(Navigation model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'type', model.type);
    setMapValue(
        ret,
        'navItemList',
        codeIterable(model.navItemList,
            (val) => _navItemSerializer.toMap(val as NavItem)));
    return ret;
  }

  @override
  Navigation fromMap(Map map) {
    if (map == null) return null;
    final obj = Navigation();
    obj.type = map['type'] as String;
    obj.navItemList = codeIterable<NavItem>(map['navItemList'] as Iterable,
        (val) => _navItemSerializer.fromMap(val as Map));
    return obj;
  }
}

abstract class _$NavItemSerializer implements Serializer<NavItem> {
  @override
  Map<String, dynamic> toMap(NavItem model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'moduleId', model.moduleId);
    setMapValue(ret, 'title', model.title);
    setMapValue(ret, 'icon', model.icon);
    return ret;
  }

  @override
  NavItem fromMap(Map map) {
    if (map == null) return null;
    final obj = NavItem();
    obj.moduleId = map['moduleId'] as int;
    obj.title = map['title'] as String;
    obj.icon = map['icon'] as String;
    return obj;
  }
}
