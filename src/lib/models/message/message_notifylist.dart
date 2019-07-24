/*
pageSize	20
type	post
sdkVersion	2.4.0
apphash	40a143e0
accessToken	ac3f19b94085e3b86c228b54f71c7
page	1
accessSecret	f01b3418e99ebdc5fda5fa3b8b9c2
forumKey	itTovrNYj6jgmwUBcQ
*/

import 'package:jaguar_serializer/jaguar_serializer.dart';

import '../common.dart';

part 'message_notifylist.jser.dart';

class MessageNotifyListAction {
  static const String action = "message/notifylist";

  static Map<String, dynamic> buildRequest(
          {int page = 1, int pageSize = 20, String type = "post"}) =>
      {"page": page, "pageSize": pageSize, "type": type};

  static MessageNotifyListResponse parseResponse(
      Map<String, dynamic> response) {
    return MessageNotifyListResponseSerializer().fromMap(response);
  }
}

class MessageNotifyListResponse extends MobcentResponse {
  int has_next; // 0=无
  List<Notify> list;
}

class Notify {
  int topic_id;
  int board_id;
  String board_name;
  String topic_content;
  String topic_url;
  String topic_subject;
  String reply_content;
  String reply_url;
  int is_read; // 1 or 0
  int reply_remind_id;
  String reply_nick_name;
  int user_id;
  String replied_date;
  String icon;

  DateTime get replied_date_value =>
      DateTime.fromMillisecondsSinceEpoch(int.tryParse(this.replied_date));
}

@GenSerializer()
class MessageNotifyListResponseSerializer
    extends Serializer<MessageNotifyListResponse>
    with _$MessageNotifyListResponseSerializer {}

@GenSerializer()
class NotifySerializer extends Serializer<Notify> with _$NotifySerializer {}

