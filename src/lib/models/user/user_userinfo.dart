/*
accessSecret	f01b3418e99ebdc5fda5fa3b8b9c2
accessToken	ac3f19b94085e3b86c228b54f71c7
apphash	9425b1e8
forumKey	itTovrNYj6jgmwUBcQ
sdkVersion	2.4.0
userId	116756
*/

import 'package:jaguar_serializer/jaguar_serializer.dart';

import '../common.dart';

part 'user_userinfo.jser.dart';

class UserGetInfoAction {
  static const String action = "user/userinfo";

  static Map<String, dynamic> buildRequest(int userId) {
    return {"userId": userId};
  }

  static UserInfoResponse parseResponse(Map<String, dynamic> response) {
    return UserInfoResponseSerializer().fromMap(response);
  }
}

@GenSerializer(fields: {
  "score": const EnDecode(processor: const IntOrEmptyStringField()),
})
class UserInfoResponseSerializer extends Serializer<UserInfoResponse>
    with _$UserInfoResponseSerializer {}

@GenSerializer()
class _ResponseBodySerializer extends Serializer<_ResponseBody>
    with _$_ResponseBodySerializer {}


@GenSerializer()
class CreditItemSerializer extends Serializer<CreditItem>
    with _$CreditItemSerializer {}


@GenSerializer()
class ProfileItemSerializer extends Serializer<ProfileItem>
    with _$ProfileItemSerializer {}

class UserInfoResponse extends MobcentResponse {
  _ResponseBody body;

  /// 贡献值(数值有问题?)
  int credits;

  String email;

  int essence_num;

  ///
  int follow_num;

  int friend_num;

  /// 性别
  int gender;

  /// 金钱数量
  int gold_num;

  /// 头像
  String icon;

  /// 黑名单?小黑屋
  int is_black;

  /// 关注?
  int is_follow;

  /// 是否是好友
  int isFriend;

  num level;

  String name;

  int photo_num;

  int reply_posts_num;

  dynamic score;

  int status;

  int topic_num;

  String userTitle;

  UserInfoResponse({this.body, rs, errcode, head})
      : super(rs: rs, errcode: errcode, head: head);
}

class _ResponseBody {
  List<CreditItem> creditList;
  List<CreditItem> creditShowList;
  List<ProfileItem> profileList;
}

class CreditItem {
  dynamic type;
  String title;
  int data;
}

class ProfileItem {
  dynamic type;
  String title;
  String data;
}

