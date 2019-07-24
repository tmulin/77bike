import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';

import '../common.dart';

part 'forum_topicadmin.jser.dart';

class TopicAdminAction {
  static const String action = "forum/topicadmin";
  static const String adminActionNew = "new";
  static const String adminActionReply = "reply";
  static const String adminActionEdit = "edit";

  static Map<String, dynamic> buildCreateRequest(PublishTopicModel model) {
    final modelMap = PublishTopicModelSerializer().toMap(model);
    modelMap.remove("tid");
    if (model.typeId == null || model.typeId == 0) modelMap.remove("typeId");

    final request =
        PublishTopicRequest(body: PublishTopicRequestBody(json: modelMap));
    final String json =
        jsonEncode(PublishTopicRequestSerializer().toMap(request));
    return {"act": adminActionNew, "json": Uri.encodeFull(json)};
  }

  static Map<String, dynamic> buildReplyRequest(PublishTopicModel model) {
    assert(model.tid > 0);
    final modelMap = PublishTopicModelSerializer().toMap(model);
    modelMap.remove("title");
    if (model.typeId == null || model.typeId == 0) modelMap.remove("typeId");
    final request =
        PublishTopicRequest(body: PublishTopicRequestBody(json: modelMap));
    final String json =
        jsonEncode(PublishTopicRequestSerializer().toMap(request));
    return {"act": adminActionReply, "json": Uri.encodeFull(json)};
  }

  static MobcentResponse parseResponse(Map<String, dynamic> response) {
    return MobcentResponseSerializer().fromMap(response);
  }
}

class PublishTopicRequest {
  PublishTopicRequestBody body;

  PublishTopicRequest({this.body});
}

class PublishTopicRequestBody {
  PublishTopicRequestBody({this.json});

  Map<String, dynamic> json;
}

class PublishTopicModel {
  PublishTopicModel();

  PublishTopicModel.post(
      {@required this.fid,
      this.typeId,
      this.location = "",
      this.aid = "",
      @required this.title,
      String textContent = "",
      List<Attachment> attachments = const [],
      this.longitude = "0.000000",
      this.latitude = "0.000000",
      this.isHidden = 0,
      this.isAnonymous = 0,
      this.isOnlyAuthor = 0,
      this.isShowPostion = 1}) {
    this.replyId = 0;
    this.isQuote = 0;
    this._buildContent(textContent, attachments);
  }

  PublishTopicModel.reply(
      {@required this.fid,
      @required this.tid,
      this.location = "",
      this.aid = "",
      String textContent = "",
      List<Attachment> attachments = const [],
      this.longitude = "0.000000",
      this.latitude = "0.000000",
      this.isHidden = 0,
      this.isAnonymous = 0,
      this.isOnlyAuthor = 0,
      this.isShowPostion = 1,
      this.replyId = 0,
      this.isQuote = 0}) {
    this.isQuote = this.replyId > 0 ? 1 : 0;
    this._buildContent(textContent, attachments);
  }

  bool _buildContent(String textContent, List<Attachment> attachments) {
    if ((textContent == null || textContent.trim().length == 0) &&
        (attachments == null || attachments.length == 0)) {
      return false;
    }
    List<PostContent> postContents = new List<PostContent>();
    if (textContent != null && textContent.trim().length > 0) {
      postContents.add(PostContent.text(textContent));
    }

    if (attachments != null) {
      this.aid = attachments.map((item) {
        postContents.add(PostContent.image(item.urlName));
        return item.id.toStringAsFixed(0);
      }).join(",");
    }

    this.content = jsonEncode(PostContentSerializer().toList(postContents));
    this.content = Uri.encodeFull(this.content);
    return true;
  }

  int fid;
  int tid;
  int typeId;
  int replyId;

  String location;
  String aid;
  String title; // 标题(发帖时设置)
  String content;
  String longitude; // double string
  String latitude; // double string
  int isQuote; // 是否引用回帖 1 or 0

  int isHidden;
  int isAnonymous;
  int isOnlyAuthor;
  int isShowPostion;
}

class Attachment {
  int id;
  String urlName;