const _samples = {
  "rs": 1,
  "errcode": "",
  "head": {
    "errCode": "",
    "errInfo": "\u8c03\u7528\u6210\u529f,\u6ca1\u6709\u4efb\u4f55\u9519\u8bef",
    "version": "2.4.0.1",
    "alert": 0
  },
  "body": {"externInfo": null},
  "list": [
    {
      "topic_id": 302128,
      "board_id": 23,
      "board_name": "\u7ad9\u52a1\u516c\u544a",
      "topic_content":
          "caimumu:\u8bba\u575b\u5ba2\u6237\u7aef\u7528\u7684\u662fmobcent api\u63a5\u53e3\uff0c\u8d44\u6599\u5f88\u5c11\uff0c\u4e0d\u8fc7\u8fd8\u662f ..",
      "topic_url": "",
      "topic_subject":
          "\u6b63\u5728\u505a\u4e00\u4e2a\u8bba\u575b\u7684\u624b\u673a\u5ba2\u6237\u7aef",
      "reply_content":
          "\n\u5b64\u964b\u5be1\u95fb\u4e86\u8fd9\u662f\u7b2c\u4e09\u65b9\u8bba\u575b\u63d2\u4ef6\u4e48\uff1f\n",
      "reply_url": "",
      "is_read": 1,
      "reply_remind_id": 4962076,
      "reply_nick_name": "\u591a\u9a91\u5c11\u6539",
      "user_id": 152579,
      "replied_date": "1563147418000",
      "icon":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/79\/152579.jpg"
    },
    {
      "topic_id": 300403,
      "board_id": 12,
      "board_name": "\u4e2a\u4eba\u4ea4\u6613",
      "topic_content":
          "\u8bd5\u6536\u4e00\u4e2a4600 12-30T\u768410\u901f\u98de\u8f6e,\u5168\u65b0\u4e8c\u624b\u4e0d\u9650,\u6709\u95f2\u7f6e\u4e0d\u7528\u7684\u670b\u53cb ..",
      "topic_url": "",
      "topic_subject":
          "\u3010\u5df2\u6536\u5230\u3011\u8bd5\u6536\u4e00\u4e2a4600 12-30T\u768410\u901f\u98de\u8f6e,\u5168\u65b0\u4e8c\u624b\u4e0d\u9650",
      "reply_content":
          "\u6211\u6709\u4e00\u4e2a 500\u591a\u516c\u91cc\u5427 \u54b8\u9c7c \u641c4600\u98de\u8f6e12-30t\u627e\u5230",
      "reply_url": "",
      "is_read": 1,
      "reply_remind_id": 4937490,
      "reply_nick_name": "\u53e3\u572d\u53e3\u4e2b",
      "user_id": 155017,
      "replied_date": "1557831873000",
      "icon": "http:\/\/bbs.77bike.com\/images\/face\/none.gif"
    },
    {
      "topic_id": 300403,
      "board_id": 12,
      "board_name": "\u4e2a\u4eba\u4ea4\u6613",
      "topic_content":
          "\u8bd5\u6536\u4e00\u4e2a4600 12-30T\u768410\u901f\u98de\u8f6e,\u5168\u65b0\u4e8c\u624b\u4e0d\u9650,\u6709\u95f2\u7f6e\u4e0d\u7528\u7684\u670b\u53cb ..",
      "topic_url": "",
      "topic_subject":
          "\u3010\u5df2\u6536\u5230\u3011\u8bd5\u6536\u4e00\u4e2a4600 12-30T\u768410\u901f\u98de\u8f6e,\u5168\u65b0\u4e8c\u624b\u4e0d\u9650",
      "reply_content":
          "\u77ed\u817f\u540e\u62e8 32T\u5e94\u8be5\u4e5f\u652f\u6301\u5427",
      "reply_url": "",
      "is_read": 1,
      "reply_remind_id": 4937437,
      "reply_nick_name": "duzouxindi",
      "user_id": 158009,
      "replied_date": "1557825878000",
      "icon":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/09\/158009.png"
    },
    {
      "topic_id": 300403,
      "board_id": 12,
      "board_name": "\u4e2a\u4eba\u4ea4\u6613",
      "topic_content":
          "caimumu:\u662f\u554a\uff0c\u524d\u9635\u5b50\u4f60\u51fa\u4e86\u4e00\u4e2a6700\u7684\uff0c\u53ef\u60dc\u9519\u8fc7\u4e86\u54c8 (2019-05- ..",
      "topic_url": "",
      "topic_subject":
          "\u3010\u5df2\u6536\u5230\u3011\u8bd5\u6536\u4e00\u4e2a4600 12-30T\u768410\u901f\u98de\u8f6e,\u5168\u65b0\u4e8c\u624b\u4e0d\u9650",
      "reply_content": "\n\u83dc\u817f\u597d\u5e2e\u624b\n",
      "reply_url": "",
      "is_read": 1,
      "reply_remind_id": 4937366,
      "reply_nick_name": "kinayuhu",
      "user_id": 139576,
      "replied_date": "1557819507000",
      "icon":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/76\/139576.jpg"
    },
    {
      "topic_id": 300403,
      "board_id": 12,
      "board_name": "\u4e2a\u4eba\u4ea4\u6613",
      "topic_content":
          "\u8bd5\u6536\u4e00\u4e2a4600 12-30T\u768410\u901f\u98de\u8f6e,\u5168\u65b0\u4e8c\u624b\u4e0d\u9650,\u6709\u95f2\u7f6e\u4e0d\u7528\u7684\u670b\u53cb ..",
      "topic_url": "",
      "topic_subject":
          "\u3010\u5df2\u6536\u5230\u3011\u8bd5\u6536\u4e00\u4e2a4600 12-30T\u768410\u901f\u98de\u8f6e,\u5168\u65b0\u4e8c\u624b\u4e0d\u9650",
      "reply_content":
          "\u5728\u75282\u4e2a\uff0c\u4e0d\u8fc7\u90fd\u7ed9\u8f6e\u7ec4\u9738\u5360\u4e86\uff0c\u6ca1\u5269\u7684  ",
      "reply_url": "",
      "is_read": 1,
      "reply_remind_id": 4937266,
      "reply_nick_name": "leica",
      "user_id": 125521,
      "replied_date": "1557807599000",
      "icon":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/21\/125521.jpg"
    },
    {
      "topic_id": 300403,
      "board_id": 12,
      "board_name": "\u4e2a\u4eba\u4ea4\u6613",
      "topic_content":
          "\u8bd5\u6536\u4e00\u4e2a4600 12-30T\u768410\u901f\u98de\u8f6e,\u5168\u65b0\u4e8c\u624b\u4e0d\u9650,\u6709\u95f2\u7f6e\u4e0d\u7528\u7684\u670b\u53cb ..",
      "topic_url": "",
      "topic_subject":
          "\u3010\u5df2\u6536\u5230\u3011\u8bd5\u6536\u4e00\u4e2a4600 12-30T\u768410\u901f\u98de\u8f6e,\u5168\u65b0\u4e8c\u624b\u4e0d\u9650",
      "reply_content":
          "\u8fd9\u4f30\u8ba1\u5f88\u7a00\u5c11\u5427  ut6700\u4e5f\u6709\u8fd9\u89c4\u683c\n",
      "reply_url": "",
      "is_read": 1,
      "reply_remind_id": 4937178,
      "reply_nick_name": "kinayuhu",
      "user_id": 139576,
      "replied_date": "1557802058000",
      "icon":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/76\/139576.jpg"
    },
    {
      "topic_id": 280928,
      "board_id": 31,
      "board_name": "\u516c\u8def\u5c71\u5730",
      "topic_content":
          "caimumu:\u8fd8\u6709\u8fd9\u8bf4\u6cd5\u554a\uff1f\u6211\u662f\u76f4\u63a5\u7f20\u4e86\u51e0\u5708\u7f8e\u7eb9\u7eb8\uff0c\u65e2\u6d88\u5f02\u54cd\uff0c\u53c8\u80fd ..",
      "topic_url": "",
      "topic_subject":
          "\u6377\u5b89\u7279\u5ea7\u7ba1\uff0c\u6c34\u6ef4\u5750\u7ba1\uff0cTCR\u5ea7\u7ba1\uff0c\u78b3\u5ea7\u7ba1\u5f02\u54cd\u8fdb",
      "reply_content":
          "\n\u817f\u957f\u7684\u6ca1\u4e8b\uff0c\u817f\u77ed\u7684\u67b6\u5b50\u4e2d\u7ba1\u53d8\u5f84\u7684\u5730\u65b9\u6709\u70b9\u5e72\u6d89\uff0c\u6240\u4ee5\u8981\u952f\u6389\n",
      "reply_url": "",
      "is_read": 1,
      "reply_remind_id": 4734118,
      "reply_nick_name": "\u6c34\u4e2d\u6cb3\u87f9",
      "user_id": 19806,
      "replied_date": "1528761441000",
      "icon":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/06\/19806.jpg"
    },
    {
      "topic_id": 280865,
      "board_id": 15,
      "board_name": "\u751f\u6d3b\u95f2\u804a",
      "topic_content":
          "caimumu:\u606d\u559c\u606d\u559c \u548cLD\u6234\u4e86\u597d\u51e0\u5e74601\u548c205\u4e86\n (2018-06-11 07:19 ..",
      "topic_url": "",
      "topic_subject":
          "\u6512\u5c0f\u5e03\u7684\u94b1\uff0c\u4e3aLD\u4e70\u4e86\u5757\u624b\u8868",
      "reply_content":
          "\n\u725b \u90fd\u662f\u7ecf\u5178\u6b3e\uff0c\u6211\u4e2a\u4eba\u4e5f\u6bd4\u8f83\u559c\u6b22\uff0c\u4e0b\u6b21\u6709\u94b1\u53bb\u4e701101 \u548c423\n",
      "reply_url": "",
      "is_read": 1,
      "reply_remind_id": 4733548,
      "reply_nick_name": "newgz2016",
      "user_id": 152489,
      "replied_date": "1528693016000",
      "icon":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/89\/152489.jpg"
    },
    {
      "topic_id": 280655,
      "board_id": 31,
      "board_name": "\u516c\u8def\u5c71\u5730",
      "topic_content":
          "    \u5e73\u65f6\u5728\u53f0\u5b50\u4e0a\u9a91\u7684\u65f6\u5019\uff0c\u529f\u7387\u6bd4\u8f83\u7a33\u5b9a\uff0c\u7801\u8868\u8bbe\u7f6e\u7684\u662f\u663e\u793a\u5373\u65f6 ..",
      "topic_url":
          "http:\/\/bbs.77bike.com\/attachment\/Mon_1806\/31_116756_999ad64fc6410e9.png",
      "topic_subject":
          "\u804a\u804a\u7801\u8868\u663e\u793a\u8bbe\u7f6e\u4e60\u60ef",
      "reply_content": "\u81ea\u5df1\u7684\u968f\u4fbf\u5f04\u5f04\n",
      "reply_url":
          "http:\/\/bbs.77bike.com\/attachment\/Mon_1806\/31_669_b133ef3b91aaccf.jpg",
      "is_read": 1,
      "reply_remind_id": 4730370,
      "reply_nick_name": "\u5218\u5f71",
      "user_id": 669,
      "replied_date": "1528370343000",
      "icon": "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/69\/669.jpg"
    },
    {
      "topic_id": 280655,
      "board_id": 31,
      "board_name": "\u516c\u8def\u5c71\u5730",
      "topic_content":
          "    \u5e73\u65f6\u5728\u53f0\u5b50\u4e0a\u9a91\u7684\u65f6\u5019\uff0c\u529f\u7387\u6bd4\u8f83\u7a33\u5b9a\uff0c\u7801\u8868\u8bbe\u7f6e\u7684\u662f\u663e\u793a\u5373\u65f6 ..",
      "topic_url":
          "http:\/\/bbs.77bike.com\/attachment\/Mon_1806\/31_116756_999ad64fc6410e9.png",
      "topic_subject":
          "\u804a\u804a\u7801\u8868\u663e\u793a\u8bbe\u7f6e\u4e60\u60ef",
      "reply_content":
          "\u5237\u65b0\u6162\u4e0d\u662f\u8bf41S\u7684\u95f4\u9694\uff0c\u800c\u662f\u9009\u4e86\u4e4b\u540e\u6570\u636e\u5237\u65b0\u6ede\u540e\u5427\n",
      "reply_url": "",
      "is_read": 1,
      "reply_remind_id": 4730058,
      "reply_nick_name": "77\u62f3\u5934",
      "user_id": 162512,
      "replied_date": "1528351760000",
      "icon":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/12\/162512.jpg"
    },
    {
      "topic_id": 280655,
      "board_id": 31,
      "board_name": "\u516c\u8def\u5c71\u5730",
      "topic_content":
          "    \u5e73\u65f6\u5728\u53f0\u5b50\u4e0a\u9a91\u7684\u65f6\u5019\uff0c\u529f\u7387\u6bd4\u8f83\u7a33\u5b9a\uff0c\u7801\u8868\u8bbe\u7f6e\u7684\u662f\u663e\u793a\u5373\u65f6 ..",
      "topic_url":
          "http:\/\/bbs.77bike.com\/attachment\/Mon_1806\/31_116756_999ad64fc6410e9.png",
      "topic_subject":
          "\u804a\u804a\u7801\u8868\u663e\u793a\u8bbe\u7f6e\u4e60\u60ef",
      "reply_content":
          "\u5fc3\u7387\u3001\u8e0f\u9891\u3001\u65f6\u95f4\u3001\u901f\u5ea6\u3001\u91cc\u7a0b\u3002",
      "reply_url": "",
      "is_read": 1,
      "reply_remind_id": 4729935,
      "reply_nick_name": "hothothot",
      "user_id": 143248,
      "replied_date": "1528343168000",
      "icon":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/48\/143248.jpg"
    },
    {
      "topic_id": 280655,
      "board_id": 31,
      "board_name": "\u516c\u8def\u5c71\u5730",
      "topic_content":
          "    \u5e73\u65f6\u5728\u53f0\u5b50\u4e0a\u9a91\u7684\u65f6\u5019\uff0c\u529f\u7387\u6bd4\u8f83\u7a33\u5b9a\uff0c\u7801\u8868\u8bbe\u7f6e\u7684\u662f\u663e\u793a\u5373\u65f6 ..",
      "topic_url":
          "http:\/\/bbs.77bike.com\/attachment\/Mon_1806\/31_116756_999ad64fc6410e9.png",
      "topic_subject":
          "\u804a\u804a\u7801\u8868\u663e\u793a\u8bbe\u7f6e\u4e60\u60ef",
      "reply_content":
          "\u9996\u5148\uff0c\u6211\u9700\u8981\u4e00\u5757\u7801\u8868",
      "reply_url": "",
      "is_read": 1,
      "reply_remind_id": 4729902,
      "reply_nick_name": "77\u62f3\u5934",
      "user_id": 162512,
      "replied_date": "1528340748000",
      "icon":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/12\/162512.jpg"
    },
    {
      "topic_id": 280655,
      "board_id": 31,
      "board_name": "\u516c\u8def\u5c71\u5730",
      "topic_content":
          "    \u5e73\u65f6\u5728\u53f0\u5b50\u4e0a\u9a91\u7684\u65f6\u5019\uff0c\u529f\u7387\u6bd4\u8f83\u7a33\u5b9a\uff0c\u7801\u8868\u8bbe\u7f6e\u7684\u662f\u663e\u793a\u5373\u65f6 ..",
      "topic_url":
          "http:\/\/bbs.77bike.com\/attachment\/Mon_1806\/31_116756_999ad64fc6410e9.png",
      "topic_subject":
          "\u804a\u804a\u7801\u8868\u663e\u793a\u8bbe\u7f6e\u4e60\u60ef",
      "reply_content":
          "\u8981\u8fd9\u4e9b\uff0c\u5b9e\u65f6\u529f\u7387\uff0c\u5e73\u5747\u529f\u7387\uff0c\u5f53\u524d\u5708\u6570\u65f6\u95f4\uff0c\u5f53\u524d\u5708\u6570\u8ddd\u79bb\uff0c\u5761\u5ea6 ..",
      "reply_url": "",
      "is_read": 1,
      "reply_remind_id": 4729875,
      "reply_nick_name": "150448215",
      "user_id": 104487,
      "replied_date": "1528339464000",
      "icon": "http:\/\/bbs.77bike.com\/attachment\/upload\/87\/104487.jpg"
    },
    {
      "topic_id": 280369,
      "board_id": 42,
      "board_name": "\u8d60\u9001\u4e49\u5356",
      "topic_content":
          "\u8d60\u9001sp8\u62c6\u8f66\u96f6\u4ef6\uff1a\n\u628a\u59571\u5bf9\uff1b\n\u8f6c\u628a\u4e00\u4e2a\u5e26\u7ebf\uff1b\nV\u52394\u4e2a\uff0c\u6709\u4e00\u4e2a\u4e0d ..",
      "topic_url": "",
      "topic_subject":
          "[\u5df2\u9001\u51fa] SP8\u62c6\u8f66\u95f2\u7f6e\u96f6\u914d\u4ef6(V\u5239\u3001\u628a\u5957\u3001\u8f6c\u628a)",
      "reply_content": "\u697c\u4e3b\u597d\u4eba\n",
      "reply_url": "",
      "is_read": 1,
      "reply_remind_id": 4727811,
      "reply_nick_name": "\u5feb\u8dd1\u5c0f\u54f2",
      "user_id": 157361,
      "replied_date": "1528124886000",
      "icon":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/61\/157361.jpg"
    },
    {
      "topic_id": 280369,
      "board_id": 42,
      "board_name": "\u8d60\u9001\u4e49\u5356",
      "topic_content":
          "\u8d60\u9001sp8\u62c6\u8f66\u96f6\u4ef6\uff1a\n\u628a\u59571\u5bf9\uff1b\n\u8f6c\u628a\u4e00\u4e2a\u5e26\u7ebf\uff1b\nV\u52394\u4e2a\uff0c\u6709\u4e00\u4e2a\u4e0d ..",
      "topic_url": "",
      "topic_subject":
          "[\u5df2\u9001\u51fa] SP8\u62c6\u8f66\u95f2\u7f6e\u96f6\u914d\u4ef6(V\u5239\u3001\u628a\u5957\u3001\u8f6c\u628a)",
      "reply_content": "\u697c\u4e3b\u597d\u4eba\n",
      "reply_url": "",
      "is_read": 1,
      "reply_remind_id": 4725473,
      "reply_nick_name": "Yerenpan",
      "user_id": 159873,
      "replied_date": "1527863143000",
      "icon":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/73\/159873.jpg"
    },
    {
      "topic_id": 280369,
      "board_id": 42,
      "board_name": "\u8d60\u9001\u4e49\u5356",
      "topic_content":
          "caimumu:\u4e0d\u597d\u610f\u601d\u521a\u521a\u4e0a\u9762\u7684aishangyu\u90fd\u8981\u4e86\u5462(2018-06-01 21:18 ..",
      "topic_url": "",
      "topic_subject":
          "[\u5df2\u9001\u51fa] SP8\u62c6\u8f66\u95f2\u7f6e\u96f6\u914d\u4ef6(V\u5239\u3001\u628a\u5957\u3001\u8f6c\u628a)",
      "reply_content":
          "\n\u6ca1\u4e8b\uff0c\uff0c\u6211\u6ca1\u4ed4\u7ec6\u770b\u3002\uff0c\uff0c\uff0c",
      "reply_url": "",
      "is_read": 1,
      "reply_remind_id": 4725439,
      "reply_nick_name": "egg8349",
      "user_id": 156777,
      "replied_date": "1527859462000",
      "icon":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/77\/156777.jpg"
    },
    {
      "topic_id": 280369,
      "board_id": 42,
      "board_name": "\u8d60\u9001\u4e49\u5356",
      "topic_content":
          "\u8d60\u9001sp8\u62c6\u8f66\u96f6\u4ef6\uff1a\n\u628a\u59571\u5bf9\uff1b\n\u8f6c\u628a\u4e00\u4e2a\u5e26\u7ebf\uff1b\nV\u52394\u4e2a\uff0c\u6709\u4e00\u4e2a\u4e0d ..",
      "topic_url": "",
      "topic_subject":
          "[\u5df2\u9001\u51fa] SP8\u62c6\u8f66\u95f2\u7f6e\u96f6\u914d\u4ef6(V\u5239\u3001\u628a\u5957\u3001\u8f6c\u628a)",
      "reply_content": "\u697c\u4e3b\u597d\u4eba",
      "reply_url": "",
      "is_read": 1,
      "reply_remind_id": 4725432,
      "reply_nick_name": "egg8349",
      "user_id": 156777,
      "replied_date": "1527859092000",
      "icon":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/77\/156777.jpg"
    },
    {
      "topic_id": 280369,
      "board_id": 42,
      "board_name": "\u8d60\u9001\u4e49\u5356",
      "topic_content":
          "\u8d60\u9001sp8\u62c6\u8f66\u96f6\u4ef6\uff1a\n\u628a\u59571\u5bf9\uff1b\n\u8f6c\u628a\u4e00\u4e2a\u5e26\u7ebf\uff1b\nV\u52394\u4e2a\uff0c\u6709\u4e00\u4e2a\u4e0d ..",
      "topic_url": "",
      "topic_subject":
          "[\u5df2\u9001\u51fa] SP8\u62c6\u8f66\u95f2\u7f6e\u96f6\u914d\u4ef6(V\u5239\u3001\u628a\u5957\u3001\u8f6c\u628a)",
      "reply_content": "\u4e0d\u9519\uff0c\u8d5e\n",
      "reply_url": "",
      "is_read": 1,
      "reply_remind_id": 4725417,
      "reply_nick_name": "77\u62f3\u5934",
      "user_id": 162512,
      "replied_date": "1527858467000",
      "icon":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/12\/162512.jpg"
    },
    {
      "topic_id": 280369,
      "board_id": 42,
      "board_name": "\u8d60\u9001\u4e49\u5356",
      "topic_content":
          "caimumu:OK\uff0c\u5bf9\u4e86\uff0c\u8fd8\u6709\u4e2a\u65e5\u9a70\u76848\u901f\u98de\u8f6e\u8981\u5417\uff1f\u4e00\u8d77\u7684\n (2018-06- ..",
      "topic_url": "",
      "topic_subject":
          "[\u5df2\u9001\u51fa] SP8\u62c6\u8f66\u95f2\u7f6e\u96f6\u914d\u4ef6(V\u5239\u3001\u628a\u5957\u3001\u8f6c\u628a)",
      "reply_content":
          "\n\u4e5f\u597d\uff0c\u5230\u65f6\u5019\u5e2e\u4ed6\u628a\u53d8\u901f\u90fd\u5347\u7ea7\u4e00\u4e0b\n",
      "reply_url": "",
      "is_read": 1,
      "reply_remind_id": 4725416,
      "reply_nick_name": "aishangyu",
      "user_id": 19374,
      "replied_date": "1527858382000",
      "icon":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/74\/19374.jpg"
    },
    {
      "topic_id": 280369,
      "board_id": 42,
      "board_name": "\u8d60\u9001\u4e49\u5356",
      "topic_content":
          "\u8d60\u9001sp8\u62c6\u8f66\u96f6\u4ef6\uff1a\n\u628a\u59571\u5bf9\uff1b\n\u8f6c\u628a\u4e00\u4e2a\u5e26\u7ebf\uff1b\nV\u52394\u4e2a\uff0c\u6709\u4e00\u4e2a\u4e0d ..",
      "topic_url": "",
      "topic_subject":
          "[\u5df2\u9001\u51fa] SP8\u62c6\u8f66\u95f2\u7f6e\u96f6\u914d\u4ef6(V\u5239\u3001\u628a\u5957\u3001\u8f6c\u628a)",
      "reply_content":
          "\u6211\u8981\uff0c\u8c22\u8c22\n\u521a\u597d\u4eca\u5929\u670b\u53cb\u8bf4p6\u4e0d\u597d\u9a91\u4e86\u8981\u5347\u7ea7\n",
      "reply_url": "",
      "is_read": 1,
      "reply_remind_id": 4725413,
      "reply_nick_name": "aishangyu",
      "user_id": 19374,
      "replied_date": "1527858060000",
      "icon":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/74\/19374.jpg"
    }
  ],
  "has_next": 1,
  "icon_url": ""
};
