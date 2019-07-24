import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:package_info/package_info.dart';

part 'update_service.jser.dart';

@GenSerializer()
class ApplicationUpdateRequestSerializer
    extends Serializer<ApplicationUpdateRequest>
    with _$ApplicationUpdateRequestSerializer {}

@GenSerializer()
class ApplicationUpdateResponseSerializer
    extends Serializer<ApplicationUpdateResponse>
    with _$ApplicationUpdateResponseSerializer {}

class UpdaterService {
  static const baseUrl = "http://ota.waker.yuan.cn/update/";

  factory UpdaterService() => _getInstance();

  static UpdaterService get instance => _getInstance();
  static UpdaterService _instance;

  ApplicationUpdateRequestSerializer _requestSerializer =
      ApplicationUpdateRequestSerializer();
  ApplicationUpdateResponseSerializer _responseSerializer =
      ApplicationUpdateResponseSerializer();

  Dio _dio;

  static const _updateChannel =
      const MethodChannel("com.77bike.mobile/update");

  UpdaterService._internal() {
    _dio = new Dio(new BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: 10000,
      // 文件下载启用长超时时间
      receiveTimeout: 30000,
      headers: {
        HttpHeaders.userAgentHeader: "77Bike",
      },
      contentType: ContentType.json,
    ));
  }

  static UpdaterService _getInstance() {
    if (_instance == null) {
      _instance = UpdaterService._internal();
    }
    return _instance;
  }

  String getApkDownloadUrl(ApplicationUpdateResponse response) {
    return "http://ota.waker.yuan.cn${response.updateAddress}";
  }

  void _dioProgressCallback(int count, int total) {
    print("_dioProgressCallback => ${count} / ${total} ...");
  }

  Future<bool> downloadApplicationPackage(String apkUrl, String apkFile,
      {callback, cancelToken}) async {
    try {
      var response = await _dio.download(apkUrl, apkFile,
          onReceiveProgress: callback, cancelToken: cancelToken);
      if (response.statusCode == 200) {
        return Future.value(true);
      } else {
        return Future.value(false);
      }
    } catch (e) {
      print(e);
      return Future.value(false);
    }
  }

  Future<bool> installApplicationPackage(String apkFile) async {
    return await _updateChannel
        .invokeMethod("installApplicationPackage", {'apkFile': apkFile});
  }

  /// 检查是否有新版本可以下载
  Future<ApplicationUpdateResponse> checkUpdate() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var request = ApplicationUpdateRequest(
      packageName: packageInfo.packageName,
      devicePlatform: Platform.operatingSystem,
      versionName: packageInfo.version,
    );
    if (Platform.isAndroid) {
      request.versionCode = int.parse(packageInfo.buildNumber);
      request.deviceName = "Android";
    } else if (Platform.isIOS) {
      request.bundleVersion = packageInfo.buildNumber;
      request.deviceName = "iOS";
    }
    if (kReleaseMode)
      request.buildMode = "release";
    else
      request.buildMode = "debug";

    try {
      Response response =
          await _dio.post("check", data: _requestSerializer.toMap(request));

      return handleApplicationUpdateResponse(
          _responseSerializer.fromMap(response.data));
    } catch (error) {
      print(error);
    }
  }

  Future<ApplicationUpdateResponse> handleApplicationUpdateResponse(
      ApplicationUpdateResponse response) {
    print(_responseSerializer.toMap(response));
    return Future.value(response);
  }
}

class ApplicationUpdateRequest {
  /// <summary>
  /// 设备名称
  /// </summary>
  String deviceName;

  /// <summary>
  /// 设备平台类型(android, ios)
  /// </summary>
  String devicePlatform;

  /// <summary>
  /// 应用包名称
  /// </summary>
  String packageName;

  /// <summary>
  /// iOS应用版本号
  /// </summary>
  String bundleVersion;

  /// <summary>
  /// 版本号名称(iOS设备、Android设备都设置)
  /// </summary>
  String versionName;

  ///
  /// release Or debug
  String buildMode;

  /// <summary>
  /// Android设备版本编号
  /// </summary>
  int versionCode;

  ApplicationUpdateRequest(
      {this.deviceName,
      this.devicePlatform,
      this.packageName,
      this.bundleVersion,
      this.buildMode,
      this.versionName,
      this.versionCode});
}

class ApplicationUpdateResponse {
  /// <summary>
  /// 是否有更新包可用
  /// </summary>
  bool hasUpdate;

  /// <summary>
  /// 是否是需要强制更新包
  /// </summary>
  bool isForceUpdate;

  /// <summary>
  /// 待更新的版本号
  /// </summary>
  String versionName;

  /// <summary>
  /// 版本更新地址(Android版本为apk包地址,iOS版本为应用商店下载地址)
  /// </summary>
  String updateAddress;

  /// <summary>
  /// 版本发布说明
  /// </summary>
  String releaseMessage;

  /// <summary>
  /// 应用安装包的文件大小字节数
  /// </summary>
  int apkFileSize;

  /// <summary>
  /// 应用安装包的sha1哈希编码
  /// </summary>
  String apkSha1Hash;
}