  Attachment({@required this.id, @required this.urlName});
}

class PostContent {
  PostContent({this.type, this.infor});

  PostContent.text(this.infor) : this.type = 0;

  PostContent.image(this.infor) : this.type = 1;
  int type; // 0=text,1=img,3=audio

  String infor;
}

@GenSerializer()
class PublishTopicRequestSerializer extends Serializer<PublishTopicRequest>
    with _$PublishTopicRequestSerializer {}

@GenSerializer()
class PublishTopicRequestBodySerializer
    extends Serializer<PublishTopicRequestBody>
    with _$PublishTopicRequestBodySerializer {}

@GenSerializer()
class PublishTopicModelSerializer extends Serializer<PublishTopicModel>
    with _$PublishTopicModelSerializer {}

@GenSerializer()
class PostContentSerializer extends Serializer<PostContent>
    with _$PostContentSerializer {}

/// https://github.com/UESTC-BBS/API-Docs/wiki/Mobcent-API
/*
accessSecret	f01b3418e99ebdc5fda5fa3b8b9c2
accessToken	ac3f19b94085e3b86c228b54f71c7
act	reply
apphash	4f936bce
forumKey	itTovrNYj6jgmwUBcQ
json	%7B%0A%20%20%22body%22%20%3A%20%7B%0A%20%20%20%20%22json%22%20%3A%20%7B%0A%20%20%20%20%20%20%22isShowPostion%22%20%3A%20%221%22%2C%0A%20%20%20%20%20%20%22content%22%20%3A%20%22%255B%250A%2520%2520%257B%250A%2520%2520%2520%2520%2522type%2522%2520%253A%2520%25220%2522%252C%250A%2520%2520%2520%2520%2522infor%2522%2520%253A%2520%2522%2520%25E6%258A%25B1%25E6%25AD%2589%25E4%25B8%258A%25E9%259D%25A2%25E8%25A7%2586%25E9%25A2%2591%25E7%259A%2584%25E5%258F%2591%25E9%2594%2599%25E4%25BA%2586%25EF%25BC%258C%25E7%25AD%2589%25E6%2588%2591%25E6%2589%25BE%25E4%25B8%25AA%25E5%259C%25B0%25E6%2596%25B9%25E4%25BC%25A0%25E4%25B8%258A%25E5%258E%25BB%25E5%258F%2591%25E4%25B8%25AA%25E9%2593%25BE%25E6%258E%25A5%25E3%2580%2582%25E7%258E%25B0%25E5%259C%25A8%25E5%25B0%25B1%25E6%2598%25AF%25E5%2590%258C%25E6%2597%25B6%25E6%258A%258AAndroid%25E5%2592%258CiOS%25E4%25B8%25A4%25E4%25B8%25AA%25E5%25AE%25A2%25E6%2588%25B7%25E7%25AB%25AF%25E4%25B8%2580%25E8%25B5%25B7%25E9%2583%25BD%25E5%25AE%259E%25E7%258E%25B0%25E4%25BA%2586%25E3%2580%2582%2522%250A%2520%2520%257D%250A%255D%22%2C%0A%20%20%20%20%20%20%22longitude%22%20%3A%20%220.000000%22%2C%0A%20%20%20%20%20%20%22aid%22%20%3A%20%22%22%2C%0A%20%20%20%20%20%20%22latitude%22%20%3A%20%220.000000%22%2C%0A%20%20%20%20%20%20%22fid%22%20%3A%20%2223%22%2C%0A%20%20%20%20%20%20%22isQuote%22%20%3A%20%220%22%2C%0A%20%20%20%20%20%20%22tid%22%20%3A%20%22302128%22%0A%20%20%20%20%7D%0A%20%20%7D%0A%7D
platType	5
sdkVersion	2.4.0
*/

