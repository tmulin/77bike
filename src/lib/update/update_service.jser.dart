// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_service.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$ApplicationUpdateRequestSerializer
    implements Serializer<ApplicationUpdateRequest> {
  @override
  Map<String, dynamic> toMap(ApplicationUpdateRequest model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'deviceName', model.deviceName);
    setMapValue(ret, 'devicePlatform', model.devicePlatform);
    setMapValue(ret, 'packageName', model.packageName);
    setMapValue(ret, 'bundleVersion', model.bundleVersion);
    setMapValue(ret, 'versionName', model.versionName);
    setMapValue(ret, 'buildMode', model.buildMode);
    setMapValue(ret, 'versionCode', model.versionCode);
    return ret;
  }

  @override
  ApplicationUpdateRequest fromMap(Map map) {
    if (map == null) return null;
    final obj = ApplicationUpdateRequest();
    obj.deviceName = map['deviceName'] as String;
    obj.devicePlatform = map['devicePlatform'] as String;
    obj.packageName = map['packageName'] as String;
    obj.bundleVersion = map['bundleVersion'] as String;
    obj.versionName = map['versionName'] as String;
    obj.buildMode = map['buildMode'] as String;
    obj.versionCode = map['versionCode'] as int;
    return obj;
  }
}

abstract class _$ApplicationUpdateResponseSerializer
    implements Serializer<ApplicationUpdateResponse> {
  @override
  Map<String, dynamic> toMap(ApplicationUpdateResponse model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'hasUpdate', model.hasUpdate);
    setMapValue(ret, 'isForceUpdate', model.isForceUpdate);
    setMapValue(ret, 'versionName', model.versionName);
    setMapValue(ret, 'updateAddress', model.updateAddress);
    setMapValue(ret, 'releaseMessage', model.releaseMessage);
    setMapValue(ret, 'apkFileSize', model.apkFileSize);
    setMapValue(ret, 'apkSha1Hash', model.apkSha1Hash);
    return ret;
  }

  @override
  ApplicationUpdateResponse fromMap(Map map) {
    if (map == null) return null;
    final obj = ApplicationUpdateResponse();
    obj.hasUpdate = map['hasUpdate'] as bool;
    obj.isForceUpdate = map['isForceUpdate'] as bool;
    obj.versionName = map['versionName'] as String;
    obj.updateAddress = map['updateAddress'] as String;
    obj.releaseMessage = map['releaseMessage'] as String;
    obj.apkFileSize = map['apkFileSize'] as int;
    obj.apkSha1Hash = map['apkSha1Hash'] as String;
    return obj;
  }
}
