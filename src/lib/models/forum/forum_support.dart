import 'package:flutter/foundation.dart';

/// 赞
/// type=topic 主题
/// type=post 回复
/// 参数列表(tid, $pid = 0, $type = 'topic', $action = 'support')
/// http://bbs.77bike.com/mobcent/app/web/index.php?r=forum/support&sdkVersion=2.4.0.1&accessToken=ac3f19b94085e3b86c228b54f71c7&accessSecret=f01b3418e99ebdc5fda5fa3b8b9c2&tid=302098&fid=2&act=dig&pid=&type=topic
/// http://bbs.77bike.com/mobcent/app/web/index.php?r=forum/support&sdkVersion=2.4.0.1&accessToken=ac3f19b94085e3b86c228b54f71c7&accessSecret=f01b3418e99ebdc5fda5fa3b8b9c2&tid=302098&fid=2&act=dig&pid=&type=topic
///
import '../common.dart';

class ForumSupportAction {
  static const String action = "forum/support";

  static Map<String, dynamic> buildRequest({@required int tid,
    int pid = 0,
    String type = 'topic',
    String action = 'support'}) {
    return {
      "tid": tid,
      "pid": pid,
      "type": type,
      "action": action
    };
  }

  static MobcentResponse parseResponse(Map<String, dynamic> response) {
    return MobcentResponseSerializer().fromMap(response);
  }
}

/*
var _response = {
  "rs": 1,
  "errcode": "\u611f\u8c22\u60a8\u5bf9\u8be5\u5e16\u7684\u8ba4\u540c\uff0c\u5e16\u5b50\u63a8\u8350\u6210\u529f\uff01",
  "head": {
    "errCode": "080000002",
    "errInfo": "\u611f\u8c22\u60a8\u5bf9\u8be5\u5e16\u7684\u8ba4\u540c\uff0c\u5e16\u5b50\u63a8\u8350\u6210\u529f\uff01",
    "version": "2.4.0.1",
    "alert": 1
  },
  "body": {"externInfo": null}
}
*/