/* 文本
json => decode
{
  "body" : {
    "json" : {
      "isShowPostion" : "1",
      "content" : "%5B%0A%20%20%7B%0A%20%20%20%20%22type%22%20%3A%20%220%22%2C%0A%20%20%20%20%22infor%22%20%3A%20%22%20%E6%8A%B1%E6%AD%89%E4%B8%8A%E9%9D%A2%E8%A7%86%E9%A2%91%E7%9A%84%E5%8F%91%E9%94%99%E4%BA%86%EF%BC%8C%E7%AD%89%E6%88%91%E6%89%BE%E4%B8%AA%E5%9C%B0%E6%96%B9%E4%BC%A0%E4%B8%8A%E5%8E%BB%E5%8F%91%E4%B8%AA%E9%93%BE%E6%8E%A5%E3%80%82%E7%8E%B0%E5%9C%A8%E5%B0%B1%E6%98%AF%E5%90%8C%E6%97%B6%E6%8A%8AAndroid%E5%92%8CiOS%E4%B8%A4%E4%B8%AA%E5%AE%A2%E6%88%B7%E7%AB%AF%E4%B8%80%E8%B5%B7%E9%83%BD%E5%AE%9E%E7%8E%B0%E4%BA%86%E3%80%82%22%0A%20%20%7D%0A%5D",
      "longitude" : "0.000000",
      "aid" : "",
      "latitude" : "0.000000",
      "fid" : "23",
      "isQuote" : "0",
      "tid" : "302128"
    }
  }
}

content => decode
[
  {
    "type" : "0",
    "infor" : " 抱歉上面视频的发错了，等我找个地方传上去发个链接。现在就是同时把Android和iOS两个客户端一起都实现了。"
  }
]
*/

/*
图片
json => decode
{
  "body" : {
    "json" : {
      "aid" : "1332241",
      "tid" : "302128",
      "isQuote" : "0",
      "fid" : "23",
      "content" : "%5B%0A%20%20%7B%0A%20%20%20%20%22type%22%20%3A%20%220%22%2C%0A%20%20%20%20%22infor%22%20%3A%20%22%E6%BC%94%E7%A4%BA%E8%A7%86%E9%A2%91%22%0A%20%20%7D%2C%0A%20%20%7B%0A%20%20%20%20%22type%22%20%3A%20%221%22%2C%0A%20%20%20%20%22infor%22%20%3A%20%22http%3A%5C%2F%5C%2Fbbs.77bike.com%5C%2Fattachment%5C%2FMon_1907%5C%2F23_116756_02730cb21357bf3.jpg%22%0A%20%20%7D%0A%5D",
      "isShowPostion" : "1"
    }
  }
}

content => decode

[
  {
    "type" : "0",
    "infor" : "演示视频"
  },
  {
    "type" : "1",
    "infor" : "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/23_116756_02730cb21357bf3.jpg"
  }
]

*/