/*
const _sample = {
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
    "repeatList": [],
    "profileList": [
      {"type": "oicq", "title": "QQ", "data": ""},
      {"type": "aliww", "title": "\u963f\u91cc\u65fa\u65fa", "data": ""},
      {"type": "yahoo", "title": "Yahoo", "data": ""},
      {"type": "msn", "title": "Msn", "data": ""},
      {"type": "gender", "title": "\u6027\u522b", "data": "\u7537\r"},
      {"type": "bday", "title": "\u751f\u65e5", "data": "0000-00-00"},
      {"type": "apartment", "title": "\u73b0\u5c45\u4f4f\u5730", "data": ""},
      {"type": "home", "title": "\u5bb6\u4e61", "data": ""},
      {"type": "career", "title": "\u5de5\u4f5c\u7ecf\u5386", "data": ""},
      {"type": "alipay", "title": "\u652f\u4ed8\u5b9d\u8d26\u53f7", "data": ""},
      {"type": "education", "title": "\u6559\u80b2\u7ecf\u5386", "data": ""},
      {"type": "honor", "title": "\u4e2a\u6027\u7b7e\u540d", "data": ""},
      {"type": "signature", "title": "\u5e16\u5b50\u7b7e\u540d", "data": ""},
      {"type": "introduce", "title": "\u81ea\u6211\u4ecb\u7ecd", "data": ""},
      {"type": "site", "title": "\u4e2a\u4eba\u4e3b\u9875", "data": ""}
    ],
    "creditList": [
      {"type": "rvrc", "title": "\u5a01\u671b", "data": 24},
      {"type": "money", "title": "\u91d1\u94b1", "data": 264},
      {"type": "credit", "title": "\u8d21\u732e\u503c", "data": 0},
      {"type": "currency", "title": "\u4ea4\u6613\u5e01", "data": 0},
      {"type": 5, "title": "\u7231\u5fc3\u503c", "data": 0}
    ],
    "creditShowList": [
      {"type": "rvrc", "title": "\u5a01\u671b", "data": 24},
      {"type": "money", "title": "\u91d1\u94b1", "data": 264}
    ]
  },
  "userTitle": "\u521d\u4e8c",
  "flag": 1,
  "is_black": 0,
  "is_follow": 0,
  "isFriend": 0,
  "name": "caimumu",
  "email": "chasnjj@163.com",
  "gender": 1,
  "gold_num": 264,
  "score": "",
  "credits": 264,
  "topic_num": 29,
  "reply_posts_num": 197,
  "essence_num": 0,
  "photo_num": 48,
  "follow_num": 2,
  "friend_num": 0,
  "status": 0,
  "level": 4.99,
  "icon": "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/56\/116756.jpg",
  "info": [
    {
      "type_id": 70,
      "sort_id": 0,
      "pic_path":
          "http:\/\/bbs.77bike.com\/attachment\/2_92322_cfc5d53c89f3446.jpg",
      "board_id": 2,
      "board_name": "\u6298\u53e0\u5c0f\u8f6e\u5f84",
      "topic_id": 120993,
      "title": "AEST\u949b\u8f74\u811a\u8e0f\u7ef4\u62a4",
      "content":
          "\u65b0\u4e0a\u7684AEST\u949b\u8f74\u811a\u8e0f\uff0c\u8e29\u4e862\u5468\u4e4b\u540e\uff0c\u603b\u611f\u89c9\u5de6\u811a\u8e29\u523010\u70b9\u65b9\u5411\u6709\u8f7b ..",
      "subject":
          "\u65b0\u4e0a\u7684AEST\u949b\u8f74\u811a\u8e0f\uff0c\u8e29\u4e862\u5468\u4e4b\u540e\uff0c\u603b\u611f\u89c9\u5de6\u811a\u8e29\u523010\u70b9\u65b9\u5411\u6709\u8f7b ..",
      "lastpost": "1424156869000",
      "last_reply_date": "1424156869000",
      "hits": 9585,
      "replies": 54,
      "user_id": 116756,
      "hot": 1,
      "essence": 0,
      "top": 0,
      "status": 0,
      "user_nick_name": "timonlio"
    },
    {
      "type_id": 70,
      "sort_id": 0,
      "pic_path":
          "http:\/\/bbs.77bike.com\/attachment\/Mon_1709\/2_161132_4427232212b3163.jpg",
      "board_id": 2,
      "board_name": "\u6298\u53e0\u5c0f\u8f6e\u5f84",
      "topic_id": 253107,
      "title": "\u6539\u53d8\u8272\u9f99\u6f06\u5b8c\u5de5\uff01",
      "content":
          "\u539f\u8f66\u4e5f\u9a91\u4e86\u4e09\u56db\u5343\u516c\u91cc\u4e86\uff0c\u4e70\u8f66\u67b6\u7684\u65f6\u5019\u89c9\u5f97\u989c\u8272\u4e0d\u9519\u540e\u6765\u8d8a\u770b\u8d8a\u571f ..",
      "subject":
          "\u539f\u8f66\u4e5f\u9a91\u4e86\u4e09\u56db\u5343\u516c\u91cc\u4e86\uff0c\u4e70\u8f66\u67b6\u7684\u65f6\u5019\u89c9\u5f97\u989c\u8272\u4e0d\u9519\u540e\u6765\u8d8a\u770b\u8d8a\u571f ..",
      "lastpost": "1514288491000",
      "last_reply_date": "1514288491000",
      "hits": 2617,
      "replies": 64,
      "user_id": 116756,
      "hot": 1,
      "essence": 0,
      "top": 0,
      "status": 0,
      "user_nick_name": "\u987e\u5bb6\u7684\u5c0f\u4e03"
    },
    {
      "type_id": 70,
      "sort_id": 0,
      "pic_path":
          "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/xgsize\/attachment\/2_3227_981da5f25db234b.jpg",
      "board_id": 2,
      "board_name": "\u6298\u53e0\u5c0f\u8f6e\u5f84",
      "topic_id": 5237,
      "title":
          "\u5728\u5bb6\u5229\u7528\u81ea\u55b7\u6f06\u55b7\u6d82\u81ea\u884c\u8f66\u90e8\u4ef6\u7684\u4e00\u4e9b\u8981\u7d20",
      "content":
          "\u8bb8\u591a\u9a91\u53cb\u90fd\u613f\u610f\u5c06\u81ea\u5df1\u7684\u8f66\u90e8\u4ef6\u901a\u8fc7\u5404\u79cd\u81ea\u55b7\u6f06\u7684\u65b9\u5f0f\u8fdb\u884c\u4fee\u8865\u6216\u8005 ..",
      "subject":
          "\u8bb8\u591a\u9a91\u53cb\u90fd\u613f\u610f\u5c06\u81ea\u5df1\u7684\u8f66\u90e8\u4ef6\u901a\u8fc7\u5404\u79cd\u81ea\u55b7\u6f06\u7684\u65b9\u5f0f\u8fdb\u884c\u4fee\u8865\u6216\u8005 ..",
      "lastpost": "1439787711000",
      "last_reply_date": "1439787711000",
      "hits": 23716,
      "replies": 64,
      "user_id": 116756,
      "hot": 1,
      "essence": 1,
      "top": 0,
      "status": 0,
      "user_nick_name": "\u6015\u5a03\u513f\u843d\u5730"
    },
    {
      "type_id": 19,
      "sort_id": 0,
      "pic_path":
          "http:\/\/bbs.77bike.com\/attachment\/Mon_1801\/12_153022_20508e5781e5563.jpg",
      "board_id": 12,
      "board_name": "\u4e2a\u4eba\u4ea4\u6613",
      "topic_id": 273416,
      "title": "Ultegra6800\u7259\u76d8165\u817f46-36\u9f7f",
      "content":
          "6800\u7259\u76d8\u5168\u65b0165\/46-36\u76d2\u88c5899\uff01\u5305\u90aevx   13925226808\u6765\u81ea[Andro ..",
      "subject":
          "6800\u7259\u76d8\u5168\u65b0165\/46-36\u76d2\u88c5899\uff01\u5305\u90aevx   13925226808\u6765\u81ea[Andro ..",
      "lastpost": "1516866667000",
      "last_reply_date": "1516866667000",
      "hits": 812,
      "replies": 22,
      "user_id": 116756,
      "hot": 1,
      "essence": 0,
      "top": 0,
      "status": 0,
      "user_nick_name": "\u7389\u7c736918"
    },
    {
      "type_id": 40,
      "sort_id": 0,
      "pic_path": "",
      "board_id": 31,
      "board_name": "\u516c\u8def\u5c71\u5730",
      "topic_id": 249423,
      "title":
          "\u4f60\u4eec\u8bf4\u5982\u679c\u4fdd\u63016800\u624b\u53d8\u4e0d\u52a8\uff0c\u76f4\u63a5\u4e70\u4e2aR8000\u540e\u62e8\uff0c\u80fd\u7528\u4e48?",
      "content":
          "\u5982\u9898\u5982\u9898\u5982\u9898\uff0c\u5728\u7ebf\u7b49\uff0c\u6025\u3002",
      "subject":
          "\u5982\u9898\u5982\u9898\u5982\u9898\uff0c\u5728\u7ebf\u7b49\uff0c\u6025\u3002",
      "lastpost": "1509515333000",
      "last_reply_date": "1509515333000",
      "hits": 4029,
      "replies": 32,
      "user_id": 116756,
      "hot": 1,
      "essence": 0,
      "top": 0,
      "status": 0,
      "user_nick_name": "asuka8110"
    }
  ]
};
*/
