/*
accessSecret	f01b3418e99ebdc5fda5fa3b8b9c2
accessToken	ac3f19b94085e3b86c228b54f71c7
apphash	9425b1e8
boardId	24
forumKey	itTovrNYj6jgmwUBcQ
order	0
page	2
pageSize	10
sdkVersion	2.4.0
topicId	302083
*/

import 'package:jaguar_serializer/jaguar_serializer.dart';

import '../common.dart';

part 'forum_postlist.jser.dart';

class PostListAction {
  static const String action = "forum/postlist";
  static const int orderByAsc = 0;
  static const int orderByDesc = 1;

  static Map<String, dynamic> buildRequest(
      {int topicId, int authorId = 0, int page = 1, int order = orderByAsc}) {
    assert(topicId != null);
    assert(page != null && page > 0);
    return {
      "topicId": topicId,
      "authorId": authorId,
      "order": order,
      "page": page,
      "pageSize": 10
    };
  }

  static PostListResponse parseResponse(Map<String, dynamic> response) {
    return PostListResponseSerializer().fromMap(response);
  }
}

class PostListResponse extends MobcentResponse {
  String boardId;
  String forumName;

  /// 主贴(当分页显示时,仅首页返回此属性,其它页面不返回此属性)
  PostTopic topic;

  List<PostReply> list;

  String img_url;

  String forumTopicUrl; // full url

  int page;
  int has_next; // 0=无
  int total_num; // 回帖总数(含主题帖)
}

class PostTopic {
  dynamic activityInfo;

  List<PostContent> content;

  String create_date; // "1562774343000"

  DateTime get create_date_value =>
      DateTime.fromMillisecondsSinceEpoch(int.tryParse(this.create_date));

  /// 是否为精华帖
  int essence;

  List<ExtraPanel> extraPanel;

  /// 不是拼写错误!!!
  int falg;

  int gender;

  /// 查看数
  int hits;

  /// full url
  String icon;

  int is_favor;

  num level;

  String location;

  String mobileSign;

  /// 评分列表
  RateList rateList;

  /// 回帖数
  int replies;

  /// ?
  int reply_posts_id;

  /// ?
  int reply_status;

  /// 分类编号(?)
  int sortId;

  int status;

  /// 帖子主题
  String title;

  /// 帖子编号
  int topic_id;

  /// normal
  String type;

  /// 用户级别名称
  String userTitle;

  /// 用户昵称
  String user_nick_name;

  /// 用户编号
  int user_id;
}

class RateList {
  String ping;

  RateListHead head;

  List<RateListBody> body;

  /// http://bbs.77bike.com/mobcent/app/web/index.php?r=forum/ratelistview&fid=48&tid=299670&sdkVersion=2.4.0&accessToken=ac3f19b94085e3b86c228b54f71c7&accessSecret=f01b3418e99ebdc5fda5fa3b8b9c2
  String showAllUrl;
}

class RateListHead {
  /// field1=共4条评分
  String field1;

  /// field2=金钱+17,威望+12,
  String field2;

  RateListHead({this.field1, this.field2});
}

class RateListBody {
  /// 评分人用户名称
  String field1;

  /// field2=威望 +7
  String field2;

  /// 日期
  String field3;
}

class ExtraPanel {
  /// 扩展操作url
  String action;

  /// 扩展操作名称
  /// 评分, 赞
  String title;

  /// 扩展操作类型
  /// rate = 评分: http://bbs.77bike.com/mobcent/app/web/index.php?r=forum/topicrate&sdkVersion=2.4.0.1&accessToken=ac3f19b94085e3b86c228b54f71c7&accessSecret=f01b3418e99ebdc5fda5fa3b8b9c2&tid=302098&fid=2&act=ping&pid=tpc&type=ping
  /// support = 赞 : http://bbs.77bike.com/mobcent/app/web/index.php?r=forum/support&sdkVersion=2.4.0.1&accessToken=ac3f19b94085e3b86c228b54f71c7&accessSecret=f01b3418e99ebdc5fda5fa3b8b9c2&tid=302098&fid=2&act=dig&pid=&type=topic
  String type;

  Map<String, dynamic> extParams;
}

class PostContent {
  /// 附件编号(type=1时设置)
  int aid;

  /// 内容信息
  /// type = 0 时为内容
  /// type = 1 时为附件完整路径
  String infor;

  /// 附件路径(type=1时设置)
  String originalInfo;

  /// 内容类型
  /// 0 = 文本
  /// 1 = 图片
  /// 4 = @
  int type;

  PostContent({this.aid, this.infor, this.originalInfo, this.type});
}

class PostReply {
  int gender;

  num level;

  String location;

  /// 用户头像
  /// full url
  String icon;

  /// 回帖楼层数
  int position;

  /// 回帖时间
  /// "1556078344000"
  String posts_date;

  DateTime get posts_date_value =>
      DateTime.fromMillisecondsSinceEpoch(int.tryParse(this.posts_date));

  String mobileSign;

  /// 是否引用了回帖
  int is_quote;

  /// 引用回帖编号
  /// 当前未返回("")
  dynamic quote_pid;

  /// 引用的回帖内容
  String quote_content;

  /// 引用的回帖人名称
  String quote_user_name;

  /// 回帖内容
  List<PostContent> reply_content;

  /// 回帖用户编号
  int reply_id;

  /// 回帖用户名称
  String reply_name;

  /// 回帖记录编号
  int reply_posts_id;

  /// ???
  int reply_status;

  /// normal
  String reply_type;

  int status;

  /// 回帖标题(不需要显示,可能为空)
  String title;

  /// 用户级别名称(头衔)
  String userTitle;

  dynamic role_num;
}

@GenSerializer()
class PostListResponseSerializer extends Serializer<PostListResponse>
    with _$PostListResponseSerializer {}

@GenSerializer()
class PostTopicSerializer extends Serializer<PostTopic>
    with _$PostTopicSerializer {}

@GenSerializer()
class RateListSerializer extends Serializer<RateList>
    with _$RateListSerializer {}

@GenSerializer()
class RateListHeadSerializer extends Serializer<RateListHead>
    with _$RateListHeadSerializer {}

@GenSerializer()
class RateListBodySerializer extends Serializer<RateListBody>
    with _$RateListBodySerializer {}

@GenSerializer()
class ExtraPanelSerializer extends Serializer<ExtraPanel>
    with _$ExtraPanelSerializer {}

@GenSerializer()
class PostContentSerializer extends Serializer<PostContent>
    with _$PostContentSerializer {}

