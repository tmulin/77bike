import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:qiqi_bike/widgets/cache_manager.dart';

class CacheStatusPage extends StatefulWidget {
  @override
  _CacheStatusPageState createState() => _CacheStatusPageState();
}

class _CacheStatusPageState extends State<CacheStatusPage> {
  int fileCount = 0;
  int fileSize = 0;
  List<StreamSubscription<FileSystemEntity>> subscriptions = List(2);

  Future<void> calcCacheSpace() async {
    setState(() {
      fileCount = 0;
      fileSize = 0;
    });
    if (subscriptions[0] == null) {
      subscriptions[0] = Directory(await DefaultCacheManager().getFilePath())
          .list(recursive: true, followLinks: false)
          .listen(onData(0), onDone: onDone(0), cancelOnError: true);
    }
    if (subscriptions[1] == null) {
      subscriptions[1] = Directory(await CustomCacheManager().getFilePath())
          .list(recursive: true, followLinks: false)
          .listen(onData(1), onDone: onDone(1), cancelOnError: true);
    }
  }

  Function(FileSystemEntity data) onData(int index) {
    void func(FileSystemEntity fileInfo) {
      fileCount++;
      fileSize += fileInfo.statSync().size;
      print("${index} | ${fileCount} : ${fileSize} => ${fileInfo.path}");

      setState(() {});
    }

    return func;
  }

  Function onDone(int index) {
    void func() {
      subscriptions[index] = null;
      print("${index} => LIST FINISHED!");
    }

    return func;
  }

  Future<void> clearCacheSpace() async {
    await CustomCacheManager().emptyCache();
    await DefaultCacheManager().emptyCache();
    await Directory(await DefaultCacheManager().getFilePath())
        .listSync(recursive: true)
        .forEach((fileInfo) {
      try {
        fileInfo.deleteSync();
      } catch (exp) {}
    });
    await Directory(await CustomCacheManager().getFilePath())
        .listSync(recursive: true)
        .forEach((fileInfo) {
      try {
        fileInfo.deleteSync();
      } catch (exp) {}
    });
  }

  @override
  void initState() {
    super.initState();

    calcCacheSpace();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("临时文件")),
      body: Builder(builder: (context) => _buildPageBody(context)),
      backgroundColor: Color(0xfff8f8f8),
    );
  }

  _buildPageBody(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          color: Colors.white,
          child: ListTile(
            title: Text("临时文件"),
            trailing: Text(
                "共 ${fileCount} 个, ${(fileSize / 1024.0 / 1024.0).toStringAsFixed(2)}M 字节"),
          ),
        ),
        Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: 32),
          child: CupertinoButton(
              child: Text("立即清理", style: TextStyle(color: Colors.red)),
              onPressed: () async {
                await clearCacheSpace();
                await calcCacheSpace();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                    "清理完成!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 16),
                  ),
                  backgroundColor: Colors.white,
                  behavior: SnackBarBehavior.floating,
                ));
              }),
        )
      ],
    );
  }
}