/* 多图片
{
  "body" : {
    "json" : {
      "aid" : "1332236,1332237,1332238,1332239,1332240",
      "tid" : "302128",
      "isQuote" : "0",
      "fid" : "23",
      "content" : "%5B%0A%20%20%7B%0A%20%20%20%20%22type%22%20%3A%20%220%22%2C%0A%20%20%20%20%22infor%22%20%3A%20%22android%E7%B3%BB%E7%BB%9F%E4%B8%8B%E6%88%AA%E5%9B%BE%EF%BC%8C%E4%B8%8EiOS%E5%9F%BA%E6%9C%AC%E4%B8%80%E6%A0%B7%EF%BC%8C%E5%9C%A8%E9%A1%B6%E9%83%A8%E6%A0%87%E9%A2%98%E6%A0%8F%E8%83%BD%E7%9C%8B%E5%87%BA%E6%98%AF%E4%B8%8D%E5%90%8C%E7%B3%BB%E7%BB%9F%22%0A%20%20%7D%2C%0A%20%20%7B%0A%20%20%20%20%22type%22%20%3A%20%221%22%2C%0A%20%20%20%20%22infor%22%20%3A%20%22http%3A%5C%2F%5C%2Fbbs.77bike.com%5C%2Fattachment%5C%2Fthumb%5C%2FMon_1907%5C%2F23_116756_771d19756d649e0.jpg%22%0A%20%20%7D%2C%0A%20%20%7B%0A%20%20%20%20%22type%22%20%3A%20%221%22%2C%0A%20%20%20%20%22infor%22%20%3A%20%22http%3A%5C%2F%5C%2Fbbs.77bike.com%5C%2Fattachment%5C%2Fthumb%5C%2FMon_1907%5C%2F23_116756_f4c4cf11b6fd105.jpg%22%0A%20%20%7D%2C%0A%20%20%7B%0A%20%20%20%20%22type%22%20%3A%20%221%22%2C%0A%20%20%20%20%22infor%22%20%3A%20%22http%3A%5C%2F%5C%2Fbbs.77bike.com%5C%2Fattachment%5C%2FMon_1907%5C%2F23_116756_c2a840f90e83115.jpg%22%0A%20%20%7D%2C%0A%20%20%7B%0A%20%20%20%20%22type%22%20%3A%20%221%22%2C%0A%20%20%20%20%22infor%22%20%3A%20%22http%3A%5C%2F%5C%2Fbbs.77bike.com%5C%2Fattachment%5C%2Fthumb%5C%2FMon_1907%5C%2F23_116756_eabeaaef346332f.jpg%22%0A%20%20%7D%2C%0A%20%20%7B%0A%20%20%20%20%22type%22%20%3A%20%221%22%2C%0A%20%20%20%20%22infor%22%20%3A%20%22http%3A%5C%2F%5C%2Fbbs.77bike.com%5C%2Fattachment%5C%2Fthumb%5C%2FMon_1907%5C%2F23_116756_79f071bf07658f3.jpg%22%0A%20%20%7D%0A%5D",
      "isShowPostion" : "1"
    }
  }
}

[
  {
    "type" : "0",
    "infor" : "android系统下截图，与iOS基本一样，在顶部标题栏能看出是不同系统"
  },
  {
    "type" : "1",
    "infor" : "http:\/\/bbs.77bike.com\/attachment\/thumb\/Mon_1907\/23_116756_771d19756d649e0.jpg"
  },
  {
    "type" : "1",
    "infor" : "http:\/\/bbs.77bike.com\/attachment\/thumb\/Mon_1907\/23_116756_f4c4cf11b6fd105.jpg"
  },
  {
    "type" : "1",
    "infor" : "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/23_116756_c2a840f90e83115.jpg"
  },
  {
    "type" : "1",
    "infor" : "http:\/\/bbs.77bike.com\/attachment\/thumb\/Mon_1907\/23_116756_eabeaaef346332f.jpg"
  },
  {
    "type" : "1",
    "infor" : "http:\/\/bbs.77bike.com\/attachment\/thumb\/Mon_1907\/23_116756_79f071bf07658f3.jpg"
  }
]

*/

/*
forum/topicadmin
发帖/回复。

act 'new'（发帖）、'reply'（回复）、其他字符串（编辑）
json JSON 格式的发帖内容。
JSON 格式：

{
  "body": {
    "json": {
      "fid": 123, // 发帖时指定版块。
      "tid": 123456, // 回复时指定帖子。
      "typeOption": ...,
      "isAnonymous": 1, // 1 表示匿名发帖。
      "isOnlyAuthor": 1, // 1 表示回帖仅作者可见。
      "typeId": 1234, // 分类。
      "isQuote": 1, 是否引用之前回复的内容。
      "replyId": 123456, 回复 ID（pid）。
      "title": "Title", // 标题。
      "aid": "1,2,3", // 附件 ID，逗号隔开。
      "content": "又是一个 JSON 字符串，格式见下面。",
      "location": "TODO: 格式待确认"
    }
  }
}
body.json.content 格式：

[
  {
    "type": 0, // 0：文本（解析链接）；1：图片；3：音频;4:链接;5：附件
    "infor": "发帖内容|图片 URL|音频 URL"
  },
  ...
]
*/
/*
const _sample_reply = {
  "rs": 1,
  "errcode": "\u53d1\u5e16\u6210\u529f",
  "head": {
    "errCode": "",
    "errInfo": "\u53d1\u5e16\u6210\u529f",
    "version": "2.4.0.1",

    /// 是否弹出操作成功提醒
    "alert": 1
  },
  "body": {"externInfo": null}
};
const _sample_reply2 = {
  "head": {
    "errCode": "010000002",
    "errInfo": "本版块开启强制主题分类功能,请选择文章分类!",
    "version": "2.4.0.1",
    "alert": 1
  },
  "body": {"externInfo": null},
  "rs": 0,
  "errcode": "errcode=本版块开启强制主题分类功能,请选择文章分类!"
};
*/