@GenSerializer()
class PostReplySerializer extends Serializer<PostReply>
    with _$PostReplySerializer {}

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
  "forumName": "\u63d0\u95ee\u89e3\u7b54",
  "boardId": "24",
  "list": [
    {
      "mobileSign": "",
      "userTitle": "\u9ad8\u4e00",
      "gender": 1,
      "level": 2.09125,
      "location": "",
      "icon":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/61\/164061.jpg",
      "posts_date": "1562647648000",
      "reply_content": [
        {
          "infor":
              "1618\u539f\u751f\u662f349\u8f6e\u7ec4\uff1f\r\n\r\n\u6765\u81ea[Android]\u624b\u673a\u5ba2\u6237\u7aef",
          "type": 0
        }
      ],
      "reply_id": 164061,
      "reply_status": 1,
      "reply_name": "\u9a91\u8ff9\u5929\u6daf",
      "reply_posts_id": 4961441,
      "status": 1,
      "title": "",
      "role_num": "",
      "is_quote": 0,
      "quote_pid": "",
      "quote_content": "",
      "quote_user_name": "",
      "position": 10,
      "reply_type": "normal",
      "managePanel": [],
      "extraPanel": []
    },
    {
      "mobileSign": "",
      "userTitle": "\u9ad8\u4e8c",
      "gender": 1,
      "level": 3.725,
      "location": "",
      "icon":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/34\/63734.jpg",
      "posts_date": "1562648331000",
      "reply_content": [
        {
          "infor":
              "\r\n\u6709\u8fd9\u4e2a\u7248\u672c\r\n\r\n\u6765\u81ea[iPhone]\u624b\u673a\u5ba2\u6237\u7aef",
          "type": 0
        }
      ],
      "reply_id": 63734,
      "reply_status": 1,
      "reply_name": "zengdh",
      "reply_posts_id": 4961444,
      "status": 1,
      "title": "",
      "role_num": "",
      "is_quote": 1,
      "quote_pid": "",
      "quote_content":
          "\u9a91\u8ff9\u5929\u6daf:1618\u539f\u751f\u662f349\u8f6e\u7ec4\uff1f\n (2019-07-09 12:47) ",
      "quote_user_name": "\u9a91\u8ff9\u5929\u6daf",
      "position": 11,
      "reply_type": "normal",
      "managePanel": [],
      "extraPanel": []
    },
    {
      "mobileSign": "",
      "userTitle": "\u9ad8\u4e00",
      "gender": 0,
      "level": 3.2025,
      "location": "",
      "icon": "http:\/\/bbs.77bike.com\/images\/face\/none.gif",
      "posts_date": "1562651227000",
      "reply_content": [
        {
          "infor":
              "\u96be\u5f97\u7684\u539f\u751f349\u5e2e\u9876\u3002\r\n\u6211\u6709\u5e8a\u54e5\u62e8\u63d240cm\u7684\uff0c\u53ef\u81ea\u884c\u622a\u7ba1\u957f\u77ed\u3002\r\n\u4f60\u53ef\u4ee5\u7528\u4f60\u768431.5\u8ddf\u6211\u6362\u3002\u8865\u6211\u5dee\u4ef7\u3002\r\n",
          "type": 0
        },
        {
          "infor":
              "http:\/\/bbs.77bike.com\/attachment\/thumb\/Mon_1907\/24_162305_3b88d40cdd107ed.jpg",
          "originalInfo":
              "http:\/\/bbs.77bike.com\/attachment\/thumb\/Mon_1907\/24_162305_3b88d40cdd107ed.jpg",
          "aid": 1332001,
          "type": 1
        },
        {
          "infor": "\r\n\u6765\u81ea[Android]\u624b\u673a\u5ba2\u6237\u7aef",
          "type": 0
        }
      ],
      "reply_id": 162305,
      "reply_status": 1,
      "reply_name": "\u7f1d\u4e2d\u9c7c",
      "reply_posts_id": 4961449,
      "status": 1,
      "title": "",
      "role_num": "",
      "is_quote": 0,
      "quote_pid": "",
      "quote_content": "",
      "quote_user_name": "",
      "position": 12,
      "reply_type": "normal",
      "managePanel": [],
      "extraPanel": []
    },
    {
      "mobileSign": "",
      "userTitle": "\u9ad8\u4e8c",
      "gender": 1,
      "level": 3.725,
      "location": "",
      "icon":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/34\/63734.jpg",
      "posts_date": "1562654118000",
      "reply_content": [
        {
          "infor":
              "\r\n\u4e0d\u559c\u6b22\u62d4\u51fa\u7684\u5934\u7ba1\r\n\r\n\u6765\u81ea[iPhone]\u624b\u673a\u5ba2\u6237\u7aef",
          "type": 0
        }
      ],
      "reply_id": 63734,
      "reply_status": 1,
      "reply_name": "zengdh",
      "reply_posts_id": 4961453,
      "status": 1,
      "title": "",
      "role_num": "",
      "is_quote": 1,
      "quote_pid": "",
      "quote_content":
          "\u7f1d\u4e2d\u9c7c:\u96be\u5f97\u7684\u539f\u751f349\u5e2e\u9876\u3002\n\u6211\u6709\u5e8a\u54e5\u62e8\u63d240cm\u7684\uff0c\u53ef\u81ea\u884c\u622a\u7ba1\u957f\u77ed\u3002\n\u4f60\u53ef\u4ee5\u7528\u4f60\u768431.5\u8ddf\u6211\u6362\u3002\u8865\u6211\u5dee\u4ef7\u3002\n (2019-07-09 13:47) ",
      "quote_user_name": "\u7f1d\u4e2d\u9c7c",
      "position": 13,
      "reply_type": "normal",
      "managePanel": [],
      "extraPanel": []
    },
    {
      "mobileSign": "",
      "userTitle": "\u9ad8\u4e8c",
      "gender": 1,
      "level": 3.725,
      "location": "",
      "icon":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/34\/63734.jpg",
      "posts_date": "1562654150000",
      "reply_content": [
        {
          "infor":
              "\r\n\u80fd\u5426\u5e2e\u5fd9\u91cf\u4e00\u4e0b\uff0c37\u7684\u5408\u9002\u5426\r\n\r\n\u6765\u81ea[iPhone]\u624b\u673a\u5ba2\u6237\u7aef",
          "type": 0
        }
      ],
      "reply_id": 63734,
      "reply_status": 1,
      "reply_name": "zengdh",
      "reply_posts_id": 4961454,
      "status": 1,
      "title": "",
      "role_num": "",
      "is_quote": 1,
      "quote_pid": "",
      "quote_content":
          "\u7f1d\u4e2d\u9c7c:\u96be\u5f97\u7684\u539f\u751f349\u5e2e\u9876\u3002\n\u6211\u6709\u5e8a\u54e5\u62e8\u63d240cm\u7684\uff0c\u53ef\u81ea\u884c\u622a\u7ba1\u957f\u77ed\u3002\n\u4f60\u53ef\u4ee5\u7528\u4f60\u768431.5\u8ddf\u6211\u6362\u3002\u8865\u6211\u5dee\u4ef7\u3002\n (2019-07-09 13:47) ",
      "quote_user_name": "\u7f1d\u4e2d\u9c7c",
      "position": 14,
      "reply_type": "normal",
      "managePanel": [],
      "extraPanel": []
    },
    {
      "mobileSign": "",
      "userTitle": "\u5c0f\u5b66\u516d\u5e74\u7ea7",
      "gender": 1,
      "level": 1.82375,
      "location": "",
      "icon":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/80\/162080.jpg",
      "posts_date": "1562679858000",
      "reply_content": [
        {
          "infor":
              "\u6362\u4e2a\u5927\u884c\u5347\u964d\u5934\u7ba1\u54af\uff0c\u6211\u90fd\u6362\u4e86\uff0c\u60f3\u60a0\u95f2\u70b9\u5c31\u5347\u9ad8\u70b9\uff0c\u60f3\u901f\u5ea6\u5feb\u65f6\u5c31\u964d\u4f4e\u70b9\r\n",
          "type": 0
        },
        {
          "infor":
              "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/24_162080_2a4457bb68cb43e.jpg",
          "originalInfo":
              "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/24_162080_2a4457bb68cb43e.jpg",
          "aid": 1332012,
          "type": 1
        },
        {
          "infor": "\r\n\u6765\u81ea[Android]\u624b\u673a\u5ba2\u6237\u7aef",
          "type": 0
        }
      ],
      "reply_id": 162080,
      "reply_status": 1,
      "reply_name": "mark1983",
      "reply_posts_id": 4961500,
      "status": 1,
      "title": "",
      "role_num": "",
      "is_quote": 0,
      "quote_pid": "",
      "quote_content": "",
      "quote_user_name": "",
      "position": 15,
      "reply_type": "normal",
      "managePanel": [],
      "extraPanel": []
    },
    {
      "mobileSign": "",
      "userTitle": "\u9ad8\u4e09",
      "gender": 1,
      "level": 3.97,
      "location": "",
      "icon":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/74\/19374.jpg",
      "posts_date": "1562723479000",
      "reply_content": [
        {
          "infor":
              "\r\n\u94f6\u8272\u6362\u4e48\uff1f\r\n\r\n\u6765\u81ea[Android]\u624b\u673a\u5ba2\u6237\u7aef",
          "type": 0
        }
      ],
      "reply_id": 19374,
      "reply_status": 1,
      "reply_name": "aishangyu",
      "reply_posts_id": 4961530,
      "status": 1,
      "title": "",
      "role_num": "",
      "is_quote": 1,
      "quote_pid": "",
      "quote_content":
          "\u7f1d\u4e2d\u9c7c:\u96be\u5f97\u7684\u539f\u751f349\u5e2e\u9876\u3002\n\u6211\u6709\u5e8a\u54e5\u62e8\u63d240cm\u7684\uff0c\u53ef\u81ea\u884c\u622a\u7ba1\u957f\u77ed\u3002\n\u4f60\u53ef\u4ee5\u7528\u4f60\u768431.5\u8ddf\u6211\u6362\u3002\u8865\u6211\u5dee\u4ef7\u3002\n (2019-07-09 13:47) ",
      "quote_user_name": "\u7f1d\u4e2d\u9c7c",
      "position": 16,
      "reply_type": "normal",
      "managePanel": [],
      "extraPanel": []
    },
    {
      "mobileSign": "",
      "userTitle": "\u9ad8\u4e09",
      "gender": 1,
      "level": 3.97,
      "location": "",
      "icon":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/74\/19374.jpg",
      "posts_date": "1562723536000",
      "reply_content": [
        {
          "infor":
              "\r\n31.5\u53cc\u9489\u94f6\u8272\r\n\r\n\u6765\u81ea[Android]\u624b\u673a\u5ba2\u6237\u7aef",
          "type": 0
        }
      ],
      "reply_id": 19374,
      "reply_status": 1,
      "reply_name": "aishangyu",
      "reply_posts_id": 4961532,
      "status": 1,
      "title": "",
      "role_num": "",
      "is_quote": 1,
      "quote_pid": "",
      "quote_content":
          "\u7f1d\u4e2d\u9c7c:\u96be\u5f97\u7684\u539f\u751f349\u5e2e\u9876\u3002\n\u6211\u6709\u5e8a\u54e5\u62e8\u63d240cm\u7684\uff0c\u53ef\u81ea\u884c\u622a\u7ba1\u957f\u77ed\u3002\n\u4f60\u53ef\u4ee5\u7528\u4f60\u768431.5\u8ddf\u6211\u6362\u3002\u8865\u6211\u5dee\u4ef7\u3002\n (2019-07-09 13:47) ",
      "quote_user_name": "\u7f1d\u4e2d\u9c7c",
      "position": 17,
      "reply_type": "normal",
      "managePanel": [],
      "extraPanel": []
    }
  ],
  "img_url": "",
  "forumTopicUrl": "http:\/\/bbs.77bike.com\/m\/index.php?a=read&tid=302083",
  "page": 2,
  "has_next": 0,
  "total_num": 18
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
  "forumName": "\u6298\u53e0\u5c0f\u8f6e\u5f84",
  "boardId": "2",
  "topic": {
    "mobileSign": "",
    "userTitle": "\u5c0f\u5b66\u4e00\u5e74\u7ea7",
    "sortId": 71,
    "gender": 1,
    "level": 2.81,
    "location": "",
    "icon":
        "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/45\/164445.jpg",
    "create_date": "1562774343000",
    "content": [
      {
        "infor":
            "\u5e2e\u5fd9\u770b\u770b\u8fd9\u4e2a\u5927\u884ck3\r\n2200\u5305\u90ae\u503c\u4e0d\u503c\uff1f\r\n",
        "type": 0
      },
      {
        "infor":
            "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/2_164445_cdef99b293bb65c.png",
        "originalInfo":
            "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/2_164445_cdef99b293bb65c.png",
        "aid": 1332069,
        "type": 1
      },
      {
        "infor":
            "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/2_164445_520b5a9c5af7353.png",
        "originalInfo":
            "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/2_164445_520b5a9c5af7353.png",
        "aid": 1332070,
        "type": 1
      },
      {
        "infor": "\r\n\u6765\u81ea[Android]\u624b\u673a\u5ba2\u6237\u7aef",
        "type": 0
      }
    ],
    "user_id": 164445,
    "reply_status": 1,
    "hits": 16,
    "replies": 15,
    "essence": 0,
    "topic_id": 302098,
    "user_nick_name": "\u4e01\u54e5\u54e5",
    "reply_posts_id": 0,
    "title":
        "[\u8d44\u6599\u6570\u636e]\u8bf7\u5927\u5bb6\u5e2e\u5fd9\u770b\u770b\u3002",
    "status": 1,
    "is_favor": 0,
    "type": "normal",
    "falg": 0,
    "poll_info": null,
    "activityInfo": null,
    "managePanel": [],
    "extraPanel": [
      {
        "action":
            "http:\/\/bbs.77bike.com\/mobcent\/app\/web\/index.php?r=forum\/topicrate&sdkVersion=2.4.0.1&accessToken=ac3f19b94085e3b86c228b54f71c7&accessSecret=f01b3418e99ebdc5fda5fa3b8b9c2&tid=302098&fid=2&act=ping&pid=tpc&type=ping",
        "title": "\u8bc4\u5206",
        "type": "rate",
        "extParams": {" beforeAction": ""}
      },
      {
        "action":
            "http:\/\/bbs.77bike.com\/mobcent\/app\/web\/index.php?r=forum\/support&sdkVersion=2.4.0.1&accessToken=ac3f19b94085e3b86c228b54f71c7&accessSecret=f01b3418e99ebdc5fda5fa3b8b9c2&tid=302098&fid=2&act=dig&pid=&type=topic",
        "title": "\u8d5e",
        "type": "support",
        "extParams": {
          " beforeAction": "",
          "recommendAdd": 0,
          "isHasRecommendAdd": 0
        }
      }
    ],
    "rateList": {"ping": ""}
  },
  "list": [
    {
      "mobileSign": "",
      "userTitle": "\u535a\u58eb",
      "gender": 0,
      "level": 2.26,
      "location": "",
      "icon":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/05\/113805.jpg",
      "posts_date": "1562774513000",
      "reply_content": [
        {
          "infor":
              "\u5343\u91d1\u96be\u4e70\u6211\u559c\u6b22\r\n\r\n\u6765\u81ea[Android]\u624b\u673a\u5ba2\u6237\u7aef",
          "type": 0
        }
      ],
      "reply_id": 113805,
      "reply_status": 1,
      "reply_name": "a402969196",
      "reply_posts_id": 4961612,
      "status": 1,
      "title": "",
      "role_num": "",
      "is_quote": 0,
      "quote_pid": "",
      "quote_content": "",
      "quote_user_name": "",
      "position": 1,
      "reply_type": "normal",
      "managePanel": [],
      "extraPanel": []
    },
    {
      "mobileSign": "",
      "userTitle": "\u521d\u4e8c",
      "gender": 1,
      "level": 3.855,
      "location": "",
      "icon":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/64\/153064.jpg",
      "posts_date": "1562774634000",
      "reply_content": [
        {
          "infor":
              "\u5927\u884ck\u662f\u4ec0\u4e48\uff0c32200\u597d\u8d35\u5440\r\n\u624b\u52a8\u72d7\u5934[\u9634\u9669]\r\n\r\n\u6765\u81ea[Android]\u624b\u673a\u5ba2\u6237\u7aef",
          "type": 0
        }
      ],
      "reply_id": 153064,
      "reply_status": 1,
      "reply_name": "\u8c46\u5305\u5b50",
      "reply_posts_id": 4961613,
      "status": 1,
      "title": "",
      "role_num": "",
      "is_quote": 0,
      "quote_pid": "",
      "quote_content": "",
      "quote_user_name": "",
      "position": 2,
      "reply_type": "normal",
      "managePanel": [],
      "extraPanel": []
    },
    {
      "mobileSign": "",
      "userTitle": "\u535a\u58eb",
      "gender": 1,
      "level": 2.42096,
      "location": "",
      "icon":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/29\/125129.jpg",
      "posts_date": "1562775259000",
      "reply_content": [
        {
          "infor":
              "\u5c71\u5be8\u8f66\u67b6\u53ef\u80fd\u6027\u4e0d\u4f4e\r\n\r\n\u6765\u81ea[Android]\u624b\u673a\u5ba2\u6237\u7aef",
          "type": 0
        }
      ],
      "reply_id": 125129,
      "reply_status": 1,
      "reply_name": "ken564300317",
      "reply_posts_id": 4961615,
      "status": 1,
      "title": "",
      "role_num": "",
      "is_quote": 0,
      "quote_pid": "",
      "quote_content": "",
      "quote_user_name": "",
      "position": 3,
      "reply_type": "normal",
      "managePanel": [],
      "extraPanel": []
    },
    {
      "mobileSign": "",
      "userTitle": "\u9ad8\u4e00",
      "gender": 0,
      "level": 3.205,
      "location": "",
      "icon": "http:\/\/bbs.77bike.com\/images\/face\/none.gif",
      "posts_date": "1562778098000",
      "reply_content": [
        {
          "infor":
              "\u8fd9\u7259\u76d8\uff0c\u8fd8\u662f16\u5bf8\u3002\r\n\u9700\u8981\u6765\u95ee\u8fd9\u8f66\u80fd\u4e0d\u80fd\u4e70\u7684\u4eba\uff0c\u57fa\u672c\u8e29\u4e0d\u4e86\u3002\r\n\r\n\u6765\u81ea[Android]\u624b\u673a\u5ba2\u6237\u7aef",
          "type": 0
        }
      ],
      "reply_id": 162305,
      "reply_status": 1,
      "reply_name": "\u7f1d\u4e2d\u9c7c",
      "reply_posts_id": 4961617,
      "status": 1,
      "title": "",
      "role_num": "",
      "is_quote": 0,
      "quote_pid": "",
      "quote_content": "",
      "quote_user_name": "",
      "position": 4,
      "reply_type": "normal",
      "managePanel": [],
      "extraPanel": []
    },
    {
      "mobileSign": "",
      "userTitle": "\u521d\u4e00",
      "gender": 1,
      "level": 3.7425,
      "location": "",
      "icon":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/10\/163710.jpg",
      "posts_date": "1562778845000",
      "reply_content": [
        {
          "infor":
              "\r\n\u76ee\u6d4b58T\uff0c\u5e269-13-17\u59163\uff0c\u4e0d\u662f\u722c\u5c71\u8fd8\u53ef\u4ee5\uff0c\u5c31\u662f\u6015\u8f74\u8ddd\u592a\u77ed\u901f\u5ea6\u592a\u5feb\u4e0d\u7a33\r\n\r\n\u6765\u81ea[Android]\u624b\u673a\u5ba2\u6237\u7aef",
          "type": 0
        }
      ],
      "reply_id": 163710,
      "reply_status": 1,
      "reply_name": "gzleen",
      "reply_posts_id": 4961618,
      "status": 1,
      "title": "",
      "role_num": "",
      "is_quote": 1,
      "quote_pid": "",
      "quote_content":
          "\u7f1d\u4e2d\u9c7c:\u8fd9\u7259\u76d8\uff0c\u8fd8\u662f16\u5bf8\u3002\n\u9700\u8981\u6765\u95ee\u8fd9\u8f66\u80fd\u4e0d\u80fd\u4e70\u7684\u4eba\uff0c\u57fa\u672c\u8e29\u4e0d\u4e86\u3002\n (2019-07-11 01:01) ",
      "quote_user_name": "\u7f1d\u4e2d\u9c7c",
      "position": 5,
      "reply_type": "normal",
      "managePanel": [],
      "extraPanel": []
    },
    {
      "mobileSign": "",
      "userTitle": "\u9ad8\u4e8c",
      "gender": 0,
      "level": 3.24625,
      "location": "",
      "icon":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/93\/159793.jpg",
      "posts_date": "1562800216000",
      "reply_content": [
        {
          "infor":
              "\u8f66\u5934\u4e0d\u662f\u6709\u4e2a\u55f7\u5927\u55b5\u7684\u5934\u50cf\u4e48\r\n\r\n\u6765\u81ea[iPhone]\u624b\u673a\u5ba2\u6237\u7aef",
          "type": 0
        }
      ],
      "reply_id": 159793,
      "reply_status": 1,
      "reply_name": "\u718a\u5927\u7237",
      "reply_posts_id": 4961620,
      "status": 1,
      "title": "",
      "role_num": "",
      "is_quote": 0,
      "quote_pid": "",
      "quote_content": "",
      "quote_user_name": "",
      "position": 6,
      "reply_type": "normal",
      "managePanel": [],
      "extraPanel": []
    },
    {
      "mobileSign": "",
      "userTitle": "\u9ad8\u4e00",
      "gender": 1,
      "level": 2.5075,
      "location": "",
      "icon": "http:\/\/bbs.77bike.com\/images\/face\/none.gif",
      "posts_date": "1562802254000",
      "reply_content": [
        {
          "infor":
              "\u8fd9\u4ef7\u683c\u8fd8\u884c\r\n\r\n\u6765\u81ea[iPhone]\u624b\u673a\u5ba2\u6237\u7aef",
          "type": 0
        }
      ],
      "reply_id": 161736,
      "reply_status": 1,
      "reply_name": "sony85",
      "reply_posts_id": 4961622,
      "status": 1,
      "title": "",
      "role_num": "",
      "is_quote": 0,
      "quote_pid": "",
      "quote_content": "",
      "quote_user_name": "",
      "position": 7,
      "reply_type": "normal",
      "managePanel": [],
      "extraPanel": []
    },
    {
      "mobileSign": "",
      "userTitle": "\u535a\u58eb",
      "gender": 1,
      "level": 4.89808,
      "location": "",
      "icon":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/43\/12043.jpg",
      "posts_date": "1562804776000",
      "reply_content": [
        {
          "infor":
              "\u8fd9\u662f16\u7684\u8f6e\u5b50\u5427\uff0c\u7259\u76d8\u597d\u5927\u600e\u4e48\u8e29\r\n\r\n\u6765\u81ea[iPhone]\u624b\u673a\u5ba2\u6237\u7aef",
          "type": 0
        }
      ],
      "reply_id": 12043,
      "reply_status": 1,
      "reply_name": "\u7b80\u5355\u53c8\u660e\u4e86",
      "reply_posts_id": 4961626,
      "status": 1,
      "title": "",
      "role_num": "",
      "is_quote": 0,
      "quote_pid": "",
      "quote_content": "",
      "quote_user_name": "",
      "position": 8,
      "reply_type": "normal",
      "managePanel": [],
      "extraPanel": []
    },
    {
      "mobileSign": "",
      "userTitle": "\u9ad8\u4e00",
      "gender": 1,
      "level": 1.85625,
      "location": "",
      "icon":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/03\/155903.jpg",
      "posts_date": "1562808862000",
      "reply_content": [
        {
          "infor":
              "\u8d5e\u540c\u697c\u4e0a\uff0c\u5982\u679c\u6ca1\u6709\u94c1\u817f\u529f\uff0c\u901a\u52e446-48\u8db3\u591f\u4e86\u3002\u5168\u65b0\u4ef7\u683c\u5408\u7406\u3002\u53ef\u4ee5\u53eb\u5356\u5bb6\u6362\u4e2a\u7259\u76d8\u80fd\u4fbf\u5b9c\u70b9\u3002\r\n\r\n\u6765\u81ea[Android]\u624b\u673a\u5ba2\u6237\u7aef",
          "type": 0
        }
      ],
      "reply_id": 155903,
      "reply_status": 1,
      "reply_name": "\u6d77\u73e0-\u963f\u52c7",
      "reply_posts_id": 4961630,
      "status": 1,
      "title": "",
      "role_num": "",
      "is_quote": 0,
      "quote_pid": "",
      "quote_content": "",
      "quote_user_name": "",
      "position": 9,
      "reply_type": "normal",
      "managePanel": [],
      "extraPanel": []
    }
  ],
  "img_url": "",
  "forumTopicUrl": "http:\/\/bbs.77bike.com\/m\/index.php?a=read&tid=302098",
  "page": 1,
  "has_next": 1,
  "total_num": 16
};

