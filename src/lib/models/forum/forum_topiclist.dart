/*
accessSecret	f01b3418e99ebdc5fda5fa3b8b9c2
accessToken	ac3f19b94085e3b86c228b54f71c7
apphash	9425b1e8
boardId	0
filterId	0
filterType	typeid
forumKey	itTovrNYj6jgmwUBcQ
isImageList	1
isRatio	0
page	1
pageSize	20
sdkVersion	2.4.0
sortby	new
topOrder	1
*/

/*
accessSecret
accessToken
apphash	9425b1e8
boardId	0
filterId	0
filterType	typeid
forumKey	itTovrNYj6jgmwUBcQ
isRatio	1
page	1
pageSize	20
sdkVersion	2.4.0
sortby	marrow
topOrder	0
*/

import 'package:jaguar_serializer/jaguar_serializer.dart';

import '../common.dart';
import 'package:qiqi_bike/models/user/user_getsetting.dart';

part 'forum_topiclist.jser.dart';

class TopicListAction {
  static const String action = "forum/topiclist";

  /// 全部
  static const String sortByAll = "all";

  /// 最新
  static const String sortByNew = "new";

  /// 精华
  static const String sortByMarrow = "marrow";

  /// 置顶
  static const String sortByTop = "top";

  static Map<String, dynamic> buildRequest(
          {
          // 版块编号, 0 表示不限版块
          int boardId = 0,
          //  板块内分类编号, 0 表示不限分类
          int filterId = 0,
          int page = 1,
          int pageSize = 20,
          // ??与isImageList相关
          int isRatio = 0,
          String sortBy = sortByNew,
          // 是否返回图片列表
          int isImageList}) =>
      {
        if (isImageList != null) "isImageList": isImageList,
        "isRatio": isRatio,
        "filterType": "typeid",
        "sortby": sortBy,
        "boardId": boardId,
        "topOrder": 1,
        "filterId": filterId,
        "page": page,
        "pageSize": pageSize
      };

  static TopicListResponse parseResponse(Map<String, dynamic> response) {
    return TopicListResponseSerializer().fromMap(response);
  }
}

class TopicListResponse extends MobcentResponse {
  List<dynamic> anno_list;

  // 版块编号
  int board_category_id;

  // 版块名称
  String board_category_name;
  List<dynamic> board_list;
  int board_category_type;
  List<dynamic> classificationTop_list;
  List<ClassificationType> classificationType_list;
  ForumInfo forumInfo;
  int has_next;
  int isOnlyTopicType;
  List<Topic> list;
  List<dynamic> newTopicPanel;
  int page;
  List<TopTopic> topTopicList;
  int total_num;
}

class Topic {
  int board_id;
  int topic_id;
  String title;
  String subject;
  int user_id;
  String last_reply_date; // "int"
  DateTime get last_reply_date_value =>
      DateTime.fromMillisecondsSinceEpoch(int.tryParse(this.last_reply_date));

  String user_nick_name;

  /// 点击查看数
  int hits;

  /// 回复数
  int replies;
  int status;

  /// 精华帖
  int essence;

  /// 置顶帖
  int top;
  int hot;
  int vote;
  String type; // "normal",
  String pic_path; // full url
  String ratio; // "int"
  String userAvatar;

  /// 是否已点赞
  int isHasRecommendAdd;

  /// 点赞，认同数
  int recommendAdd;
  List<String> imageList;
  int gender;
  String sourceWebUrl;

  Topic(
      {this.board_id = 0,
      this.topic_id = 0,
      this.title,
      this.subject,
      this.user_id = 0,
      this.last_reply_date,
      this.user_nick_name,
      this.hits = 0,
      this.replies = 0,
      this.status = 0,
      this.essence = 0,
      this.top = 0,
      this.hot = 0,
      this.vote = 0,
      this.type,
      this.pic_path,
      this.ratio,
      this.userAvatar,
      this.isHasRecommendAdd = 0,
      this.recommendAdd = 0,
      this.imageList = const [],
      this.gender = 0,
      this.sourceWebUrl});
}

class ForumInfo {
  dynamic id; // int or ""
  String title;
  String description;
  String icon;
}

class TopTopic {
  int id;
  String title;
}

@GenSerializer()
class TopicListResponseSerializer extends Serializer<TopicListResponse>
    with _$TopicListResponseSerializer {}

@GenSerializer()
class TopicSerializer extends Serializer<Topic> with _$TopicSerializer {}

@GenSerializer()
class ForumInfoSerializer extends Serializer<ForumInfo>
    with _$ForumInfoSerializer {}

@GenSerializer()
class TopTopicSerializer extends Serializer<TopTopic>
    with _$TopTopicSerializer {}