/*act	new
accessSecret	f01b3418e99ebdc5fda5fa3b8b9c2
json	%7B%0A%20%20%22body%22%20%3A%20%7B%0A%20%20%20%20%22json%22%20%3A%20%7B%0A%20%20%20%20%20%20%22typeId%22%20%3A%2086%2C%0A%20%20%20%20%20%20%22content%22%20%3A%20%22%255B%250A%2520%2520%257B%250A%2520%2520%2520%2520%2522type%2522%2520%253A%2520%25220%2522%252C%250A%2520%2520%2520%2520%2522infor%2522%2520%253A%2520%25225%25E6%259C%2588%25E4%25BB%25BD%25E4%25B9%258B%25E5%2590%258E%25E5%2585%25AC%25E5%258F%25B8%25E6%258D%25A2%25E4%25BA%2586%25E6%2596%25B0%25E7%259A%2584%25E5%259C%25B0%25E5%259D%2580%25EF%25BC%258C%25E4%25B8%258A%25E7%258F%25AD%25E8%25B7%25AF%25E7%25A8%258B%25E7%2594%25B1%25E4%25B9%258B%25E5%2589%258D%25E7%259A%258415%25E5%2585%25AC%25E9%2587%258C%25E7%25BC%25A9%25E5%2587%258F%25E5%2588%25B08.5%25E5%2585%25AC%25E9%2587%258C%25E4%25BA%2586%25EF%25BC%258C%25E8%25B7%25AF%25E7%25A8%258B%25E8%2599%25BD%25E7%2584%25B6%25E8%25BF%2591%25E4%25BA%2586%25E5%25A5%25BD%25E5%25A4%259A%25EF%25BC%258C%25E4%25BD%2586%25E6%2597%25A9%25E4%25B8%258A%25E4%25B8%258A%25E7%258F%25AD%25E5%25BE%2588%25E4%25B8%258D%25E7%2588%25BD%25E7%259A%2584%25E6%2598%25AF%25E8%25A6%2581%25E7%2588%25AC%25E4%25B8%2580%25E4%25B8%25AA%25E5%25A4%25A7%25E5%259D%25A1%25EF%25BC%258C1.1%25E5%2585%25AC%25E9%2587%258C%25E5%25B7%25A6%25E5%258F%25B3%25EF%25BC%258C%25E5%25B9%25B3%25E5%259D%2587%25E5%259D%25A1%25E5%25BA%25A68%2525%25EF%25BC%258C%25E5%2590%258E%25E9%259D%25A2%25E4%25B8%2580%25E5%258D%258A%25E8%25B7%25AF%25E7%25A8%258B%25E5%25B7%25AE%25E4%25B8%258D%25E5%25A4%259A10%2525%25E4%25BA%2586%25EF%25BC%258C%25E4%25B9%258B%25E5%2589%258D%25E6%258E%25A5%25E8%25BF%2591%25E4%25B8%2580%25E5%25B9%25B4%25E7%259A%2584%25E6%2597%25B6%25E9%2597%25B4%25E4%25B8%2580%25E7%259B%25B4%25E6%25B2%25A1%25E6%259C%2589%25E4%25BF%259D%25E6%258C%2581%25E9%2594%25BB%25E7%2582%25BC%25EF%25BC%258C%25E4%25BD%2593%25E8%2583%25BD%25E4%25B8%258B%25E9%2599%258D%25E4%25B8%25A5%25E9%2587%258D%25EF%25BC%258C%25E7%25BB%258F%25E8%25BF%2587%25E8%25BF%2599%25E4%25B8%25A4%25E4%25B8%25AA%25E5%25A4%259A%25E6%259C%2588%25E7%259A%2584%25E7%2588%25AC%25E5%259D%25A1%25E9%2594%25BB%25E7%2582%25BC%25E5%258A%25A0%25E6%2581%25A2%25E5%25A4%258D%25E4%25B9%258B%25E5%2590%258E%25EF%25BC%258C%25E5%258F%25AF%25E4%25BB%25A5%25E4%25BF%259D%25E6%258C%2581%25E6%25AF%258F%25E5%25A4%25A9%25E9%2583%25BD%25E8%2583%25BD%25E8%25B9%25AC%25E4%25B8%258A%25E5%258E%25BB%25E4%25B8%258D%25E7%2594%25A8%25E6%258E%25A8%25E8%25BD%25A6%25E4%25BA%2586%25E3%2580%2582%25E7%258E%25B0%25E5%259C%25A8%25E6%2597%25A9%25E4%25B8%258A%25E6%259C%2580%25E5%25BF%25AB%25E8%2583%25BD5%253A05%25E7%2588%25AC%25E4%25B8%258A%25E5%258E%25BB%25E4%25BA%2586%25EF%25BC%258C%25E8%25B7%259D%25E7%25A6%25BB%25E4%25B9%258B%25E5%2589%258D%25E6%259C%2580%25E5%25BF%25AB%25E7%259A%2584%25E8%25AE%25B0%25E5%25BD%25954%253A45%25E5%25BE%2588%25E8%25BF%2591%25E4%25BA%2586%255B%25E9%25AD%2594%25E9%25AC%25BC%255D%2522%250A%2520%2520%257D%252C%250A%2520%2520%257B%250A%2520%2520%2520%2520%2522type%2522%2520%253A%2520%25221%2522%252C%250A%2520%2520%2520%2520%2522infor%2522%2520%253A%2520%2522http%253A%255C%252F%255C%252Fbbs.77bike.com%255C%252Fattachment%255C%252Fthumb%255C%252FMon_1907%255C%252F15_116756_84075800acd6cad.jpg%2522%250A%2520%2520%257D%252C%250A%2520%2520%257B%250A%2520%2520%2520%2520%2522type%2522%2520%253A%2520%25221%2522%252C%250A%2520%2520%2520%2520%2522infor%2522%2520%253A%2520%2522http%253A%255C%252F%255C%252Fbbs.77bike.com%255C%252Fattachment%255C%252Fthumb%255C%252FMon_1907%255C%252F15_116756_ba0cf52fff09e34.jpg%2522%250A%2520%2520%257D%252C%250A%2520%2520%257B%250A%2520%2520%2520%2520%2522type%2522%2520%253A%2520%25221%2522%252C%250A%2520%2520%2520%2520%2522infor%2522%2520%253A%2520%2522http%253A%255C%252F%255C%252Fbbs.77bike.com%255C%252Fattachment%255C%252Fthumb%255C%252FMon_1907%255C%252F15_116756_88569071b928b54.jpg%2522%250A%2520%2520%257D%250A%255D%22%2C%0A%20%20%20%20%20%20%22isShowPostion%22%20%3A%20%221%22%2C%0A%20%20%20%20%20%20%22title%22%20%3A%20%22%25E5%25A4%25A7%25E7%2583%25AD%25E5%25A4%25A9%25E8%25BF%2598%25E4%25BF%259D%25E6%258C%2581%25E9%25AA%2591%25E8%25BD%25A6%22%2C%0A%20%20%20%20%20%20%22aid%22%20%3A%20%221333248%2C1333249%2C1333250%22%2C%0A%20%20%20%20%20%20%22fid%22%20%3A%20%2215%22%2C%0A%20%20%20%20%20%20%22isQuote%22%20%3A%20%220%22%0A%20%20%20%20%7D%0A%20%20%7D%0A%7D
sdkVersion	2.4.0
apphash	b76d261f
accessToken	ac3f19b94085e3b86c228b54f71c7
platType	5
forumKey	itTovrNYj6jgmwUBcQ*/
