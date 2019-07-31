import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_user_agent/flutter_user_agent.dart';
import 'package:qiqi_bike/localizations.dart';
import 'package:qiqi_bike/storage/forum_cache_manager.dart';
import 'package:qiqi_bike/views/master_page.dart';

import 'api/mobcent_client.dart';
import 'core/application.dart';
import 'core/forum.dart';

void main() async {
  /// 初始化本地缓存数据库
  await ForumCacheManager.instance.initialize();

  /// 应用数据初始化
  await ApplicationCore.initialize();

  try {
    await FlutterUserAgent.init();
    if (FlutterUserAgent.webViewUserAgent != null) {
      MobcentClient.userAgent = FlutterUserAgent.webViewUserAgent;
    }
  } catch (exp) {}

  MobcentClient.instance.appInitUI().then((response) {});
  MobcentClient.instance.userGetSetting().then((response) {
    if (response.noError) {
      final boardClasses = response.body.postInfo.map((item) {
        final classes = item.topic.classificationType_list
            .map((cls) => Classification(
                id: cls.classificationType_id,
                name: cls.classificationType_name))
            .toList();
        return BoardClassification(id: item.fid, classes: classes);
      }).toList();
      ApplicationCore.forum.update(classes: boardClasses);
    }
  });

  MobcentClient.instance.forumList().then((response) {
    if (response.noError) {
      ApplicationCore.forum.update(categories: response.list);
    }
  });

  MobcentClient.instance.userLogin().then((loginResponse) {
    if (loginResponse.noError) {
      ApplicationCore.session.update(
          uid: loginResponse.uid,
          token: loginResponse.token,
          userName: loginResponse.userName,
          secret: loginResponse.secret,
          avatar: loginResponse.avatar);
    } else {
      print("userLogin FAILED => ${loginResponse.head.errInfo}");
    }
  });

  ApplicationCore.checkMessages();

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        ChineseCupertinoLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        const FallbackCupertinoLocalisationsDelegate(),
      ],
      supportedLocales: [
        const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans')
      ],
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MasterPage(),
    );
  }
}
