/*
forumKey	itTovrNYj6jgmwUBcQ
apphash	40a143e0
accessToken	ac3f19b94085e3b86c228b54f71c7
json	{'page':1,'pageSize': 100}
sdkVersion	2.4.0
accessSecret	f01b3418e99ebdc5fda5fa3b8b9c2
*/

import 'package:jaguar_serializer/jaguar_serializer.dart';

import '../common.dart';

part 'message_pmsessionlist.jser.dart';

class MessagePmSessionListAction {
  static const String action = "message/pmsessionlist";

  static Map<String, dynamic> buildRequest({int page}) => {

  };

  static MessagePmSessionListResponse parseResponse(
      Map<String, dynamic> response) {
    return MessagePmSessionListResponseSerializer().fromMap(response);
  }
}

class MessagePmSessionListResponse extends MobcentResponse {
  ResponseBody body;

  int page;
  int has_next; // 0=无
  int total_num; // 回帖总数(含主题帖)
}

class ResponseBody {
  List<PmSession> list;
}

class PmSession {
  int pmid;
  int plid;
  int lastUserId;
  String lastUserName;
  String lastSummary;
  String lastDateline;

  DateTime get lastDatelineValue =>
      DateTime.fromMillisecondsSinceEpoch(int.tryParse(this.lastDateline));
  String toUserAvatar;
  int toUserId;
  String toUserName;
  int toUserIsBlack; // 0
}

@GenSerializer()
class MessagePmSessionListResponseSerializer
    extends Serializer<MessagePmSessionListResponse>
    with _$MessagePmSessionListResponseSerializer {}

@GenSerializer()
class ResponseBodySerializer extends Serializer<ResponseBody>
    with _$ResponseBodySerializer {}

@GenSerializer()
class PmSessionSerializer extends Serializer<PmSession>
    with _$PmSessionSerializer {}

