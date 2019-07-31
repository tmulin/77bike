import 'dart:convert';

import 'package:jaguar_serializer/jaguar_serializer.dart';

import '../common.dart';

part 'message_pmsession.jser.dart';

class MessagePmSessionAction {
  static const String action = "message/pmlist";

  static Map<String, dynamic> buildRequest({int uid, int pmid, int plid}) {
    final bodyData = {
      "body": {
        "pmInfos": [
          {
            "cacheCount": 0,
            "fromUid": "$uid",
            if (pmid != null) "pmid": pmid,
            if (plid != null) "plid": plid,
            "stopTime": 0
          }
        ]
      }
    };
    final bodyJson = json.encode(bodyData);

    return {"pmlist": bodyJson};
  }

  static MessagePmSessionResponse parseResponse(Map<String, dynamic> response) {
    return MessagePmSessionResponseSerializer().fromMap(response);
  }
}

class MessagePmSessionResponse extends MobcentResponse {
  ResponseBody body;
}

class ResponseBody {
  List<PmSession> pmList;

  PmUserInfo userInfo;
}

class PmSession {
  int fromUid;
  String name;
  String avatar;
  int plid;
  int hasPrev;
  List<PmMessage> msgList = [];
}

class PmMessage {
  int sender;
  int mid;
  String type; // text
  String content;
  String time; // time in string
}

class PmUserInfo {
  int uid;
  String name;
  String avatar;
}

@GenSerializer()
class MessagePmSessionResponseSerializer
    extends Serializer<MessagePmSessionResponse>
    with _$MessagePmSessionResponseSerializer {}

@GenSerializer()
class ResponseBodySerializer extends Serializer<ResponseBody>
    with _$ResponseBodySerializer {}

@GenSerializer()
class PmSessionSerializer extends Serializer<PmSession>
    with _$PmSessionSerializer {}

@GenSerializer()
class PmMessageSerializer extends Serializer<PmMessage>
    with _$PmMessageSerializer {}

@GenSerializer()
class PmUserInfoSerializer extends Serializer<PmUserInfo>
    with _$PmUserInfoSerializer {}

var response = {
  "rs": 1,
  "errcode": "",
  "head": {
    "errCode": "",
    "errInfo": "\u8c03\u7528\u6210\u529f,\u6ca1\u6709\u4efb\u4f55\u9519\u8bef",
    "version": "2.4.0.1",
    "alert": 0
  },
  "body": {
    "externInfo": null,
    "userInfo": {
      "uid": 116756,
      "name": "caimumu",
      "avatar":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/56\/116756.jpg"
    },
    "pmList": [
      {
        "fromUid": 1,
        "name": "azuretears",
        "avatar":
            "http:\/\/www.77bike.com\/bbs\/attachment\/upload\/1.gif?1402372791?1402382899?1411873017?1411873063?1466395681?1466396156?1473136039",
        "plid": 1492158,
        "hasPrev": 0,
        "msgList": [
          {
            "sender": 1,
            "mid": 3093185,
            "type": "text",
            "content":
                "[\u5173\u4e8e77app]: \u60a8\u597d\uff0c\u975e\u5e38\u611f\u8c22\u60a8\u8017\u8d39\u4e2a\u4eba\u5b9d\u8d35\u65f6\u95f4\u4e3a77\u8f66\u53cb\u5f00\u53d1APP\uff01\n\u6211\u4e0d\u61c2\u7f16\u7a0b\u6280\u672f\uff0c\u5f00\u53d1\u5de5\u4f5c\u53ef\u80fd\u5e2e\u4e0d\u4e0a\u4ec0\u4e48\u5fd9\uff0c\u4e0d\u8fc7\u5982\u679c\u5728\u670d\u52a1\u5668\u8d44\u6e90\u6216\u8d44\u91d1\u65b9\u9762\u6709\u9700\u8981\u652f\u6301\u7684\u5730\u65b9\uff0c\u8bf7\u4e00\u5b9a\u544a\u8bc9\u6211\uff0c\u518d\u6b21\u611f\u8c22\uff01",
            "time": "1564450512000"
          },
          {
            "sender": 116756,
            "mid": 3093317,
            "type": "text",
            "content":
                "\u60a8\u597d\u6821\u957f\uff0c\u76ee\u524dapp\u8fd8\u5728\u5b8c\u5584\u4e2d\uff0c\u540e\u7eedAndroid\u7248\u672c\u7684\u53d1\u5e03\u548c\u66f4\u65b0\uff0c\u5e0c\u671b\u662f\u53ef\u4ee5\u76f4\u63a5\u653e\u5230\u8bba\u575b\u8fd9\u8fb9\u6765\u6258\u7ba1\uff0c\u5f53\u4e0b\u6211\u4f7f\u7528\u4e86\u4e00\u4e9b\u516c\u53f8\u7684\u8d44\u6e90\uff0c\u957f\u4e45\u4e0b\u53bb\u4e0d\u592a\u597d\u3002\u540c\u65f6iOS\u7248\u672c\u76f8\u5bf9\u9ebb\u70e6\u4e9b\uff0c\u76ee\u524d\u662f\u4f7f\u7528\u7684\u6211\u516c\u53f8\u7684\u5f00\u53d1\u8005\u8d26\u53f7\u6765\u53d1\u5e03\u7684\u6d4b\u8bd5\u7248\uff0c\u4f46\u8fd9\u4e2a\u60c5\u51b5\u4e0b\uff0c\u4e0d\u9002\u5408\u6b63\u5f0f\u4e0a\u67b6\uff0c\u56e0\u4e3a\u6b63\u5f0f\u4e0a\u67b6\u4e4b\u540e\uff0c\u4f1a\u5728\u516c\u53f8\u540d\u4e0b\u770b\u5230\u540c\u4e00\u4e2a\u5f00\u53d1\u8005\u7684\u5176\u4ed6app\uff0c\u6240\u4ee5\u8fd9\u4e2a\u662f\u5e0c\u671b\u8bba\u575b\u65b9\u9762\u80fd\u7533\u8bf7\u4e00\u4e2a\u82f9\u679c\u7684\u5f00\u53d1\u8005\u8d26\u53f7\uff0c\u4ee5\u4fbf\u4ee5\u540e\u7528\u4f5c\u53d1\u5e03iOS\u7248app\u4f7f\u7528\u3002\u8981\u662f\u80fd\u627e\u5230\u5176\u4ed6\u670b\u53cb\u80fd\u76f4\u63a5\u63d0\u4f9b\u4e2a\u8d26\u53f7\u7528\u6765\u505a\u53d1\u5e03\u4e5f\u6ca1\u7528\u95ee\u9898\u7684\u3002\u8fd9\u4e9b\u95ee\u9898\u53ef\u4ee5\u6162\u6162\u89e3\u51b3\uff0c\u5f53\u524d\u7528\u6237\u6570\u8fd8\u6ca1\u6709\u90a3\u4e48\u591a\uff0c\u5148\u901a\u8fc7\u82f9\u679c\u7684testflight\u6d4b\u8bd5\u5e73\u53f0\u4f7f\u7528\u6d4b\u8bd5\u7248\u8fc7\u6e21\u4e5f\u6ca1\u6709\u95ee\u9898\u3002",
            "time": "1564456682000"
          }
        ]
      }
    ]
  }
};