/*
const _sample = {
  "rs": 1,
  "errcode": 0,
  "head": {
    "errCode": "",
    "errInfo": "\u8c03\u7528\u6210\u529f,\u6ca1\u6709\u4efb\u4f55\u9519\u8bef",
    "version": "2.4.0.1",
    "alert": 0
  },
  "body": {"externInfo": null},
  "board_category_id": 0,
  "board_category_name": "",
  "board_category_type": 2,
  "board_list": [],
  "newTopicPanel": [],
  "classificationTop_list": [],
  "classificationType_list": [],
  "isOnlyTopicType": 0,
  "anno_list": [],
  "forumInfo": {"id": "", "title": "", "description": "", "icon": ""},
  "topTopicList": [
    {
      "id": 73916,
      "title":
          "77bike\u7b80\u4ecb\u53ca\u603b\u7248\u89c4\u2014\u65b0\u4eba\u5fc5\u8bfb\uff082016\/2\/13\u66f4\u65b0\uff09"
    },
    {
      "id": 126024,
      "title":
          "77bike\u7528\u6237\u7b49\u7ea7\u548c\u79ef\u5206\u7528\u9014\u8bf4\u660e\uff082017\/6\/20\u66f4\u65b0\uff09"
    },
    {
      "id": 144850,
      "title":
          "77bike\u5ba2\u6237\u7aef\u6765\u5566\uff01\u624b\u673a\u56de\u5e16\u53d1\u56feso easy\uff01"
    }
  ],
  "list": [
    {
      "board_id": 2,
      "topic_id": 302098,
      "title": "[Android]\u8bf7\u5927\u5bb6\u5e2e\u5fd9\u770b\u770b\u3002",
      "subject":
          "\u5e2e\u5fd9\u770b\u770b\u8fd9\u4e2a\u5927\u884ck32200\u5305\u90ae\u503c\u4e0d\u503c\uff1f\u6765\u81ea[Android]\u624b\u673a\u5ba2\u6237\u7aef",
      "user_id": 164445,
      "last_reply_date": "1562804776000",
      "user_nick_name": "\u4e01\u54e5\u54e5",
      "hits": 9,
      "replies": 8,
      "status": 0,
      "essence": 0,
      "top": 0,
      "hot": 0,
      "vote": 0,
      "type": "normal",
      "pic_path":
          "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/2_164445_520b5a9c5af7353.png",
      "ratio": "1",
      "userAvatar":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/45\/164445.jpg",
      "isHasRecommendAdd": 0,
      "recommendAdd": 0,
      "imageList": [
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/2_164445_520b5a9c5af7353.png",
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/2_164445_cdef99b293bb65c.png"
      ],
      "gender": 1,
      "sourceWebUrl": "http:\/\/bbs.77bike.com\/read.php?tid=302098"
    },
    {
      "board_id": 5,
      "topic_id": 302097,
      "title":
          "[Android]\u76ae\u76ae\u7684\u7b2c\u4e8c\u53f0\u8f66\uff5e\u521d\u6539\u5b8c\u6210\uff5e",
      "subject":
          "\u524d\u4e9b\u5929\u6536\u4e86\u4e2a14\u5bf8\u7ae5\u8f66\uff0c\u6536\u6765\u7684\u6837\u5b50\uff0c8.3\u516c\u65a4\uff5e\u7b2c\u4e00\u7248\u6539\u6b63\u4e00\u4e9b\u8bbe ..",
      "user_id": 157318,
      "last_reply_date": "1562774007000",
      "user_nick_name": "\u82b1\u8f6e\u548c\u5f66",
      "hits": 6,
      "replies": 5,
      "status": 0,
      "essence": 0,
      "top": 0,
      "hot": 0,
      "vote": 0,
      "type": "normal",
      "pic_path":
          "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/5_157318_d87453e8e905153.jpg",
      "ratio": "1",
      "userAvatar":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/18\/157318.jpg",
      "isHasRecommendAdd": 0,
      "recommendAdd": 0,
      "imageList": [
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/5_157318_d87453e8e905153.jpg"
      ],
      "gender": 1,
      "sourceWebUrl": "http:\/\/bbs.77bike.com\/read.php?tid=302097"
    },
    {
      "board_id": 2,
      "topic_id": 302096,
      "title": "[Android]\u5c0f\u5347\u7ea7",
      "subject":
          "1.king2\u901f\u5347\u7ea73\u901f\uff0c\u9f7f\u8f6e12-15-182.\u8d22\u54e5\u724c\u53c8\u540d\u80a5\u4ed4\u767d\u724c\u4e2d\u8f743.\u539f\u534e ..",
      "user_id": 162032,
      "last_reply_date": "1562774053000",
      "user_nick_name": "\u53f6\u5b50\u53d8\u738b\u5b50",
      "hits": 5,
      "replies": 4,
      "status": 0,
      "essence": 0,
      "top": 0,
      "hot": 0,
      "vote": 0,
      "type": "normal",
      "pic_path":
          "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/2_162032_8e63a150b456ac6.jpg",
      "ratio": "1",
      "userAvatar":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/32\/162032.jpg",
      "isHasRecommendAdd": 0,
      "recommendAdd": 0,
      "imageList": [
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/2_162032_8e63a150b456ac6.jpg",
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/2_162032_0bd7f4a2ef0adb4.jpg",
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/2_162032_040fbf5aff145aa.jpg"
      ],
      "gender": 1,
      "sourceWebUrl": "http:\/\/bbs.77bike.com\/read.php?tid=302096"
    },
    {
      "board_id": 2,
      "topic_id": 302095,
      "title": "[Android]\u6c42\u9ad8\u624b\u70b9\u8bc4\u5c0f\u5e03",
      "subject":
          "\u672c\u4eba\u6700\u8fd1\u4e70\u4e86\u5c0f\u5e03\uff0c\u53ea\u77e5\u9053\u5c0f\u5e03\u6298\u53e0\u643a\u5e26\u65b9\u4fbf\uff0c\u5bf9\u4e8e\u5176\u5b83\u6280\u672f\u6307\u6807\u5f88 ..",
      "user_id": 164075,
      "last_reply_date": "1562804374000",
      "user_nick_name": "\u91cd\u5e86\u5e02\u4e2d\u5e1d",
      "hits": 11,
      "replies": 10,
      "status": 0,
      "essence": 0,
      "top": 0,
      "hot": 1,
      "vote": 0,
      "type": "normal",
      "pic_path":
          "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/2_164075_e42448a4c70006c.jpg",
      "ratio": "1",
      "userAvatar": "http:\/\/bbs.77bike.com\/images\/face\/2.jpg",
      "isHasRecommendAdd": 0,
      "recommendAdd": 1,
      "imageList": [
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/2_164075_e42448a4c70006c.jpg",
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/2_164075_d53899160243a8c.jpg",
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/2_164075_f56701124dd7b81.jpg",
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/2_164075_3d8e1e0ec1d2117.jpg",
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/2_164075_4af4381ab546536.jpg",
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/2_164075_5da27272986a029.jpg",
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/2_164075_56cbecd6637043e.jpg",
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/2_164075_572bcc4a49c911d.jpg",
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/2_164075_a356a0a5ee4647c.jpg"
      ],
      "gender": 1,
      "sourceWebUrl": "http:\/\/bbs.77bike.com\/read.php?tid=302095"
    },
    {
      "board_id": 12,
      "topic_id": 302094,
      "title":
          "[Android]\u5c71\u573030\u901f\u79a7\u739b\u8bfa\u53d8\u901f\u4e00\u5957xt785\u8f6e\u7ec426\u5bf8",
      "subject":
          "\u5e8a\u5e95\u585e\u4e0d\u4e0b\u4e86\u540e\u62e8m786\u540e\u62e8\u5e26\u9501\u7684  10\u901f\u540e\u62e8  \u6709\u51e0\u5904\u522e\u64e6 \u529f\u80fd\u6b63 ..",
      "user_id": 139576,
      "last_reply_date": "1562761219000",
      "user_nick_name": "kinayuhu",
      "hits": 13,
      "replies": 12,
      "status": 0,
      "essence": 0,
      "top": 0,
      "hot": 1,
      "vote": 0,
      "type": "normal",
      "pic_path":
          "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/12_139576_2f1792f35377958.jpg",
      "ratio": "1",
      "userAvatar":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/76\/139576.jpg",
      "isHasRecommendAdd": 0,
      "recommendAdd": 0,
      "imageList": [
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/12_139576_2f1792f35377958.jpg",
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/12_139576_71b128df0299c7e.jpg",
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/12_139576_dbacbef965ddeda.jpg",
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/12_139576_bdcea6f0a3776c4.jpg",
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/12_139576_1bbf722f70d5a7d.jpg",
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/12_139576_0751c0f584ed0ad.jpg",
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/12_139576_caddf1e5f6c5446.jpg",
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/12_139576_97a85b24267ebfe.jpg",
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/12_139576_254077fe8b28b62.jpg"
      ],
      "gender": 1,
      "sourceWebUrl": "http:\/\/bbs.77bike.com\/read.php?tid=302094"
    },
    {
      "board_id": 24,
      "topic_id": 302093,
      "title":
          "[Android]\u641e\u4e86\u4e2a\u8fea\u5361\u4fac\u8f66\u67b6 \u538b\u5165\u4e2d\u8f74\u548c\u4e00\u4f53\u7259\u76d8\u95ee\u9898\u6c42\u6559",
      "subject":
          "\u538b\u4e86bb72\uff0c\u53d1\u73b0\u538b\u5165\u5f0f\u4e2d\u8f74\u548c\u87ba\u7eb9\u7684\u5dee\u522b\u5f88\u5927\uff0c\u538b\u5165\u4e2d\u8f74\u540e\u76f4\u63a5\u4e0a\u7259 ..",
      "user_id": 163580,
      "last_reply_date": "1562749697000",
      "user_nick_name": "derder1177",
      "hits": 6,
      "replies": 5,
      "status": 0,
      "essence": 0,
      "top": 0,
      "hot": 0,
      "vote": 0,
      "type": "normal",
      "pic_path":
          "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/24_163580_d74717ac126e8b8.jpg",
      "ratio": "1",
      "userAvatar":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/80\/163580.jpg",
      "isHasRecommendAdd": 0,
      "recommendAdd": 0,
      "imageList": [
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/24_163580_d74717ac126e8b8.jpg"
      ],
      "gender": 2,
      "sourceWebUrl": "http:\/\/bbs.77bike.com\/read.php?tid=302093"
    },
    {
      "board_id": 12,
      "topic_id": 302092,
      "title": "[Android]16g iphone se ios9",
      "subject":
          "\u5982\u9898\uff0c\u4e0d\u77e5\u9053\u6709\u4eba\u8981\u6ca1\uff0c\u73ab\u7470\u91d1\uff0c\u5c4f\u5e55\u8fb9\u6709\u70b9\u522e\u75d5\uff0c\u673a\u8eab\u65e0\u5212\u75d5\uff0c\u5c4f ..",
      "user_id": 104487,
      "last_reply_date": "1562771747000",
      "user_nick_name": "150448215",
      "hits": 21,
      "replies": 20,
      "status": 0,
      "essence": 0,
      "top": 0,
      "hot": 1,
      "vote": 0,
      "type": "normal",
      "pic_path": "",
      "ratio": "1",
      "userAvatar":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/87\/104487.jpg",
      "isHasRecommendAdd": 0,
      "recommendAdd": 0,
      "imageList": [],
      "gender": 1,
      "sourceWebUrl": "http:\/\/bbs.77bike.com\/read.php?tid=302092"
    },
    {
      "board_id": 2,
      "topic_id": 302091,
      "title": "[Android]16\u5bf8\uff0c\u59165\uff0cK3\uff0c\u5b8c\u5de5\u4e86",
      "subject":
          "\u6ce8\u610f\uff0c\u540e\u5f00\u88c685\uff0c\u4e0d\u662f92\uff0c\u7528\u7684\u662fS61\u8f6e\u7ec4\u7684\u540e\u8f6e+\u7c73\u6d1b5\u901f\u98de\u8f6e\uff0c\u6307 ..",
      "user_id": 27803,
      "last_reply_date": "1562775380000",
      "user_nick_name": "\u590f\u96ea\u5b9c",
      "hits": 19,
      "replies": 18,
      "status": 0,
      "essence": 0,
      "top": 0,
      "hot": 1,
      "vote": 0,
      "type": "normal",
      "pic_path":
          "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/2_27803_0bd1dbac650a305.jpg",
      "ratio": "1",
      "userAvatar":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/03\/27803.jpg",
      "isHasRecommendAdd": 0,
      "recommendAdd": 3,
      "imageList": [
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/2_27803_0bd1dbac650a305.jpg",
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/2_27803_a6d6aa38d37d071.jpg"
      ],
      "gender": 0,
      "sourceWebUrl": "http:\/\/bbs.77bike.com\/read.php?tid=302091"
    },
    {
      "board_id": 24,
      "topic_id": 302090,
      "title": "[iPhone]\u6362\u5ea7\u5305 \u771f\u4e0a\u9501",
      "subject":
          "\u9a91\u6765\u9a91\u53bb\u778e\u73a9\u513f\u7684P8\u9a6c\u4e0a\u8981\u5728\u5317\u4eac\u7684\u901a\u52e4\u8def\u4e0a\u53d1\u5149\u53d1\u70ed\u4e86\uff01\u4e4b\u524d\u6362\u7684 ..",
      "user_id": 157300,
      "last_reply_date": "1562805429000",
      "user_nick_name": "DoubleH",
      "hits": 9,
      "replies": 8,
      "status": 0,
      "essence": 0,
      "top": 0,
      "hot": 0,
      "vote": 0,
      "type": "normal",
      "pic_path":
          "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/24_157300_8f21b077ae463db.jpg",
      "ratio": "1",
      "userAvatar":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/00\/157300.jpg",
      "isHasRecommendAdd": 0,
      "recommendAdd": 0,
      "imageList": [
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/24_157300_8f21b077ae463db.jpg"
      ],
      "gender": 1,
      "sourceWebUrl": "http:\/\/bbs.77bike.com\/read.php?tid=302090"
    },
    {
      "board_id": 38,
      "topic_id": 302089,
      "title": "[Android]\u65e0\u804a",
      "subject":
          "\u968f\u4fbf\u559d\u70b9\u6765\u81ea[Android]\u624b\u673a\u5ba2\u6237\u7aef",
      "user_id": 166328,
      "last_reply_date": "1562713709000",
      "user_nick_name": "\u4f11\u95f2\u9a91\u5185\u8499\u53e4",
      "hits": 4,
      "replies": 3,
      "status": 0,
      "essence": 0,
      "top": 0,
      "hot": 0,
      "vote": 0,
      "type": "normal",
      "pic_path":
          "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/38_166328_b67a7cb8f263676.jpg",
      "ratio": "1",
      "userAvatar": "http:\/\/bbs.77bike.com\/images\/face\/none.gif",
      "isHasRecommendAdd": 0,
      "recommendAdd": 0,
      "imageList": [
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/38_166328_b67a7cb8f263676.jpg"
      ],
      "gender": 0,
      "sourceWebUrl": "http:\/\/bbs.77bike.com\/read.php?tid=302089"
    },
    {
      "board_id": 24,
      "topic_id": 302088,
      "title":
          "[iPhone]\u6c42\u52a9\uff1a\u6c42\u8d2d\u5144\u5f1f451\u5ea7\u7ba1\u9501\u7d27\u87ba\u4e1d",
      "subject":
          "\u6c42\u52a9\u4eca\u5929\u8c03\u5ea7\u7ba1\u65f6\u628a\u5ea7\u7ba1\u5939\u9501\u7d27\u87ba\u4e1d\u62e7\u65ad\u4e86\uff0c\u8f66\u5b50\u662fbrother 451\u94a2 ..",
      "user_id": 116756,
      "last_reply_date": "1562713688000",
      "user_nick_name": "caimumu",
      "hits": 10,
      "replies": 9,
      "status": 0,
      "essence": 0,
      "top": 0,
      "hot": 0,
      "vote": 0,
      "type": "normal",
      "pic_path":
          "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/24_116756_50cd3754ea3eec8.jpg",
      "ratio": "1",
      "userAvatar":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/56\/116756.jpg",
      "isHasRecommendAdd": 0,
      "recommendAdd": 0,
      "imageList": [
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/24_116756_50cd3754ea3eec8.jpg"
      ],
      "gender": 1,
      "sourceWebUrl": "http:\/\/bbs.77bike.com\/read.php?tid=302088"
    },
    {
      "board_id": 2,
      "topic_id": 302087,
      "title": "[Android]\u53c8\u88ab\u8d22\u5b57\u5934\u6bd2\u5bb3",
      "subject":
          "\u8d22\u5b57\u5934\u53c8\u540d\u80a5\u4ed4\u767d[\u6316\u9f3b\u5c4e]\u6765\u81ea[Android]\u624b\u673a\u5ba2\u6237\u7aef",
      "user_id": 162032,
      "last_reply_date": "1562721718000",
      "user_nick_name": "\u53f6\u5b50\u53d8\u738b\u5b50",
      "hits": 6,
      "replies": 5,
      "status": 0,
      "essence": 0,
      "top": 0,
      "hot": 0,
      "vote": 0,
      "type": "normal",
      "pic_path":
          "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/2_162032_b394165426e649a.jpg",
      "ratio": "1",
      "userAvatar":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/32\/162032.jpg",
      "isHasRecommendAdd": 0,
      "recommendAdd": 0,
      "imageList": [
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/2_162032_b394165426e649a.jpg"
      ],
      "gender": 1,
      "sourceWebUrl": "http:\/\/bbs.77bike.com\/read.php?tid=302087"
    },
    {
      "board_id": 38,
      "topic_id": 302086,
      "title":
          "[Android]\u6574\u7406\u5c4b\u5b50\u7ffb\u5230\u7684\u8001\u73a9\u5177\u4eec\u3002\u3002\u3002\u3002",
      "subject":
          "\u5be8\u6c14\u5341\u8db3\u7684535\u58f3\u5b50\u3002\u91cc\u9762\u662fE4\u7684\u62c6\u673a\u5355\u5143\u3002\u604d\u60da\u56de\u5230\u5e74\u8f7b\u7684\u65f6\u5019\u3002 ..",
      "user_id": 157745,
      "last_reply_date": "1562744618000",
      "user_nick_name": "\u4e0d\u591c\u6a59",
      "hits": 7,
      "replies": 6,
      "status": 0,
      "essence": 0,
      "top": 0,
      "hot": 0,
      "vote": 0,
      "type": "normal",
      "pic_path":
          "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/38_157745_4a108d2613adda2.jpg",
      "ratio": "1",
      "userAvatar":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/45\/157745.jpg",
      "isHasRecommendAdd": 0,
      "recommendAdd": 1,
      "imageList": [
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/38_157745_4a108d2613adda2.jpg",
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/38_157745_2dfde98b6fe7f8d.jpg"
      ],
      "gender": 1,
      "sourceWebUrl": "http:\/\/bbs.77bike.com\/read.php?tid=302086"
    },
    {
      "board_id": 12,
      "topic_id": 302085,
      "title": "[Android]\u6c42\u4e2a\u95f2\u7f6e\u7684 p20pro",
      "subject":
          "\u5982\u9898\uff0c\u60f3\u6362\u4e2a\u62cd\u7167\u597d\u70b9\u7684\u624b\u673a\uff0c\u4e0d\u73a9\u6e38\u620f\uff0c\u9884\u7b97\u6709\u9650\uff0c\u6709\u95f2\u7f6e\u7684\u6254\u4e2a ..",
      "user_id": 138848,
      "last_reply_date": "1562756136000",
      "user_nick_name": "yesed",
      "hits": 20,
      "replies": 19,
      "status": 0,
      "essence": 0,
      "top": 0,
      "hot": 1,
      "vote": 0,
      "type": "normal",
      "pic_path":
          "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/12_138848_31a3dd873f3235d.jpg",
      "ratio": "1",
      "userAvatar":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/48\/138848.jpg",
      "isHasRecommendAdd": 0,
      "recommendAdd": 0,
      "imageList": [
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/12_138848_31a3dd873f3235d.jpg",
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/12_138848_4d99105084d1589.jpg"
      ],
      "gender": 0,
      "sourceWebUrl": "http:\/\/bbs.77bike.com\/read.php?tid=302085"
    },
    {
      "board_id": 24,
      "topic_id": 302084,
      "title": "[Android]\u60f3\u4e0a\u9501\u4e86",
      "subject":
          "\u9a91\u8f66\u591a\u5e74\uff0c\u80c6\u5c0f\u6015\u4e8b\uff0c\u81f3\u4eca\u672a\u9501\uff0c\u8fd1\u65e5\u4f5c\u5fc3\u5927\u4f5c\uff0c\u60f3\u7ed9\u65c5\u884c\u8f66\u4e0a\u9501\uff0c ..",
      "user_id": 35168,
      "last_reply_date": "1562770133000",
      "user_nick_name": "seanfv",
      "hits": 33,
      "replies": 32,
      "status": 0,
      "essence": 0,
      "top": 0,
      "hot": 1,
      "vote": 0,
      "type": "normal",
      "pic_path": "",
      "ratio": "1",
      "userAvatar":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/68\/35168.jpg",
      "isHasRecommendAdd": 0,
      "recommendAdd": 0,
      "imageList": [],
      "gender": 1,
      "sourceWebUrl": "http:\/\/bbs.77bike.com\/read.php?tid=302084"
    },
    {
      "board_id": 24,
      "topic_id": 302083,
      "title":
          "[iPhone]\u8bf7\u95ee349\u76841618\uff0c\u7528\u591a\u957f\u5934\u7ba1\uff1f",
      "subject":
          "\u76ee\u524d\u8f66\u5b50\u662f\u539f\u751f349\u76841618\u8f66\u67b6\u3002\u8f66\u4e0a\u7684\u662f\u98ce\u884c31.5\u7684\u5934\u7ba1\uff0c\u611f\u89c9\u592a ..",
      "user_id": 63734,
      "last_reply_date": "1562723536000",
      "user_nick_name": "zengdh",
      "hits": 18,
      "replies": 17,
      "status": 0,
      "essence": 0,
      "top": 0,
      "hot": 1,
      "vote": 0,
      "type": "normal",
      "pic_path":
          "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/24_63734_6c8a42758145f31.jpg",
      "ratio": "1",
      "userAvatar":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/34\/63734.jpg",
      "isHasRecommendAdd": 0,
      "recommendAdd": 0,
      "imageList": [
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/24_63734_6c8a42758145f31.jpg"
      ],
      "gender": 1,
      "sourceWebUrl": "http:\/\/bbs.77bike.com\/read.php?tid=302083"
    },
    {
      "board_id": 15,
      "topic_id": 302082,
      "title": "[Android]\u4e07\u80fd\u6c34\u58f6\u67b6\u3002",
      "subject":
          "\u597d\u51b7\u6e05\u554a\u3002\u3002\u70ed\u95f9\u4e00\u4e0b\u3002\u3002\u5927\u5bb6\u90fd\u7528\u6c34\u58f6\u67b6\u88c5\u8fc7\u5565\u5c3c\u3002\u3002\u6211\u8bb0\u5f97\u6211\u4e0a ..",
      "user_id": 157745,
      "last_reply_date": "1562625512000",
      "user_nick_name": "\u4e0d\u591c\u6a59",
      "hits": 7,
      "replies": 6,
      "status": 0,
      "essence": 0,
      "top": 0,
      "hot": 0,
      "vote": 0,
      "type": "normal",
      "pic_path":
          "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/15_157745_7f385ec74f4f5a4.jpg",
      "ratio": "1",
      "userAvatar":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/45\/157745.jpg",
      "isHasRecommendAdd": 0,
      "recommendAdd": 1,
      "imageList": [
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/15_157745_7f385ec74f4f5a4.jpg"
      ],
      "gender": 1,
      "sourceWebUrl": "http:\/\/bbs.77bike.com\/read.php?tid=302082"
    },
    {
      "board_id": 31,
      "topic_id": 302081,
      "title": "[Android]\u6362\u4e86\u540e\u62e8\u5927\u5bfc\u8f6e",
      "subject":
          "\u4e0d\u7528\u6362\u5927\u9e21\u817f\uff0c\u76f4\u63a5\u628a\u539f\u88c511+11\u6362\u6210\u4e8613+15\uff0c\u6548\u679c\u4e5f\u4e0d\u9519\uff0c\u81f3\u5c11\u7a7a ..",
      "user_id": 161754,
      "last_reply_date": "1562669601000",
      "user_nick_name": "jamo01",
      "hits": 12,
      "replies": 11,
      "status": 0,
      "essence": 0,
      "top": 0,
      "hot": 1,
      "vote": 0,
      "type": "normal",
      "pic_path": "",
      "ratio": "1",
      "userAvatar":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/54\/161754.jpg",
      "isHasRecommendAdd": 0,
      "recommendAdd": 0,
      "imageList": [],
      "gender": 0,
      "sourceWebUrl": "http:\/\/bbs.77bike.com\/read.php?tid=302081"
    },
    {
      "board_id": 38,
      "topic_id": 302080,
      "title": "[Android]sra683\u5192\u4e2a\u6ce1",
      "subject":
          "\u6700\u8fd1\u4e0a\u73ed\u5fd9\uff0c\u6ca1\u65f6\u95f4\u9a91\u8f66\u6765\u81ea[Android]\u624b\u673a\u5ba2\u6237\u7aef",
      "user_id": 162920,
      "last_reply_date": "1562670830000",
      "user_nick_name": "rootss",
      "hits": 9,
      "replies": 8,
      "status": 0,
      "essence": 0,
      "top": 0,
      "hot": 0,
      "vote": 0,
      "type": "normal",
      "pic_path":
          "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/38_162920_679d579799c3802.jpg",
      "ratio": "1",
      "userAvatar":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/20\/162920.jpg",
      "isHasRecommendAdd": 0,
      "recommendAdd": 0,
      "imageList": [
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/38_162920_679d579799c3802.jpg",
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/38_162920_0dcf042e16392b8.jpg",
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/38_162920_7bb7ef89022edf6.jpg",
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/38_162920_671befafd3fe5c2.jpg",
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/38_162920_001991fc211d542.jpg",
        "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/38_162920_f6a64d6e28b2d58.jpg"
      ],
      "gender": 0,
      "sourceWebUrl": "http:\/\/bbs.77bike.com\/read.php?tid=302080"
    },
    {
      "board_id": 24,
      "topic_id": 302079,
      "title": "[Android]\u8bf7\u6559\u8f6e\u7ec4\u5f00\u6863\u95ee\u9898",
      "subject":
          "\u6700\u8fd1LD\u51fa\u8fdc\u95e8\uff0c\u6211\u53ef\u4ee5\u5148\u5148\u5148\u4e70\u540e\u594f\u594f\u88ab\u63cd\u4e86\u3002\u8f6e\u7ec4\u662f130\u5f00\u6863\uff0c\u8f66 ..",
      "user_id": 160808,
      "last_reply_date": "1562735251000",
      "user_nick_name": "sisixianxian",
      "hits": 15,
      "replies": 14,
      "status": 0,
      "essence": 0,
      "top": 0,
      "hot": 1,
      "vote": 0,
      "type": "normal",
      "pic_path": "",
      "ratio": "1",
      "userAvatar":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/08\/160808.jpg",
      "isHasRecommendAdd": 0,
      "recommendAdd": 1,
      "imageList": [],
      "gender": 1,
      "sourceWebUrl": "http:\/\/bbs.77bike.com\/read.php?tid=302079"
    }
  ],
  "page": 1,
  "has_next": 1,
  "total_num": 259250
};

const _sample2 = {
  "rs": 1,
  "errcode": 0,
  "head": {
    "errCode": "",
    "errInfo": "\u8c03\u7528\u6210\u529f,\u6ca1\u6709\u4efb\u4f55\u9519\u8bef",
    "version": "2.4.0.1",
    "alert": 0
  },
  "body": {"externInfo": null},
  "board_category_id": 0,
  "board_category_name": "",
  "board_category_type": 2,
  "board_list": [],
  "newTopicPanel": [],
  "classificationTop_list": [],
  "classificationType_list": [],
  "isOnlyTopicType": 0,
  "anno_list": [],
  "forumInfo": {"id": "", "title": "", "description": "", "icon": ""},
  "topTopicList": [],
  "list": [
    {
      "board_id": 48,
      "topic_id": 301735,
      "title": "\u6211\u4eec\u4e00\u5bb6\u5f88\u7231\u201cQ\u201d",
      "subject": "",
      "user_id": 30640,
      "last_reply_date": "1561524526000",
      "user_nick_name": "\u9a91\u4e0d\u5feb",
      "hits": 415,
      "replies": 33,
      "status": 0,
      "essence": 1,
      "top": 0,
      "hot": 1,
      "vote": 0,
      "type": "normal",
      "pic_path":
          "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/mobcentSmallPreview\/Mon_1906\/48_30640_b8108b7aa3b5298.jpg",
      "ratio": "1",
      "userAvatar":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/40\/30640.jpg",
      "isHasRecommendAdd": 0,
      "recommendAdd": 1,
      "imageList": [],
      "gender": 0,
      "sourceWebUrl": "http:\/\/bbs.77bike.com\/read.php?tid=301735"
    },
    {
      "board_id": 5,
      "topic_id": 301678,
      "title": "\u8bf4\u8bf4\u6211\u6298\u817e\u8fc7\u7684\u5750\u57ab",
      "subject":
          "\u73a9\u8f66\u65f6\u95f4\u4e0d\u957f\uff0c\u8f66\u9a91\u5f97\u4e5f\u4e0d\u591a\uff0c\u4e0d\u8fc7\u5750\u57ab\u5012\u662f\u6298\u817e\u7684\u4e0d\u5c11\uff0c\u4e00\u65b9\u9762\u6211 ..",
      "user_id": 161782,
      "last_reply_date": "1560961899000",
      "user_nick_name": "shenking",
      "hits": 821,
      "replies": 63,
      "status": 0,
      "essence": 1,
      "top": 0,
      "hot": 1,
      "vote": 0,
      "type": "normal",
      "pic_path":
          "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/mobcentSmallPreview\/Mon_1906\/5_161782_2c45e4165fdf9b1.jpg",
      "ratio": "1",
      "userAvatar":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/82\/161782.jpg",
      "isHasRecommendAdd": 0,
      "recommendAdd": 0,
      "imageList": [],
      "gender": 0,
      "sourceWebUrl": "http:\/\/bbs.77bike.com\/read.php?tid=301678"
    },
    {
      "board_id": 5,
      "topic_id": 301658,
      "title":
          "[Android]\u3010\u6c42\u8b9a\u3011birdy \u9280\u9ce5 \u91cd\u751f\u8a18\u9304\u82b3\u83ef",
      "subject":
          "\u9a0e\u4e86\u5341\u5e7e\u5e74\u7684\u6298\u758a\u8eca \u6700\u559c\u6b61\u7684\u9084\u662fbirdy\u9a0e\u4e86\u90a3\u9ebc\u591a\u8eca ,\u9084\u662f\u9ce5\u8eca\u6700 ..",
      "user_id": 165911,
      "last_reply_date": "1561340662000",
      "user_nick_name": "\u5929\u4f7f\u98ce",
      "hits": 616,
      "replies": 56,
      "status": 0,
      "essence": 1,
      "top": 0,
      "hot": 1,
      "vote": 0,
      "type": "normal",
      "pic_path":
          "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/mobcentSmallPreview\/Mon_1906\/5_165911_1889475af80a566.jpg",
      "ratio": "1",
      "userAvatar":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/11\/165911.jpg",
      "isHasRecommendAdd": 0,
      "recommendAdd": 2,
      "imageList": [],
      "gender": 0,
      "sourceWebUrl": "http:\/\/bbs.77bike.com\/read.php?tid=301658"
    },
    {
      "board_id": 31,
      "topic_id": 301653,
      "title":
          "\u6765\u804a\u804a\u8010\u529b\u8f66\u5427\u3002defy\uff0croubaix\uff0cdomane\uff0callez\uff08\u8868\u683c\u9519\u8bef\u4ee5\u4fee\u6539\uff09",
      "subject":
          "\u62b1\u6b49\uff0c\u4e0a\u6b21\u7684defy\u6570\u636e\u5b9e\u9645\u662ftcr2020\u7684\u3002\u6240\u4ee5\u7ed3\u8bba\u6709\u8bef\uff0c\u5df2\u7ecf\u66f4\u6539 ..",
      "user_id": 15598,
      "last_reply_date": "1561631874000",
      "user_nick_name": "yuyi",
      "hits": 599,
      "replies": 27,
      "status": 0,
      "essence": 1,
      "top": 0,
      "hot": 1,
      "vote": 0,
      "type": "normal",
      "pic_path":
          "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/mobcentSmallPreview\/Mon_1906\/31_15598_4bdcb5bee36dfe2.jpg",
      "ratio": "1",
      "userAvatar":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/98\/15598.jpg",
      "isHasRecommendAdd": 0,
      "recommendAdd": 1,
      "imageList": [],
      "gender": 1,
      "sourceWebUrl": "http:\/\/bbs.77bike.com\/read.php?tid=301653"
    },
    {
      "board_id": 31,
      "topic_id": 301581,
      "title":
          "BMC SLR01\u789f \u6df1\u5ea6\u89e3\u6790 \uff08\u66f4\u65b0\u5b8c\u6bd5\uff09",
      "subject":
          "bmc 2020\u65b0\u6b3e\u6d82\u88c5\u8981\u51fa\u6765\u4e86\uff0c\u6240\u4ee5\u8001\u6b3e\u6d82\u88c5\u6e05\u8d27\u6253\u6298\u6e05\u8d27\u91cc\u552f\u4e00\u4e00\u4e2a ..",
      "user_id": 52,
      "last_reply_date": "1561645105000",
      "user_nick_name": "\u5149\u5149",
      "hits": 1582,
      "replies": 65,
      "status": 0,
      "essence": 1,
      "top": 0,
      "hot": 1,
      "vote": 0,
      "type": "normal",
      "pic_path":
          "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/mobcentSmallPreview\/Mon_1906\/31_52_f47c68e8112075b.jpg",
      "ratio": "1",
      "userAvatar": "http:\/\/bbs.77bike.com\/attachment\/upload\/52\/52.jpg",
      "isHasRecommendAdd": 0,
      "recommendAdd": 0,
      "imageList": [],
      "gender": 0,
      "sourceWebUrl": "http:\/\/bbs.77bike.com\/read.php?tid=301581"
    },
    {
      "board_id": 51,
      "topic_id": 301015,
      "title": "\u8001\u53f8\u673a\u6559\u4f60\u5982\u4f55\u9009\u5ea7\u57ab",
      "subject":
          " \u7ecf\u5e38\u770b\u5230\u65b0\u4eba\u95ee\u4ec0\u4e48\u5ea7\u57ab\u8212\u670d\uff0c\u8fd9\u57fa\u672c\u4e0a\u4e5f\u662f\u6708\u7ecf\u95ee\u9898\u4e86\uff0c\u5f88\u591a\u65f6 ..",
      "user_id": 1,
      "last_reply_date": "1559527547000",
      "user_nick_name": "azuretears",
      "hits": 426,
      "replies": 33,
      "status": 0,
      "essence": 1,
      "top": 1,
      "hot": 1,
      "vote": 0,
      "type": "normal",
      "pic_path":
          "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/mobcentSmallPreview\/Mon_1905\/51_1_1fbe05fed2bf8bd.jpg",
      "ratio": "1",
      "userAvatar":
          "http:\/\/www.77bike.com\/bbs\/attachment\/upload\/1.gif?1402372791?1402382899?1411873017?1411873063?1466395681?1466396156?1473136039",
      "isHasRecommendAdd": 0,
      "recommendAdd": 0,
      "imageList": [],
      "gender": 1,
      "sourceWebUrl": "http:\/\/bbs.77bike.com\/read.php?tid=301015"
    },
    {
      "board_id": 2,
      "topic_id": 300965,
      "title":
          "\u540e\u62e8\u4e0e\u6307\u62e8\/\u624b\u53d8\u7684\u6df7\u642d\u3001\u517c\u5bb9\u6027\u7b80\u8868",
      "subject":
          "\u7ecf\u5e38\u6709\u4eba\u575b\u5185\u95ee\u540e\u62e8\u548c\u6307\u62e8\/\u624b\u53d8\u7684\u517c\u5bb9\u6027\u95ee\u9898\uff0c\u5df2\u662f\u65e5\u5e38\u3002\u2014\u2014\u8fd9 ..",
      "user_id": 132275,
      "last_reply_date": "1560213296000",
      "user_nick_name": "\u8d85\u7ebf\u7a0b\u8c47\u8c46\u7537",
      "hits": 529,
      "replies": 29,
      "status": 0,
      "essence": 1,
      "top": 1,
      "hot": 1,
      "vote": 0,
      "type": "normal",
      "pic_path":
          "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/mobcentSmallPreview\/Mon_1906\/2_1_661d78090a00cac.gif",
      "ratio": "1",
      "userAvatar":
          "http:\/\/bbs.77bike.com\/attachment\/photo\/Mon_1502\/4310_1a5414249426767201d2f5bbb5398.jpg",
      "isHasRecommendAdd": 0,
      "recommendAdd": 3,
      "imageList": [],
      "gender": 0,
      "sourceWebUrl": "http:\/\/bbs.77bike.com\/read.php?tid=300965"
    },
    {
      "board_id": 13,
      "topic_id": 300856,
      "title": "\u5c0f\u5e03\u6b66\u5cad\u884c",
      "subject":
          "\u96be\u5f97\u6709\u7ec4\u7ec7\u4e13\u4e3a\u5c0f\u5e03\u6765\u6b21\u722c\u6b66\u5cad\u7684\u6d3b\u52a8\uff0c\u8d81\u7740\u966a\u6bcd\u63a2\u4eb2\u7684\u673a\u4f1a\u62bd\u51fa\u70b9 ..",
      "user_id": 25596,
      "last_reply_date": "1561081258000",
      "user_nick_name": "\u6ce2\u97f3747",
      "hits": 627,
      "replies": 33,
      "status": 0,
      "essence": 1,
      "top": 0,
      "hot": 1,
      "vote": 0,
      "type": "normal",
      "pic_path":
          "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/mobcentSmallPreview\/Mon_1905\/13_25596_51a0122117763f8.jpg",
      "ratio": "1",
      "userAvatar":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/96\/25596.jpg",
      "isHasRecommendAdd": 0,
      "recommendAdd": 1,
      "imageList": [],
      "gender": 1,
      "sourceWebUrl": "http:\/\/bbs.77bike.com\/read.php?tid=300856"
    },
    {
      "board_id": 48,
      "topic_id": 300687,
      "title":
          "\u5e74\u524d\u4e70\u4e86\u4e2a\u5947\u745e\u738b\uff0c\u4e00\u76f4\u6ca1\u65f6\u95f4\u53d1",
      "subject":
          "\u6ca1\u5565\u8bf4\u7684\uff0c\u4e70\u7684\u4e8c\u624b\uff0c\u7b2c\u4e00\u4efb\u8f66\u4e3b\u5c31\u5f00\u4e861\u5e74\u96f62\u4e2a\u6708\u4e0d\u5230\uff0c\u5c31\u8981\u63622. ..",
      "user_id": 9732,
      "last_reply_date": "1558702273000",
      "user_nick_name": "mindflayer",
      "hits": 444,
      "replies": 31,
      "status": 0,
      "essence": 1,
      "top": 0,
      "hot": 1,
      "vote": 0,
      "type": "normal",
      "pic_path": "",
      "ratio": "1",
      "userAvatar": "http:\/\/bbs.77bike.com\/attachment\/upload\/32\/9732.jpg",
      "isHasRecommendAdd": 0,
      "recommendAdd": 1,
      "imageList": [],
      "gender": 1,
      "sourceWebUrl": "http:\/\/bbs.77bike.com\/read.php?tid=300687"
    },
    {
      "board_id": 13,
      "topic_id": 300153,
      "title":
          "2019\u5e741-4\u6708 \u9a91\u6e38\u6d3b\u52a8\u603b\u7ed3\uff08\u66f4\u65b0\u5b8c\u6bd5\uff09",
      "subject":
          "2019\u5e741\u67085\u53f7\u5e7f\u5ddebrm300 \u8fd9\u6b21\u7684\u5267\u60c5\u8c01\u4e5f\u610f\u6599\u4e0d\u5230\u3002  \u96be\u5f97\u4e0d\u4e0b\u96e8 ..",
      "user_id": 52,
      "last_reply_date": "1561206563000",
      "user_nick_name": "\u5149\u5149",
      "hits": 1172,
      "replies": 56,
      "status": 0,
      "essence": 1,
      "top": 0,
      "hot": 1,
      "vote": 0,
      "type": "normal",
      "pic_path":
          "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/mobcentSmallPreview\/Mon_1905\/13_52_788121688a80fa2.jpg",
      "ratio": "1",
      "userAvatar": "http:\/\/bbs.77bike.com\/attachment\/upload\/52\/52.jpg",
      "isHasRecommendAdd": 0,
      "recommendAdd": 3,
      "imageList": [],
      "gender": 0,
      "sourceWebUrl": "http:\/\/bbs.77bike.com\/read.php?tid=300153"
    },
    {
      "board_id": 2,
      "topic_id": 300113,
      "title":
          "\u8df3\u7968\u597d\u51e0\u5e74\u7684\u795e\u8f66Helix\u7ec8\u4e8e\u51fa\u8d27\u4e86~",
      "subject":
          "\u5982\u9898\uff0c\u52a0\u62ff\u5927\u7684\u597d\u51e0\u5e74\u524d\u7684Helix\u4f17\u7b79\u6298\u53e0\u8f66\uff0c\u6700\u8fd1\u56fd\u5916\u624d\u6709\u7528\u6237\u6536 ..",
      "user_id": 160806,
      "last_reply_date": "1559193685000",
      "user_nick_name": "1\u5e261\u8def",
      "hits": 3027,
      "replies": 85,
      "status": 0,
      "essence": 1,
      "top": 0,
      "hot": 1,
      "vote": 0,
      "type": "normal",
      "pic_path": "",
      "ratio": "1",
      "userAvatar":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/06\/160806.jpg",
      "isHasRecommendAdd": 0,
      "recommendAdd": 0,
      "imageList": [],
      "gender": 0,
      "sourceWebUrl": "http:\/\/bbs.77bike.com\/read.php?tid=300113"
    },
    {
      "board_id": 13,
      "topic_id": 300064,
      "title": "\u5c9b\u6ce2\u6d77\u9053\u968f\u6e38\u8bb0",
      "subject":
          "\u4ee5\u524d\u5728\u8bba\u575b\u4e0a\u770b\u5230\u4e00\u7bc7\u5c11\u7237\u5199\u7684\u5c9b\u6ce2\u6d77\u9053\u6e38\u8bb0\u5c31\u4e00\u76f4\u60e6\u8bb0\u5728\u5fc3\u91cc\uff0c\u6b63 ..",
      "user_id": 146975,
      "last_reply_date": "1560996983000",
      "user_nick_name": "ericchen",
      "hits": 543,
      "replies": 45,
      "status": 0,
      "essence": 1,
      "top": 0,
      "hot": 1,
      "vote": 0,
      "type": "normal",
      "pic_path": "",
      "ratio": "1",
      "userAvatar":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/75\/146975.jpg",
      "isHasRecommendAdd": 0,
      "recommendAdd": 0,
      "imageList": [],
      "gender": 1,
      "sourceWebUrl": "http:\/\/bbs.77bike.com\/read.php?tid=300064"
    },
    {
      "board_id": 2,
      "topic_id": 299911,
      "title":
          "\u56fe\u89e3\u5927\u884cODA\u8f66\u67b6\u524d\u534a\u90e8\u5206",
      "subject":
          "\u6b7b\u80a5\u5b85\u7684\u5047\u671f\uff0c\u5c31\u662f\u8fd9\u4e48\u7684\u65e0\u804a\uff0c\u56de\u60f3ODA\u7684\u88c5\u8f66\u8fc7\u7a0b\uff0c\u611f\u89c9\u5934\u7ba1\u7897 ..",
      "user_id": 160806,
      "last_reply_date": "1557044424000",
      "user_nick_name": "1\u5e261\u8def",
      "hits": 934,
      "replies": 44,
      "status": 0,
      "essence": 1,
      "top": 0,
      "hot": 1,
      "vote": 0,
      "type": "normal",
      "pic_path": "",
      "ratio": "1",
      "userAvatar":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/06\/160806.jpg",
      "isHasRecommendAdd": 0,
      "recommendAdd": 0,
      "imageList": [],
      "gender": 0,
      "sourceWebUrl": "http:\/\/bbs.77bike.com\/read.php?tid=299911"
    },
    {
      "board_id": 2,
      "topic_id": 299897,
      "title":
          "[Android]\u9ed1\u84dd\u9e1f\u88c5\u8f66\uff0c\u8017\u65f6\u4e09\u4e2a\u6708\u7ec8\u63a5\u8fd1\u5b8c\u6210\uff0c\u94f6\u9e1f\u7ee7\u7eed......",
      "subject":
          "\u5148\u4e0a\u5f20\u6574\u8f66\u56fe\u3002\u611f\u8c22e\u65cf\u5355\u8f66\u9ed1\u96e8\u7684\u4ed8\u51fa\uff0c\u88c5\u8f66\u8c03\u8bd5\u8ffd\u6c42\u5b8c\u7f8e\u7ec6\u8282\uff0c ..",
      "user_id": 141874,
      "last_reply_date": "1560216976000",
      "user_nick_name": "zuobianvrt",
      "hits": 2029,
      "replies": 99,
      "status": 0,
      "essence": 1,
      "top": 0,
      "hot": 1,
      "vote": 0,
      "type": "normal",
      "pic_path":
          "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/mobcentSmallPreview\/Mon_1904\/2_141874_8f043762bfb8782.jpg",
      "ratio": "1",
      "userAvatar":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/74\/141874.jpg",
      "isHasRecommendAdd": 0,
      "recommendAdd": 0,
      "imageList": [],
      "gender": 0,
      "sourceWebUrl": "http:\/\/bbs.77bike.com\/read.php?tid=299897"
    },
    {
      "board_id": 48,
      "topic_id": 299670,
      "title": "#My Grand Commander#",
      "subject":
          "\u9996\u5148\u4e0a\u56fe\u9547\u697c~\u5e7f\u6c7d\u83f2\u4e9a\u7279\u514b\u83b1\u65af\u52d2JEEP\u5927\u6307\u6325\u5b98\uff08\u597d\u957f -_-\uff09\u65e7\u8f66 ..",
      "user_id": 139590,
      "last_reply_date": "1556613684000",
      "user_nick_name": "\u8001\u54f6",
      "hits": 878,
      "replies": 88,
      "status": 0,
      "essence": 1,
      "top": 0,
      "hot": 1,
      "vote": 0,
      "type": "normal",
      "pic_path":
          "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/mobcentSmallPreview\/Mon_1904\/48_139590_bbe75a7a0ceb110.jpg",
      "ratio": "1",
      "userAvatar":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/90\/139590.jpg",
      "isHasRecommendAdd": 0,
      "recommendAdd": 1,
      "imageList": [],
      "gender": 1,
      "sourceWebUrl": "http:\/\/bbs.77bike.com\/read.php?tid=299670"
    },
    {
      "board_id": 2,
      "topic_id": 299267,
      "title":
          "[Android]\u5168\u949b20\u5468\u5e74\u914d\u8272\u5c0f\u91d1\u5e03\u6765\u4e86",
      "subject":
          "\u6ca1\u9519\u5c31\u662f\u5b9d\u9e21\u949b\u3002\u7ec8\u4e8e\u7ec8\u4e8e\u6539\u9020\u5b8c\u6210\uff0c\u518d\u6b21\u611f\u8c22\u6781\u9650\u7684\u5404\u79cd\u795e\u64cd\u4f5c\u3002 ..",
      "user_id": 162577,
      "last_reply_date": "1556695576000",
      "user_nick_name": "hannibar",
      "hits": 1838,
      "replies": 60,
      "status": 0,
      "essence": 1,
      "top": 0,
      "hot": 1,
      "vote": 0,
      "type": "normal",
      "pic_path":
          "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/mobcentSmallPreview\/Mon_1904\/2_162577_4ec548cb30965c3.jpg",
      "ratio": "1",
      "userAvatar":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/77\/162577.jpg",
      "isHasRecommendAdd": 0,
      "recommendAdd": 1,
      "imageList": [],
      "gender": 1,
      "sourceWebUrl": "http:\/\/bbs.77bike.com\/read.php?tid=299267"
    },
    {
      "board_id": 2,
      "topic_id": 299188,
      "title":
          "alex moulont gt \u653918\u5bf8\uff08355\uff09\u521d\u843d\u5730",
      "subject":
          "\u4ece\u8f66\u67b6\u5165\u624b\uff0c\u5230\u521d\u6b65\u843d\u5730\uff0c\u524d\u540e\u82b1\u4e86\u8fd12\u4e2a\u6708\u65f6\u95f4\u3002\u81ea\u4ee5\u4e3a\u73a9\u4e86\u8fd9\u4e48 ..",
      "user_id": 34078,
      "last_reply_date": "1561093132000",
      "user_nick_name": "\u559d\u6c34\u7684\u7816\u5757",
      "hits": 1526,
      "replies": 53,
      "status": 0,
      "essence": 1,
      "top": 0,
      "hot": 1,
      "vote": 0,
      "type": "normal",
      "pic_path":
          "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/mobcentSmallPreview\/Mon_1904\/2_34078_58a02e253734a6b.jpg",
      "ratio": "1",
      "userAvatar":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/78\/34078.jpg",
      "isHasRecommendAdd": 0,
      "recommendAdd": 1,
      "imageList": [],
      "gender": 0,
      "sourceWebUrl": "http:\/\/bbs.77bike.com\/read.php?tid=299188"
    },
    {
      "board_id": 48,
      "topic_id": 298606,
      "title": "[Android]\u7b49\u4e0a\u724c",
      "subject":
          "\u628a\u65e7\u7684\u5b9d\u9a8f730\u5356\u4e86\uff0c\u8d37\u6b3e\u6362\u4e86\u8fd9\u53f0\u6765\u81ea[Android]\u624b\u673a\u5ba2\u6237\u7aef",
      "user_id": 164223,
      "last_reply_date": "1554992180000",
      "user_nick_name": "sdlwy111",
      "hits": 562,
      "replies": 27,
      "status": 0,
      "essence": 1,
      "top": 0,
      "hot": 1,
      "vote": 0,
      "type": "normal",
      "pic_path":
          "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/mobcentSmallPreview\/Mon_1903\/48_164223_8cbd9b78f71287a.jpg",
      "ratio": "1",
      "userAvatar": "http:\/\/bbs.77bike.com\/images\/face\/none.gif",
      "isHasRecommendAdd": 0,
      "recommendAdd": 1,
      "imageList": [],
      "gender": 0,
      "sourceWebUrl": "http:\/\/bbs.77bike.com\/read.php?tid=298606"
    },
    {
      "board_id": 48,
      "topic_id": 298371,
      "title": "\u63d0\u4e86CRV\u3002\u3002\u3002",
      "subject":
          "19\u6b3e1.5T\u98ce\u5c1a\u7248\uff0c\u56fd5\uff0c\u843d\u5730215000\uff0c50%\u5206\u671f\uff0c\u4e24\u5e74\u514d\u606f\u572877\u5c31\u4e0d\u5e9f ..",
      "user_id": 30484,
      "last_reply_date": "1553794772000",
      "user_nick_name": "warpblade",
      "hits": 1255,
      "replies": 73,
      "status": 0,
      "essence": 1,
      "top": 0,
      "hot": 1,
      "vote": 0,
      "type": "normal",
      "pic_path":
          "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/mobcentSmallPreview\/Mon_1903\/48_30484_22824bfdb69e95f.jpg",
      "ratio": "1",
      "userAvatar":
          "http:\/\/www.77bike.com\/bbs\/attachment\/5_30484_66df2110032a380.jpg",
      "isHasRecommendAdd": 0,
      "recommendAdd": 2,
      "imageList": [],
      "gender": 1,
      "sourceWebUrl": "http:\/\/bbs.77bike.com\/read.php?tid=298371"
    },
    {
      "board_id": 5,
      "topic_id": 298295,
      "title":
          "[iPhone]\u4e0d\u591f\u5feb\u4e00\u5b9a\u662f\u8f66\u7684\u95ee\u9898",
      "subject":
          "\u5973\u513f\u4ece\u53bb\u5e74\u5f00\u59cb\u73a9\u6ed1\u6b65\u8f66\uff0c\u4e00\u5f00\u59cb\u7528\u7684\u662f\u8fea\u5361\u4fac\u7684\u5165\u95e8\u6b3e\uff0c\u5148\u4f53\u9a8c\u4e00 ..",
      "user_id": 14303,
      "last_reply_date": "1556695978000",
      "user_nick_name": "E.June",
      "hits": 1111,
      "replies": 43,
      "status": 0,
      "essence": 1,
      "top": 0,
      "hot": 1,
      "vote": 0,
      "type": "normal",
      "pic_path": "",
      "ratio": "1",
      "userAvatar":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/03\/14303.jpg",
      "isHasRecommendAdd": 0,
      "recommendAdd": 2,
      "imageList": [],
      "gender": 0,
      "sourceWebUrl": "http:\/\/bbs.77bike.com\/read.php?tid=298295"
    }
  ],
  "page": 1,
  "has_next": 1,
  "total_num": 917
};
*/