const _sample3 = {
  "rs": 1,
  "errcode": 0,
  "head": {
    "errCode": "",
    "errInfo": "\u8c03\u7528\u6210\u529f,\u6ca1\u6709\u4efb\u4f55\u9519\u8bef",
    "version": "2.4.0.1",
    "alert": 0
  },
  "body": {"externInfo": null},
  "forumName": "\u673a\u52a8\u8f66\u9053",
  "boardId": "48",
  "topic": {
    "mobileSign": "",
    "userTitle": "\u535a\u58eb",
    "sortId": 81,
    "gender": 1,
    "level": 3.48864,
    "location": "",
    "icon":
        "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/90\/139590.jpg",
    "create_date": "1556076735000",
    "content": [
      {
        "infor":
            "\u9996\u5148\u4e0a\u56fe\u9547\u697c~\u5e7f\u6c7d\u83f2\u4e9a\u7279\u514b\u83b1\u65af\u52d2JEEP\u5927\u6307\u6325\u5b98\uff08\u597d\u957f -_-\uff09\r\n",
        "type": 0
      },
      {
        "infor":
            "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/xgsize\/Mon_1904\/48_139590_bbe75a7a0ceb110.jpg",
        "originalInfo":
            "http:\/\/bbs.77bike.com\/attachment\/Mon_1904\/48_139590_bbe75a7a0ceb110.jpg",
        "aid": 1319103,
        "type": 1
      },
      {
        "infor":
            "\r\n\r\n\r\n\r\n\u65e7\u8f66\u6807\u81f4408\uff0c2011\u6b3e\uff0c\u6cb9\u801713\uff0c\u5c0f\u95ee\u9898\u591a\uff0c\u52a0\u4e0a\u4eba\u53e3\u95ee\u9898\uff0c\u65e9\u5df2\u6ee1\u8db3\u4e0d\u4e86\u5bb6\u5ead\u9700\u6c42\uff0c\u51e0\u5e74\u524d\u5c31\u6709\u52a8\u4ed6\u7684\u5ff5\u5934\u3002\r\n\u6ca1\u60f3\u5230\uff0c\u5e74\u540e\u5c31\u628a\u8fd9\u4e2a\u4e8b\u60c5\u843d\u5b9e\u4e86\u3002\u63d0\u8f66\u5c06\u8fd1\u4e00\u4e2a\u6708\uff0c\u886c\u6628\u5929\u5929\u6c14\u597d\uff0c\u8d76\u7d27\u505a\u505a\u529f\u8bfe\u3002\r\n",
        "type": 0
      },
      {
        "infor":
            "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/xgsize\/Mon_1904\/48_139590_03fde2b7c109ca6.jpg",
        "originalInfo":
            "http:\/\/bbs.77bike.com\/attachment\/Mon_1904\/48_139590_03fde2b7c109ca6.jpg",
        "aid": 1319104,
        "type": 1
      },
      {
        "infor":
            "\r\n\r\n\r\n\r\n\u8bf4\u8bf4\u9009\u8f66\u5427\uff0c\u53cd\u6b63\u522b\u4eba\u90fd\u662f\u8fd9\u6837JY\u7684\u3002\r\n\u9274\u4e8e\u7b2c\u4e00\u6b21\u4e70408\u7684\u7ecf\u5386\uff0c\u8fd9\u6b21\u771f\u7684\u770b\u5c3d\u4e86\u89c6\u9891\u8bc4\u6d4b\uff0c\u5230\u5e97\u8bd5\u9a7e\uff0c\u5404\u79cd\u94bb\u7814\u3002\u52a1\u6c42\u4e0d\u4e70\u9519\uff0c\u52a1\u6c42\u4e0d\u540e\u6094\u3002\r\n\u6700\u521d\u6211\u662f\u6253\u7b97MPV\u7684\uff0c\u5976\u7238\u9ebb\u3002\u5965\u5fb7\u8d5b\uff0cGM8\uff0cGL8\uff0c\u590f\u6717\u90fd\u770b\u4e86\u4e00\u904d\uff0c\u4f46\u592a\u592a\u8868\u793a\u559c\u6b22SUV\u591a\u4e00\u4e9b\u3002\u540e\u6765\u6211\u4e5f\u4ed4\u7ec6\u60f3\u4e86\u60f3\uff0cMPV\u662f\u540e\u9762\u5f97\u5750\u5f97\u8212\u670d\uff0c\u610f\u601d\u5c31\u662f\u6211\u548c\u6211\u592a\u592a\u662f\u4eab\u53d7\u4e0d\u4e86\u7684\u3002\u800c\u4e14\u7531\u4e8e\u4e0d\u662f\u548c\u7236\u6bcd\u4e00\u8d77\u5c45\u4f4f\uff0c\u6ee1\u5ea7\u7387\u4f4e\uff0c\u65e5\u5e38\u5c31\u662f2\u5927+2\u5c0f\uff0c\u518d+2\u8001\u8fd9\u4e2a\u60c5\u51b5\u53ef\u80fd\u4e00\u5e74\u4e0d\u523010\u56de\u3002\u4e3a\u4e86\u9a7e\u9a76\u4f53\u9a8c\u4ee5\u53ca\u9a7e\u9a76\u4e50\u8da3\uff0c\u6700\u540e\u5c31\u6392\u9664\u4e86MPV\uff0c\u5f00\u59cb\u9009\u62e9SUV\u3002\r\n\r\n7\u5ea7SUV\u53ef\u9009\u62e9\u6027\u4e0d\u591a\uff0c\u9884\u7b9730\uff0c\u57fa\u672c\u5c31\u662f\u6c49\u5170\u8fbe\uff0c\u9510\u754c\uff0c\u9014\u6602\uff0c\u5927\u6307\u6325\u5b98\uff0c\u79d1\u8fea\u4e9a\u514b\uff0cCX-8\u3002\r\n\u6c49\u5170\u8fbe-\u5185\u5916\u90fd\u4e0d\u559c\u6b22\uff0c\u4e2a\u4eba\u539f\u56e0\uff0c\u5c31\u662f\u770b\u4e0d\u4e0a\uff0c\u914d\u7f6e\u5751\u7239\uff0c\u867d\u7136\u8eab\u8fb9\u5f88\u591a\u4eba\u63a8\u8350\uff0c\u672c\u4eba\u4e5f\u6df1\u77e5\u6c49\u5170\u8fbe\u7684\u597d\uff0c\u4f46\u662f\u4e0d\u559c\u6b22\u5c31\u662f\u4e0d\u559c\u6b22\uff0cpass\r\n\u9510\u754c-\u5916\u89c2\u89c9\u5f97\u6bd4\u6c49\u5170\u8fbe\u597d\uff0c\u5185\u9970\u53ef\u4ee5\u63a5\u53d7\uff0c\u4f46\u603b\u89c9\u5f97\u5dee\u4e86\u90a3\u4e48\u4e00\u70b9\uff0c\u4e5f\u4e0d\u77e5\u9053\u662f\u54ea\u4e00\u70b9\uff0cpass\r\n\u9014\u6602-\u8fd9\u4e2a\u53eb\u9996\u9009\u5427\uff0c\u7a7a\u95f4\u5927\uff0c\u4e0d\u8fc7\u8d85\u9884\u7b97\uff0c\u800c\u4e14\u5e95\u76d8\u7565\u5dee\uff0cpass\r\n\u79d1\u8fea\u4e9a\u514b-\u4e00\u5f00\u59cb\u633a\u559c\u6b22\uff0c\u540e\u6765\u8bd5\u8f66\u7684\u65f6\u5019\u5fd8\u8bb0\u5b83\u4e86\u3002\u3002\u3002pass\r\nCX-8-\u5916\u89c2\u6f02\u4eae\uff0c\u5185\u9970\u6f02\u4eae\uff0c\u6700\u597d\u7684\u9a7e\u9a76\u4f53\u9a8c\uff0c\u7b2c\u4e09\u6392\u4e5f\u8212\u670d\uff0c\u6700\u540e\u5217\u5165\u4e8c\u9009\u4e00\u4e4b\u4e00\uff0c\u7531\u4e8e\u6ce2\u7bb1\u4e2a\u4eba\u611f\u89c9\u7565\u8ddf\u4e0d\u4e0a\u5927\u8282\u594f\uff0c\u53c8\u6ca1\u6709\u4f18\u60e0\uff0cpass\r\n\u5927\u6307\u6325\u5b98-\u5916\u89c2\u633aman\uff0c\u65b9\u65b9\u6b63\u6b63\u591f\u7c97\u72b7\uff0c\u5185\u9970\u4e5f\u51d1\u5408\uff0c\u914d\u7f6e\u4e30\u5bcc\uff0c\u52a8\u529b\u963f\u5c14\u6cd5\u7f57\u5bc6\u6b279\u901f\u6ce2\u7bb1\uff0c270\u9a6c\u529b400\u626d\u3002\u867d\u7136\u7a7a\u95f4\u76f8\u5bf9\u6bd4\u5176\u4ed6\u8f66\u8981\u5c0f\u70b9\uff0c\u4f46\u7528\u6599\u624e\u5b9e\uff0c\u52a0\u4e0a\u4e00\u822c\u6ee1\u5ea7\u4e5f\u662f6\u4eba\uff0c\u8db3\u77e3\u3002\u4f18\u60e0\u867d\u7136\u4e0d\u7ed9\u529b\uff0c\u4f46\u603b\u6bd4\u6ca1\u4f18\u60e0\u8981\u597d\uff0c\u6240\u4ee5\u6700\u540e\u9524\u5b9a\u4e86\u4ed6\u3002\r\n\r\n\u5e9f\u8bdd\u5b8c\u4e86\uff0c\u4e0a\u70b9\u56fe~~~\r\nJeep\u7684\u5bb6\u65cf\u8138\uff0c7\u4e2a\u6d1e\u6d1e\u3002\r\n",
        "type": 0
      },
      {
        "infor":
            "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/xgsize\/Mon_1904\/48_139590_f26b8fd556d289b.jpg",
        "originalInfo":
            "http:\/\/bbs.77bike.com\/attachment\/Mon_1904\/48_139590_f26b8fd556d289b.jpg",
        "aid": 1319105,
        "type": 1
      },
      {
        "infor":
            "\r\n\r\n\r\n\r\n\u9009\u989c\u8272\u633a\u5feb\u51b3\u5b9a\u7684\uff0c\u4ee5\u524d\u7684408\u662f\u6df1\u7070\u8272\uff0c\u6240\u4ee5\u8fd9\u6b21\u4e0d\u518d\u9009\u4e86\uff0c\u5c31\u5269\u4e0b\u767d\u8272\u548c\u8fd9\u4e2a\u84dd\u8272\u770b\u5f97\u4e0a\u3002\u767d\u8272\u5c0f\u8f66\u597d\u770b\uff0c\u5927\u8f66\u603b\u5dee\u4e86\u70b9\u70b9\u3002\r\n\u8fd9\u4e2a\u84dd\u8272\uff0c\u4e0d\u592a\u9ad8\u8c03\uff0c\u6df1\u6c89\u5e26\u70b9\u95f7\u9a9a\uff0c\u9002\u5408\u6211\u54c8\u54c8\u3002\r\n",
        "type": 0
      },
      {
        "infor":
            "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/xgsize\/Mon_1904\/48_139590_29565d50d681bbe.jpg",
        "originalInfo":
            "http:\/\/bbs.77bike.com\/attachment\/Mon_1904\/48_139590_29565d50d681bbe.jpg",
        "aid": 1319106,
        "type": 1
      },
      {
        "infor":
            "\r\n\r\n\r\n\r\n\u5404\u79cd\u62cd\uff0c\u624b\u6b8b\u515a\uff0c\u90fd\u662fmate20pro\u76f4\u51fa\u7684\u7167\u7247\u3002\r\n",
        "type": 0
      },
      {
        "infor":
            "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/xgsize\/Mon_1904\/48_139590_691720b4622c8de.jpg",
        "originalInfo":
            "http:\/\/bbs.77bike.com\/attachment\/Mon_1904\/48_139590_691720b4622c8de.jpg",
        "aid": 1319107,
        "type": 1
      },
      {"infor": "\r\n\r\n\r\n", "type": 0},
      {
        "infor":
            "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/xgsize\/Mon_1904\/48_139590_5a142c1279ec314.jpg",
        "originalInfo":
            "http:\/\/bbs.77bike.com\/attachment\/Mon_1904\/48_139590_5a142c1279ec314.jpg",
        "aid": 1319108,
        "type": 1
      },
      {"infor": "\r\n\r\n\r\n", "type": 0},
      {
        "infor":
            "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/xgsize\/Mon_1904\/48_139590_a78e47e37bb75b1.jpg",
        "originalInfo":
            "http:\/\/bbs.77bike.com\/attachment\/Mon_1904\/48_139590_a78e47e37bb75b1.jpg",
        "aid": 1319109,
        "type": 1
      },
      {"infor": "\r\n\r\n\r\n", "type": 0},
      {
        "infor":
            "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/xgsize\/Mon_1904\/48_139590_a5418710b32ffa0.jpg",
        "originalInfo":
            "http:\/\/bbs.77bike.com\/attachment\/Mon_1904\/48_139590_a5418710b32ffa0.jpg",
        "aid": 1319110,
        "type": 1
      }
    ],
    "user_id": 139590,
    "reply_status": 1,
    "hits": 878,
    "replies": 88,
    "essence": 1,
    "topic_id": 299670,
    "user_nick_name": "\u8001\u54f6",
    "reply_posts_id": 0,
    "title": "[AUTO]#My Grand Commander#",
    "status": 1,
    "is_favor": 0,
    "type": "normal",
    "falg": 0,
    "poll_info": null,
    "activityInfo": null,
    "managePanel": [],
    "extraPanel": [
      {
        "action":
            "http:\/\/bbs.77bike.com\/mobcent\/app\/web\/index.php?r=forum\/topicrate&sdkVersion=2.4.0.1&accessToken=ac3f19b94085e3b86c228b54f71c7&accessSecret=f01b3418e99ebdc5fda5fa3b8b9c2&tid=299670&fid=48&act=ping&pid=tpc&type=ping",
        "title": "\u8bc4\u5206",
        "type": "rate",
        "extParams": {" beforeAction": ""}
      },
      {
        "action":
            "http:\/\/bbs.77bike.com\/mobcent\/app\/web\/index.php?r=forum\/support&sdkVersion=2.4.0.1&accessToken=ac3f19b94085e3b86c228b54f71c7&accessSecret=f01b3418e99ebdc5fda5fa3b8b9c2&tid=299670&fid=48&act=dig&pid=&type=topic",
        "title": "\u8d5e",
        "type": "support",
        "extParams": {
          " beforeAction": "",
          "recommendAdd": 1,
          "isHasRecommendAdd": 0
        }
      }
    ],
    "rateList": {
      "ping": "",
      "head": {
        "field1": "\u51714\u6761\u8bc4\u5206",
        "field2": "\u91d1\u94b1+17,\u5a01\u671b+12,"
      },
      "body": [
        {
          "field1": "azuretears",
          "field2": "\u5a01\u671b +7",
          "field3": "04-26"
        },
        {
          "field1": "azuretears",
          "field2": "\u91d1\u94b1 +7",
          "field3": "04-26"
        },
        {
          "field1": "\u6d77\u6811",
          "field2": "\u5a01\u671b +5",
          "field3": "04-26"
        }
      ],
      "showAllUrl":
          "http:\/\/bbs.77bike.com\/mobcent\/app\/web\/index.php?r=forum\/ratelistview&fid=48&tid=299670&sdkVersion=2.4.0&accessToken=ac3f19b94085e3b86c228b54f71c7&accessSecret=f01b3418e99ebdc5fda5fa3b8b9c2"
    }
  },
  "list": [
    {
      "mobileSign": "",
      "userTitle": "\u535a\u58eb",
      "gender": 1,
      "level": 3.48864,
      "location": "",
      "icon":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/90\/139590.jpg",
      "posts_date": "1556076747000",
      "reply_content": [
        {"infor": "\u518d\u8865\u5145\r\n", "type": 0},
        {
          "infor":
              "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/xgsize\/Mon_1904\/48_139590_aa201cd22b5c942.jpg",
          "originalInfo":
              "http:\/\/bbs.77bike.com\/attachment\/Mon_1904\/48_139590_aa201cd22b5c942.jpg",
          "aid": 1319111,
          "type": 1
        },
        {"infor": "\r\n\r\n\r\n\r\n", "type": 0},
        {
          "infor":
              "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/xgsize\/Mon_1904\/48_139590_1f484b45aec4dea.jpg",
          "originalInfo":
              "http:\/\/bbs.77bike.com\/attachment\/Mon_1904\/48_139590_1f484b45aec4dea.jpg",
          "aid": 1319112,
          "type": 1
        },
        {"infor": "\r\n\r\n\r\n\r\n", "type": 0},
        {
          "infor":
              "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/xgsize\/Mon_1904\/48_139590_accf3d2cfc694a0.jpg",
          "originalInfo":
              "http:\/\/bbs.77bike.com\/attachment\/Mon_1904\/48_139590_accf3d2cfc694a0.jpg",
          "aid": 1319113,
          "type": 1
        },
        {
          "infor":
              "\r\n\r\n\r\n\r\n\u5168\u7cfb\u8fdc\u8fd1\u6807\u914dLED\uff0c\u96fe\u706f\u9664\u5916\u3002\r\n",
          "type": 0
        },
        {
          "infor":
              "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/xgsize\/Mon_1904\/48_139590_2670c390daf6483.jpg",
          "originalInfo":
              "http:\/\/bbs.77bike.com\/attachment\/Mon_1904\/48_139590_2670c390daf6483.jpg",
          "aid": 1319115,
          "type": 1
        },
        {"infor": "\r\n\r\n\r\n\r\n", "type": 0},
        {
          "infor":
              "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/xgsize\/Mon_1904\/48_139590_ab543c6ca3cc4e2.jpg",
          "originalInfo":
              "http:\/\/bbs.77bike.com\/attachment\/Mon_1904\/48_139590_ab543c6ca3cc4e2.jpg",
          "aid": 1319114,
          "type": 1
        },
        {"infor": "\r\n\r\n\r\n\r\n", "type": 0},
        {
          "infor":
              "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/xgsize\/Mon_1904\/48_139590_27e2c75b282d0ac.jpg",
          "originalInfo":
              "http:\/\/bbs.77bike.com\/attachment\/Mon_1904\/48_139590_27e2c75b282d0ac.jpg",
          "aid": 1319116,
          "type": 1
        },
        {"infor": "\r\n", "type": 0}
      ],
      "reply_id": 139590,
      "reply_status": 1,
      "reply_name": "\u8001\u54f6",
      "reply_posts_id": 4925783,
      "status": 1,
      "title": "",
      "role_num": "",
      "is_quote": 0,
      "quote_pid": "",
      "quote_content": "",
      "quote_user_name": "",
      "position": 1,
      "reply_type": "normal",
      "managePanel": [],
      "extraPanel": []
    },
    {
      "mobileSign": "",
      "userTitle": "\u535a\u58eb",
      "gender": 1,
      "level": 3.48864,
      "location": "",
      "icon":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/90\/139590.jpg",
      "posts_date": "1556076758000",
      "reply_content": [
        {
          "infor":
              "\u4ee5\u4e0a\u5c31\u662f\u5916\u89c2\uff0c\u63a5\u4e0b\u6765\u5185\u9970\u90e8\u5206\u4e5f\u968f\u4fbf\u62cd\u4e86\u62cd\u3002\r\n\u9996\u5148\u4eea\u8868\u76d8\uff0c\u867d\u7136\u4e0d\u662f\u5168\u6db2\u6676\uff0c\u4f46\u4e24\u70ae\u7b52\u4e5f\u597d\u770b\uff0c\u4e2d\u5c4f\u4e5f\u53ef\u4ee5\u67e5\u9605\u5f88\u591a\u5173\u4e8e\u8f66\u51b5\u7684\u5185\u5bb9\uff0c\u5305\u62ec\u80ce\u538b\u4ec0\u4e48\u7684\u3002\r\n\r\n\r\n\u5173\u4e8e\u6cb9\u8017\u95ee\u9898\uff0c\u8fd9\u53f0\u8f66\u76f8\u5bf9\u5176\u4ed6\u51e0\u4e2a\u5bf9\u624b\uff0c\u5e94\u8be5\u7b97\u9ad8\u7684\u3002\u4f46\u7531\u4e8e\u524d\u4efb408\u7684\u5927\u5403\uff0c\u6240\u4ee5\u5df2\u7ecf\u4ee4\u6211\u5bf9\u8fd9\u65b9\u9762\u5bb9\u5fcd\u5ea6\u8981\u9ad8\uff1a\u5c31\u662f\u6bd4408\u7701\u6cb9\u5c31\u884c\u3002\r\n\u7ed3\u679c\u633a\u6ee1\u610f\uff0c\u73b0\u5728500\u516c\u91cc\uff0c\u4e00\u534a\u5e02\u533a\u4e00\u534a\u9ad8\u901f\uff0c11.7\uff0c\u5f88\u597d\u5f88\u597d\u3002\r\n\u6211\u4e0d\u662f\u5929\u5929\u5f00\uff0c\u65e5\u5e38\u5c0f\u5e03\u901a\u52e4\uff0c\u5927\u6307\u8fd9\u4e2a\u8eab\u6750\u8fd9\u4e2a\u53d1\u52a8\u673a\uff0c\u5f97\u51fa\u8fd9\u4e2a\u6cb9\u8017\uff0cgood\u7684\u5566\u3002\r\n",
          "type": 0
        },
        {
          "infor":
              "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/xgsize\/Mon_1904\/48_139590_8d49c81c865fc5a.jpg",
          "originalInfo":
              "http:\/\/bbs.77bike.com\/attachment\/Mon_1904\/48_139590_8d49c81c865fc5a.jpg",
          "aid": 1319117,
          "type": 1
        },
        {
          "infor":
              "\r\n\r\n\r\n\r\n\u4e2d\u63a7\uff0c\u611f\u89c9\u548c\u6211\u4ee5\u524d\u770b\u7684\u90a3\u4e2a\u9053\u5947\u76847\u5ea7\u6709\u70b9\u76f8\u4f3c\uff0c\u53ef\u80fd\u90fd\u662f\u7f8e\u56fd\u4f6c\u7684\u5173\u7cfb\u5427\uff0c\u4f46\u6bd4\u9053\u5947\u7684\u597d\u770b\uff0c\u7528\u6599\u4e5f\u8db3\u3002\r\n\u81ea\u5e26carlife carplay\uff0c\u624b\u673a\u76f4\u63a5\u6295\u5c4f\u5bfc \u822a\u6ca1\u538b\u529b\r\n",
          "type": 0
        },
        {
          "infor":
              "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/xgsize\/Mon_1904\/48_139590_5ef0bd156a507a6.jpg",
          "originalInfo":
              "http:\/\/bbs.77bike.com\/attachment\/Mon_1904\/48_139590_5ef0bd156a507a6.jpg",
          "aid": 1319126,
          "type": 1
        },
        {
          "infor":
              "\r\n\r\n\r\n\r\n\u56db\u9a71\uff01\u524d\u4e24\u5929\u4e0a\u4e86\u8d9f\u5357\u6606\u5c71\uff0c\u8d70\u4e86\u4e00\u6761\u4e0d\u5bfb\u5e38\u7684\u5c71\u8def\uff0c\u8fd9\u65f6\u5c31\u6781\u5927\u4f53\u9a8c\u4e86jeep\u56db\u9a71\u7684\u4ef7\u503c\u3002\u4e00\u4e2a\u8eab\u8fb9\u7684\u6c7d\u8f66\u4eba\u4e5f\u66fe\u548c\u6211\u8bf4\u8fc7\uff0cjeep\u7684\u4ef7\u503c\u662f\u5728\u975e\u94fa\u88c5\u8def\u9762\u624d\u80fd\u4f53\u9a8c\u7684\uff0c\u7ecf\u8fc7\u8fd9\u6b21\uff0c\u6211\u5f88\u8ba4\u540c\u3002\r\n\r\n\r\n\u770b\u89c6\u9891\u65f6\u5019\uff0c\u5f88\u591a\u8bc4\u6d4b\u8bf4\u8fd9\u4e2a\u8f66\u5f88\u4e32\uff0c\u70b9\u4e00\u4e0b\u6cb9\u95e8\u5c31\u51b2\u51fa\u53bb\u3002\u7684\u786e\uff0c\u5f00\u521d\u65f6\u5019\u662f\u4f1a\u6709\u70b9\uff0c\u7279\u522b\u5f00\u4e86autohold\uff0c\u6bcf\u6b21\u505c\u8f66\u4ee5\u540e\u7ed9\u6cb9\u7a0d\u5fae\u5927\u70b9\u8f66\u5c31\u98d9\u4e86\u3002\r\n\u4f46\u4f60\u719f\u6089\u4ed6\u4ee5\u540e\u8fd9\u4e2a\u60c5\u51b5\u5c31\u6ca1\u6709\u4e86\u554a\uff0c\u53cd\u800c\u6211\u73b0\u5728\u89c9\u5f97\u8fd9\u4e2a\u662f\u4f18\u70b9\uff0c\u6cb9\u95e8\u6bd4\u8f83\u8f7b\uff0c\u8f7b\u8f7b\u7ed9\u6cb9\u901f\u5ea6\u5c31\u4e0a\u53bb\u4e86\uff0c\u8981\u8d85\u8f66\u4e00\u811a\u4e0b\u53bb\u6ca1\u538b\u529b~~\r\n\u7b80\u5355\u6982\u62ec\u5c31\u662f~~\u4e60\u60ef\u5c31\u597d\u3002\r\n",
          "type": 0
        },
        {
          "infor":
              "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/xgsize\/Mon_1904\/48_139590_4c20a52f5b85677.jpg",
          "originalInfo":
              "http:\/\/bbs.77bike.com\/attachment\/Mon_1904\/48_139590_4c20a52f5b85677.jpg",
          "aid": 1319118,
          "type": 1
        },
        {
          "infor":
              "\r\n\r\n\r\n\r\n\u4e09\u533a\u72ec\u7acb\u7a7a\u8c03\uff0c\u5145\u7535\u4f4d\u7f6e\u52b2\u591a\uff0c\u518d\u9ad8\u7ea7\u7684\u914d\u7f6e\u8fd8\u5e26220V\u7535\u6e90\u3002\r\n",
          "type": 0
        },
        {
          "infor":
              "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/xgsize\/Mon_1904\/48_139590_abdb32e8e56781e.jpg",
          "originalInfo":
              "http:\/\/bbs.77bike.com\/attachment\/Mon_1904\/48_139590_abdb32e8e56781e.jpg",
          "aid": 1319121,
          "type": 1
        },
        {
          "infor": "\r\n\r\n\r\n\r\n\u4e8c\u6392\u548c\u4e09\u6392\r\n",
          "type": 0
        },
        {
          "infor":
              "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/xgsize\/Mon_1904\/48_139590_03d667084dcad18.jpg",
          "originalInfo":
              "http:\/\/bbs.77bike.com\/attachment\/Mon_1904\/48_139590_03d667084dcad18.jpg",
          "aid": 1319123,
          "type": 1
        },
        {
          "infor":
              "\r\n\r\n\r\n\u4e09\u6392\u8fd9\u4e2a\u80fd\u53eb\u5b8c\u6574\u7684\u5ea7\u6905\uff0c\u867d\u6bd4\u4e0d\u4e0aCX-8\u7684\u6c99\u53d1\u8212\u670d\uff0c\u4f46\u6bd4\u5176\u4ed6\u5c0f\u677f\u51f3\u8981\u597d\u5f88\u591a\u3002\u73b0\u5728\u51fa\u95e82\u4e2a\u5c0f\u7684\u5c31\u7231\u5728\u8fd9\u91cc\u5446\u7740\u3002\r\n",
          "type": 0
        },
        {
          "infor":
              "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/xgsize\/Mon_1904\/48_139590_2f9d698b11ce2ee.jpg",
          "originalInfo":
              "http:\/\/bbs.77bike.com\/attachment\/Mon_1904\/48_139590_2f9d698b11ce2ee.jpg",
          "aid": 1319120,
          "type": 1
        },
        {
          "infor":
              "\r\n \r\n\u8001\u677f\u952e\uff0c\u8c8c\u4f3c\u4e5f\u662f\u5168\u7cfb\u6807\u914d\uff0c\u65b9\u4fbf\u3002\r\n",
          "type": 0
        },
        {
          "infor":
              "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/xgsize\/Mon_1904\/48_139590_cb2546c73b7b4e2.jpg",
          "originalInfo":
              "http:\/\/bbs.77bike.com\/attachment\/Mon_1904\/48_139590_cb2546c73b7b4e2.jpg",
          "aid": 1319122,
          "type": 1
        },
        {
          "infor":
              "\r\n \r\n\u5168\u7cfb\u5217\u6807\u914d\u7684\u7535\u52a8\u5c3e\u95e8\uff0c\u9ad8\u914d\u8fd8\u6709\u611f\u5e94\u5c3e\u95e8\u3002\u4ece\u8fd9\u4e2a\u56fe\u8fd8\u53ef\u4ee5\u770b\u51fa\u6765\uff0c\u7a7a\u95f4\u662f\u633a\u5c0f\u7684\uff0c\u5982\u679c7\u4eba\u51fa\u95e8\uff0c\u4e1c\u897f\u57fa\u672c\u653e\u4e0d\u3002\r\n\u5982\u679c6\u4e2a\uff0c\u884c\u674e\u591a\uff0c\u8fd8\u53ef\u4ee52-3-1\u51d1\u5408\u7528\uff0c\u6700\u540e\u4e00\u6392\u653e\u4e0b\u4e00\u4e2a\u6905\u5b50\u5c31\u597d\u3002\u8fd8\u662f\u90a3\u53e5\u8bdd\uff0c\u8fd9\u4e2a\u7b26\u5408\u6211\u7684\u5bb6\u5ead\uff0c\u6240\u4ee5\u6211\u662f\u53ef\u4ee5\u63a5\u53d7\u4ed6\u8fd9\u4e2a\u7f3a\u70b9\u3002\r\n",
          "type": 0
        },
        {
          "infor":
              "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/xgsize\/Mon_1904\/48_139590_79cd6eac26c5742.jpg",
          "originalInfo":
              "http:\/\/bbs.77bike.com\/attachment\/Mon_1904\/48_139590_79cd6eac26c5742.jpg",
          "aid": 1319124,
          "type": 1
        },
        {"infor": "\r\n\r\n\r\n", "type": 0},
        {
          "infor":
              "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/xgsize\/Mon_1904\/48_139590_d3671798ee18d84.jpg",
          "originalInfo":
              "http:\/\/bbs.77bike.com\/attachment\/Mon_1904\/48_139590_d3671798ee18d84.jpg",
          "aid": 1319125,
          "type": 1
        }
      ],
      "reply_id": 139590,
      "reply_status": 1,
      "reply_name": "\u8001\u54f6",
      "reply_posts_id": 4925784,
      "status": 1,
      "title": "",
      "role_num": "",
      "is_quote": 0,
      "quote_pid": "",
      "quote_content": "",
      "quote_user_name": "",
      "position": 2,
      "reply_type": "normal",
      "managePanel": [],
      "extraPanel": []
    },
    {
      "mobileSign": "",
      "userTitle": "\u535a\u58eb",
      "gender": 1,
      "level": 3.48864,
      "location": "",
      "icon":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/90\/139590.jpg",
      "posts_date": "1556076769000",
      "reply_content": [
        {
          "infor":
              "\u672c\u6253\u7b97\u9a91\u5c0f\u5e03\u4e0a\u53bb\u7684\uff0c\u5948\u4f55\u5929\u6c14\u592a\u5dee\uff0c\u6700\u540e\u53ea\u80fd\u5e26\u4e0a\u53bb\u6253\u5361\r\n",
          "type": 0
        },
        {
          "infor":
              "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/xgsize\/Mon_1904\/48_139590_66a12eaf6a1815d.jpg",
          "originalInfo":
              "http:\/\/bbs.77bike.com\/attachment\/Mon_1904\/48_139590_66a12eaf6a1815d.jpg",
          "aid": 1319128,
          "type": 1
        },
        {"infor": "\r\n\r\n", "type": 0}
      ],
      "reply_id": 139590,
      "reply_status": 1,
      "reply_name": "\u8001\u54f6",
      "reply_posts_id": 4925786,
      "status": 1,
      "title": "",
      "role_num": "",
      "is_quote": 0,
      "quote_pid": "",
      "quote_content": "",
      "quote_user_name": "",
      "position": 3,
      "reply_type": "normal",
      "managePanel": [],
      "extraPanel": []
    },
    {
      "mobileSign": "",
      "userTitle": "\u535a\u58eb",
      "gender": 1,
      "level": 3.48864,
      "location": "",
      "icon":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/90\/139590.jpg",
      "posts_date": "1556076781000",
      "reply_content": [
        {
          "infor":
              "\u8fd9\u4e2a\u662f\u53f6\u5b50\u6559\u7684\u529e\u6cd5\uff0c\u6bd4\u653e\u6700\u540e\u9762\u8981\u7a33~\u5c31\u62cd\u7167\u7684\u65f6\u5019\u642c\u51fa\u6765\uff0c\u62cd\u5b8c\u9a6c\u4e0a\u5c31\u5750\u56de\u53bb\u4e86\uff0c\u7b49\u4e0b\u6b21\u7fa4\u4e3b\u5e26\u961f\u518d\u6740\u4e0a\u5357\u6606\u5c71\r\n",
          "type": 0
        },
        {
          "infor":
              "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/xgsize\/Mon_1904\/48_139590_5e82c3c639dd5c1.jpg",
          "originalInfo":
              "http:\/\/bbs.77bike.com\/attachment\/Mon_1904\/48_139590_5e82c3c639dd5c1.jpg",
          "aid": 1319129,
          "type": 1
        },
        {"infor": "\r\n", "type": 0}
      ],
      "reply_id": 139590,
      "reply_status": 1,
      "reply_name": "\u8001\u54f6",
      "reply_posts_id": 4925787,
      "status": 1,
      "title": "",
      "role_num": "",
      "is_quote": 0,
      "quote_pid": "",
      "quote_content": "",
      "quote_user_name": "",
      "position": 4,
      "reply_type": "normal",
      "managePanel": [],
      "extraPanel": []
    },
    {
      "mobileSign": "",
      "userTitle": "\u535a\u58eb",
      "gender": 1,
      "level": 3.48864,
      "location": "",
      "icon":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/90\/139590.jpg",
      "posts_date": "1556076793000",
      "reply_content": [
        {
          "infor":
              "\u6811\u54e5\uff0c\u6c42\u4e2a\u7cbe\uff0c\u7b49\u6211\u6df7\u591a\u4e2a\u52cb\u7ae0 [mobcent_phiz=http:\/\/bbs.77bike.com\/images\/post\/smile\/qq\/89.gif][mobcent_phiz=http:\/\/bbs.77bike.com\/images\/post\/smile\/qq\/89.gif][mobcent_phiz=http:\/\/bbs.77bike.com\/images\/post\/smile\/qq\/89.gif] \r\n \r\n",
          "type": 0
        }
      ],
      "reply_id": 139590,
      "reply_status": 1,
      "reply_name": "\u8001\u54f6",
      "reply_posts_id": 4925788,
      "status": 1,
      "title": "",
      "role_num": "",
      "is_quote": 0,
      "quote_pid": "",
      "quote_content": "",
      "quote_user_name": "",
      "position": 5,
      "reply_type": "normal",
      "managePanel": [],
      "extraPanel": []
    },
    {
      "mobileSign": "",
      "userTitle": "\u7855\u58eb",
      "gender": 1,
      "level": 2.55872,
      "location": "",
      "icon":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/18\/157318.jpg",
      "posts_date": "1556078344000",
      "reply_content": [
        {
          "infor":
              "\u989c\u8272\u597d\u7f8e\r\n\r\n\u6765\u81ea[Android]\u624b\u673a\u5ba2\u6237\u7aef",
          "type": 0
        }
      ],
      "reply_id": 157318,
      "reply_status": 1,
      "reply_name": "\u82b1\u8f6e\u548c\u5f66",
      "reply_posts_id": 4925803,
      "status": 1,
      "title": "",
      "role_num": "",
      "is_quote": 0,
      "quote_pid": "",
      "quote_content": "",
      "quote_user_name": "",
      "position": 6,
      "reply_type": "normal",
      "managePanel": [],
      "extraPanel": []
    },
    {
      "mobileSign": "",
      "userTitle": "\u5927\u5b66\u751f",
      "gender": 0,
      "level": 5.6192857142857,
      "location": "",
      "icon": "http:\/\/bbs.77bike.com\/images\/face\/none.gif",
      "posts_date": "1556078785000",
      "reply_content": [
        {
          "infor":
              "\u591a\u5c11\u94f6\u5b50[mobcent_phiz=http:\/\/bbs.77bike.com\/images\/post\/smile\/qq\/2.gif] ",
          "type": 0
        }
      ],
      "reply_id": 95993,
      "reply_status": 1,
      "reply_name": "heiyaa",
      "reply_posts_id": 4925804,
      "status": 1,
      "title": "",
      "role_num": "",
      "is_quote": 0,
      "quote_pid": "",
      "quote_content": "",
      "quote_user_name": "",
      "position": 7,
      "reply_type": "normal",
      "managePanel": [],
      "extraPanel": []
    },
    {
      "mobileSign": "",
      "userTitle": "\u7855\u58eb",
      "gender": 1,
      "level": 5.1385714285714,
      "location": "",
      "icon":
          "http:\/\/bbs.77bike.com\/attachment\/thumb\/Mon_1408\/23_17004_312443683d7d434.jpg?125",
      "posts_date": "1556078945000",
      "reply_content": [
        {
          "infor":
              "\u6bcf\u4e2a\u7537\u4eba\u90fd\u6709\u4e2aJEEP\u68a6[\u563b\u563b]\r\n\r\n\u6765\u81ea[Android]\u624b\u673a\u5ba2\u6237\u7aef",
          "type": 0
        }
      ],
      "reply_id": 17004,
      "reply_status": 1,
      "reply_name": "\u7a7a\u5f53\u63a5\u9f99",
      "reply_posts_id": 4925809,
      "status": 1,
      "title": "",
      "role_num": "",
      "is_quote": 0,
      "quote_pid": "",
      "quote_content": "",
      "quote_user_name": "",
      "position": 8,
      "reply_type": "normal",
      "managePanel": [],
      "extraPanel": []
    },
    {
      "mobileSign": "",
      "userTitle": "\u535a\u58eb",
      "gender": 1,
      "level": 3.48864,
      "location": "",
      "icon":
          "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/90\/139590.jpg",
      "posts_date": "1556079041000",
      "reply_content": [
        {
          "infor":
              "\r\n\u81ea\u884c\u8f66\u641e\u4e0d\u4e86\u901f\u964d\uff0c\u6240\u4ee5\u5728\u56db\u4e2a\u8f6e\u5b50\u4e0b\u624b\u54c8\u54c8",
          "type": 0
        }
      ],
      "reply_id": 139590,
      "reply_status": 1,
      "reply_name": "\u8001\u54f6",
      "reply_posts_id": 4925812,
      "status": 1,
      "title": "\u56de \u7a7a\u5f53\u63a5\u9f99 \u7684\u5e16\u5b50",
      "role_num": "",
      "is_quote": 1,
      "quote_pid": "",
      "quote_content":
          "\u7a7a\u5f53\u63a5\u9f99:\u6bcf\u4e2a\u7537\u4eba\u90fd\u6709\u4e2aJEEP\u68a6\n(2019-04-24 12:09)",
      "quote_user_name": "\u7a7a\u5f53\u63a5\u9f99",
      "position": 9,
      "reply_type": "normal",
      "managePanel": [],
      "extraPanel": []
    }
  ],
  "img_url": "",
  "forumTopicUrl": "http:\/\/bbs.77bike.com\/m\/index.php?a=read&tid=299670",
  "page": 1,
  "has_next": 1,
  "total_num": 89
};
*/
