import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qiqi_bike/update/update_service.dart';

class UpdateDialog extends StatefulWidget {
  ApplicationUpdateResponse updateResponse;

  UpdateDialog(this.updateResponse);

  @override
  _UpdateDialogState createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  num _downloadProgress = 0.0;

  /// 0 = 未下载;
  /// 1=正在下载;
  /// -1=下载失败;
  int _downloadStatus = 0;

  @override
  void initState() {
    super.initState();
    _downloadStatus = 0;
    _downloadProgress = 0.0;
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint("FlutterDownloader Cleanup All Resources !");
  }

  void _downloadCallback(count, total) {
    setState(() {
      _downloadProgress = count / total;
    });
  }

  CancelToken _cancelToken;

  void _startUpadte() async {
    if (_cancelToken != null) {
      _cancelToken.cancel();
      _cancelToken = null;
    }

    if (_downloadStatus != 0) {
      return;
    }
    setState(() {
      /// 设置为正在下载
      _downloadStatus = 1;
      _downloadProgress = 0.0;
    });

    try {
      var apkUrl =
          UpdaterService.instance.getApkDownloadUrl(widget.updateResponse);
      if (apkUrl == null) {
        return;
      }
      debugPrint("准备下载更新包: ${apkUrl} ...");

      Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.storage]);
      if (permissions[PermissionGroup.storage] != PermissionStatus.granted) {
        debugPrint("未获取到存储设备权限,无法更新 ...");
        return;
      }

      Directory tempDirectory = await getExternalStorageDirectory();
      var savePath = "${tempDirectory.path}/app-release.apk";
      var saveFile = File(savePath);
      if (await saveFile.exists()) {
        saveFile.deleteSync();
      }

      _cancelToken = CancelToken();

      final response = await UpdaterService.instance.downloadApplicationPackage(
          apkUrl, savePath,
          callback: _downloadCallback, cancelToken: _cancelToken);

      if (!response) {
        debugPrint("更新包下载失败 [ ${response} ] !");
        setState(() {
          _downloadStatus = -1;
        });
        return;
      }

      debugPrint("更新包下载成功 [ ${response} ] !");
      saveFile = File(savePath);
      var saveFileLength = await saveFile.length();
      if (saveFileLength != widget.updateResponse.apkFileSize) {
        debugPrint(
            "更新包校验失败 : 实际收到 ${saveFileLength}字节, 应为 ${widget.updateResponse.apkFileSize} 字节!");
      }

      if (_cancelToken.isCancelled) {
        debugPrint("已取消安装更新包,不执行安装操作 !");
        return;
      }

      _downloadStatus = 2;
      var result =
          await UpdaterService.instance.installApplicationPackage(savePath);

      debugPrint('installApplicationPackage => ${result}');
    } catch (e) {
      debugPrint('Failed to make OTA update. Details: $e');
      setState(() {
        _downloadStatus = -1;
      });
    }
  }

  void _cancelUpdate() {
    if (_cancelToken != null) {
      _cancelToken.cancel();
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var updateButton = FlatButton(child: Text("立即更新"), onPressed: _startUpadte);
    var skipButton = FlatButton(
        child: Text(
          "暂不更新",
          style: TextStyle(color: Theme.of(context).disabledColor),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        });
    var cancelButton = FlatButton(child: Text("取消"), onPressed: _cancelUpdate);

    var actionButtons = <Widget>[];
    if (_downloadStatus == 0) {
      if (!widget.updateResponse.isForceUpdate) actionButtons.add(skipButton);
      actionButtons.add(updateButton);
    } else {
      actionButtons.add(cancelButton);
    }

    return AlertDialog(
      title: _downloadStatus == 0
          ? Text("新版本${widget.updateResponse.versionName}可以用了")
          : Text("正在更新..."),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Offstage(
              offstage: _downloadStatus != 0, // 未开始下载时显示,其他情况下隐藏
              child: Text(widget.updateResponse.releaseMessage)),
          Offstage(
            offstage: _downloadStatus == 0, // 未开始下载时隐藏,其他情况下显示
            child: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: LinearProgressIndicator(value: _downloadProgress),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Text("下载进度 ${(_downloadProgress * 100).toInt()}%"),
                  )
                ],
              ),
            ),
          ),
          Offstage(
            offstage: _downloadStatus >= 0,
            child: Text(
              "应用更新出错了,请稍后再试!",
              style: TextStyle(color: Colors.red),
            ),
          )
        ],
      ),
      actions: actionButtons,
    );
  }
}
