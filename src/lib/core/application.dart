import 'dart:convert';

import 'package:qiqi_bike/core/session.dart';
import 'package:qiqi_bike/core/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'forum.dart';

class ApplicationCore {
  static ForumModel _forum;

  static ForumModel get forum => _forum;

  static Session _session;

  static Session get session => _session;

  static Settings _settings;

  static Settings get settings => _settings;

  static SharedPreferences _sharedPreferences;

  static Future<bool> initialize({bool mock = false}) async {
    _sharedPreferences = mock ? null : await SharedPreferences.getInstance();

    var forumSnapshot =
        mock ? null : _sharedPreferences.getString("forumSnapshot");
    if (forumSnapshot == null) {
      _forum = ForumModel();
    } else {
      print(forumSnapshot);
      _forum = ForumModel.fromJson(json.decode(forumSnapshot));
    }
    _forum.addListener(() => forumListener(_forum));

    var sessionSnapshot =
        mock ? null : _sharedPreferences.getString("sessionSnapshot");
    if (sessionSnapshot == null) {
      _session = Session();
    } else {
      _session = Session.fromJson(json.decode(sessionSnapshot));
    }

    _session.addListener(() => sessionListener(_session));

    var settingsSnapshot =
        mock ? null : _sharedPreferences.getString("settingsSnapshot");
    if (settingsSnapshot == null) {
      _settings = Settings();
    } else {
      _settings = Settings.fromJson(json.decode(settingsSnapshot));
    }

    _settings.addListener(() => settingsListener(_settings));
    return true;
  }

  static Future<bool> userLogout() async {
    /// 清除已经保存的登录session数据
    _session.clear();
  }

  static Future<void> forumListener(ForumModel forum) async {
    print("Application::forumListener ++");
    var forumSnapshot = jsonEncode(forum.toJson());
    print("Application::forumListener => ${forumSnapshot}");
    await _sharedPreferences?.setString("forumSnapshot", forumSnapshot);
    print("Application::forumListener --");
  }

  static Future<void> sessionListener(Session session) async {
    print("Application::sessionListener ++");
    var sessionSnapshot = jsonEncode(session.toJson());
    print("Application::sessionListener => ${sessionSnapshot}");
    await _sharedPreferences?.setString("sessionSnapshot", sessionSnapshot);
    print("Application::sessionListener --");
  }

  static Future<void> settingsListener(Settings settings) async {
    print("Application::settingsListener ++");
    var settingsSnapshot = jsonEncode(settings.toJson());
    print("Application::settingsListener => ${settingsSnapshot}");
    await _sharedPreferences?.setString("settingsSnapshot", settingsSnapshot);
    print("Application::settingsListener --");
  }

  static Map<String, dynamic> buildCommonParameters() {
    return {
      "accessSecret": _session.secret,
      "accessToken": _session.token,
      "apphash": _getAppHash(),
      "forumKey": _getForumKey(),
      "sdkVersion": _getSdkVersion(),
    };
  }

  /// 构建http get协议请求url
  static String buildActionUrl(String action,
      {Map<String, String> extParameters}) {
    return Uri.http("bbs.77bike.com", "/mobcent/app/web/index.php", {
      "r": action,
      "accessSecret": _session.secret,
      "accessToken": _session.token,
      "sdkVersion": _getSdkVersion(),
      "apphash": _getAppHash(),
      "forumKey": _getForumKey(),
      ...?extParameters
    }).toString();
  }

  static String _getAppHash() => "cc590023"; // "9425b1e8";

  static String _getForumKey() => "itTovrNYj6jgmwUBcQ";

  static String _getSdkVersion() => "2.4.0";

  static String imageTranslate(String rawUrl,
      {bool cloudProcess = false, String processor}) {
    Uri uri = Uri.parse(rawUrl);
    String host = uri.host;
    String path = uri.path;
    if (cloudProcess) {
      host = "77.yuan.cn";
      if (path.startsWith("/bbs/attachment"))
        path = path.replaceFirst("/bbs/attachment", "/attachment", 0);
      if (processor != null) path = "${path}${processor}";
    }

    return Uri(scheme: uri.scheme, host: host, port: uri.port, path: path)
        .toString();
  }
}