const _samples = {
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
    "list": [
      {
        "pmid": 3066610,
        "plid": 1478292,
        "lastUserId": 92445,
        "lastUserName": "Bibby_10",
        "lastSummary": "\u8c22\u8c22\uff01",
        "lastDateline": "1557889429000",
        "toUserAvatar": "http:\/\/bbs.77bike.com\/images\/face\/none.gif",
        "toUserId": 92445,
        "toUserName": "Bibby_10",
        "toUserIsBlack": 0
      },
      {
        "pmid": 2899885,
        "plid": 1392250,
        "lastUserId": 129461,
        "lastUserName": "wc2hyy",
        "lastSummary": "\u4e0d\u8981\u5939\u5668\u591a\u5c11\u94b1\uff1f",
        "lastDateline": "1530156695000",
        "toUserAvatar": "http:\/\/bbs.77bike.com\/images\/face\/2.gif",
        "toUserId": 129461,
        "toUserName": "wc2hyy",
        "toUserIsBlack": 0
      },
      {
        "pmid": 2888747,
        "plid": 1386162,
        "lastUserId": 11897,
        "lastUserName": "Jasonzzz",
        "lastSummary":
            "\u597d\u7684\uff0c\u6211\u53bb\u627e\u627e\uff0c\u8c22\u8c22\u4f60\uff01",
        "lastDateline": "1528696712000",
        "toUserAvatar":
            "http:\/\/bbs.77bike.com\/attachment\/upload\/97\/11897.jpg",
        "toUserId": 11897,
        "toUserName": "Jasonzzz",
        "toUserIsBlack": 0
      },
      {
        "pmid": 2888059,
        "plid": 1386146,
        "lastUserId": 162603,
        "lastUserName": "xxgg1122",
        "lastSummary": "\u54ce\uff0c\u6765\u8fdf\u4e86\u554a",
        "lastDateline": "1528614225000",
        "toUserAvatar": "http:\/\/bbs.77bike.com\/images\/face\/7.jpg",
        "toUserId": 162603,
        "toUserName": "xxgg1122",
        "toUserIsBlack": 0
      },
      {
        "pmid": 2882316,
        "plid": 1383579,
        "lastUserId": 88251,
        "lastUserName": "uanotalone",
        "lastSummary": "\u54e6\u54e6\uff0c\u597d\u7684\uff0c\u563f\u563f",
        "lastDateline": "1527867808000",
        "toUserAvatar": "http:\/\/bbs.77bike.com\/images\/face\/none.gif",
        "toUserId": 88251,
        "toUserName": "uanotalone",
        "toUserIsBlack": 0
      },
      {
        "pmid": 2882253,
        "plid": 1383551,
        "lastUserId": 116756,
        "lastUserName": "caimumu",
        "lastSummary":
            "\u4f60\u597d\uff0c\u4f60\u662f\u6574\u4f53\u90fd\u8981\u7740\u5427\uff1f\u6211\u79f0\u4e86\u4e00\u4e0b\u7167\u7247\u4e0a\u90a3\u4e9b\u548c\u98de\u8f6e\u6574\u4f531.18kg\u4e86\uff0c\u4f30\u8ba1\u8fd0\u8d39\u5f9720\u591a\u4e86",
        "lastDateline": "1527859229000",
        "toUserAvatar":
            "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/74\/19374.jpg",
        "toUserId": 19374,
        "toUserName": "aishangyu",
        "toUserIsBlack": 0
      },
      {
        "pmid": 2878105,
        "plid": 1381435,
        "lastUserId": 116756,
        "lastUserName": "caimumu",
        "lastSummary":
            "\u63d0\u95ee\u89e3\u7b54\u533a\u88ab\u53d1\u5e7f\u544a\u7684\u5360\u9886\u4e86\uff0c\u8bf7\u7248\u4e3b\u5904\u7406\u4e00\u4e0b\u5427",
        "lastDateline": "1527427619000",
        "toUserAvatar":
            "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/29\/7029.jpg",
        "toUserId": 7029,
        "toUserName": "coolsear",
        "toUserIsBlack": 0
      },
      {
        "pmid": 2633080,
        "plid": 1259484,
        "lastUserId": 148380,
        "lastUserName": "\u72ec\u5b64\u904a\u4fa0",
        "lastSummary":
            "\u5728\u54b8\u9c7c\u4e0a\u641c\u201c5700\u4ec5\u76d8\u7247\u201d",
        "lastDateline": "1503507219000",
        "toUserAvatar":
            "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/80\/148380.jpg",
        "toUserId": 148380,
        "toUserName": "\u72ec\u5b64\u904a\u4fa0",
        "toUserIsBlack": 0
      },
      {
        "pmid": 2576464,
        "plid": 1231661,
        "lastUserId": 73321,
        "lastUserName": "aigis",
        "lastSummary": "\u8c22\u8c22\u4f60\uff0c\u8fd9\u4e0b\u6709\u5e95\u4e86",
        "lastDateline": "1499122050000",
        "toUserAvatar": "http:\/\/bbs.77bike.com\/images\/face\/none.gif",
        "toUserId": 73321,
        "toUserName": "aigis",
        "toUserIsBlack": 0
      },
      {
        "pmid": 2220889,
        "plid": 1057638,
        "lastUserId": 135522,
        "lastUserName": "vf25",
        "lastSummary": "\u51fa\u4e86",
        "lastDateline": "1476827387000",
        "toUserAvatar": "http:\/\/bbs.77bike.com\/images\/face\/none.gif",
        "toUserId": 135522,
        "toUserName": "vf25",
        "toUserIsBlack": 0
      },
      {
        "pmid": 1991575,
        "plid": 951684,
        "lastUserId": 52,
        "lastUserName": "\u5149\u5149",
        "lastSummary": "\u660e\u5929\u53d1",
        "lastDateline": "1467469501000",
        "toUserAvatar":
            "http:\/\/bbs.77bike.com\/attachment\/upload\/52\/52.jpg",
        "toUserId": 52,
        "toUserName": "\u5149\u5149",
        "toUserIsBlack": 0
      },
      {
        "pmid": 1664992,
        "plid": 799582,
        "lastUserId": 11733,
        "lastUserName": "wujunleave",
        "lastSummary":
            "\u4f60\u52a0\u6211QQ\uff0c\u6211\u4eecQQ\u804a 56861332",
        "lastDateline": "1452583692000",
        "toUserAvatar":
            "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/33\/11733.jpg",
        "toUserId": 11733,
        "toUserName": "wujunleave",
        "toUserIsBlack": 0
      }
    ]
  },
  "page": 1,
  "has_next": 0,
  "total_num": 19
};
