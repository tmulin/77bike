/*
accessSecret	f01b3418e99ebdc5fda5fa3b8b9c2
accessToken	ac3f19b94085e3b86c228b54f71c7
apphash	9425b1e8
forumKey	itTovrNYj6jgmwUBcQ
keyword	后拨
page	1
pageSize	20
sdkVersion	2.4.0
searchid	0
*/

import 'package:jaguar_serializer/jaguar_serializer.dart';

import '../common.dart';

part 'forum_search.jser.dart';

class ForumSearchAction {
  static const String action = "forum/search";

  static Map<String, dynamic> buildRequest(
          {String keyword,
          int page = 1,
          int pageSize = 20,
          int searchid = 0}) =>
      {
        "keyword": keyword,
        "page": page,
        "pageSize": pageSize,
        "searchid": searchid
      };

  static ForumSearchResponse parseResponse(Map<String, dynamic> response) {
    return ForumSearchResponseSerializer().fromMap(response);
  }
}

class ForumSearchResponse extends MobcentResponse {
  int page;
  int has_next;
  int total_num;
  int searchid;
  List<SearchTopic> list;

  ForumSearchResponse(
      {this.page = 0,
      this.has_next = 0,
      this.total_num = 0,
      this.searchid = 0,
      this.list = const []});
}

class SearchTopic {
  int board_id = 0;
  int topic_id = 0;
  int type_id = 0;
  int sort_id = 0;
  String title;
  String subject;
  int user_id = 0;
  String last_reply_date; // "int"
  DateTime get last_reply_date_value =>
      DateTime.fromMillisecondsSinceEpoch(int.tryParse(this.last_reply_date));
  String user_nick_name;

  /// 点击查看数
  int hits = 0;

  /// 回复数
  int replies = 0;
  int status = 0;
  int essence = 0;
  int top = 0;
  int hot = 0;
  int vote = 0;
  String pic_path;
}

@GenSerializer()
class ForumSearchResponseSerializer extends Serializer<ForumSearchResponse>
    with _$ForumSearchResponseSerializer {}

@GenSerializer()
class SearchTopicSerializer extends Serializer<SearchTopic>
    with _$SearchTopicSerializer {}

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
  "body": {"externInfo": null},
  "page": 1,
  "has_next": 1,
  "total_num": 900,
  "list": [
    {
      "board_id": 31,
      "topic_id": 302081,
      "type_id": 41,
      "sort_id": 0,
      "subject":
          "\u4e0d\u7528\u6362\u5927\u9e21\u817f\uff0c\u76f4\u63a5\u628a\u539f\u88c511+11\u6362\u6210\u4e8613+15\uff0c\u6548\u679c\u4e5f\u4e0d\u9519\uff0c\u81f3\u5c11\u7a7a ..",
      "status": 0,
      "title": "\u6362\u4e86\u540e\u62e8\u5927\u5bfc\u8f6e",
      "user_id": 161754,
      "last_reply_date": "1562669601000",
      "user_nick_name": "jamo01",
      "hits": 12,
      "replies": 11,
      "top": 0,
      "essence": 0,
      "hot": 1,
      "vote": 0,
      "pic_path": ""
    },
    {
      "board_id": 12,
      "topic_id": 302008,
      "type_id": 19,
      "sort_id": 0,
      "subject":
          "\u98de\u8f6ehg80-9  11-28t \u5168\u65b0\u94fe\u6761 \u529b\u6e90\u54c1\u724c\u5168\u65b0 \u5e26\u9b54\u672f\u6263106\u8282\u5427\u540e\u62e8 ..",
      "status": 0,
      "title":
          "9\u901fhg80-9\u53d8\u901f\u98de\u8f6e3400\u540e\u62e8\u94fe\u6761",
      "user_id": 139576,
      "last_reply_date": "1562200098000",
      "user_nick_name": "kinayuhu",
      "hits": 4,
      "replies": 3,
      "top": 0,
      "essence": 0,
      "hot": 0,
      "vote": 0,
      "pic_path":
          "http:\/\/bbs.77bike.com\/attachment\/Mon_1907\/12_139576_8c8663ed7c7a4af.jpg"
    },
    {
      "board_id": 31,
      "topic_id": 301932,
      "type_id": 40,
      "sort_id": 0,
      "subject":
          "\u6253\u7b97\u7528\u5728\u6298\u53e0\u8f66\u4e0a\uff0c\u5728\u54b8\u9c7c\u6536\u4e2a\u4e8c\u624b\u7684\uff0c\u6ca1\u6709\u6307\u62e8\uff0c\u8bf7\u95eeZEE\u80fd\u642d\u4ec0 ..",
      "status": 0,
      "title": "\u8bf7\u95eeZEE\u540e\u62e8\u7528\u5565\u6307\u62e8",
      "user_id": 165833,
      "last_reply_date": "1561597179000",
      "user_nick_name": "\u5927\u5927\u602a",
      "hits": 155,
      "replies": 20,
      "top": 0,
      "essence": 0,
      "hot": 1,
      "vote": 0,
      "pic_path":
          "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/xgsize\/Mon_1906\/31_165833_0c6aea716a0f30f.jpg"
    },
    {
      "board_id": 12,
      "topic_id": 301908,
      "type_id": 19,
      "sort_id": 0,
      "subject":
          "\u624b\u673a\u7248\u6ca1\u529e\u6cd5\u4e0a\u56fe....\u7b49\u54c8\u56de\u53bb\u7535\u8111\u4e0a\u4f20\uff0c\u6210\u8272\u597d\uff0c200\u516c\u91cc\u5de6\u53f3\u62c6 ..",
      "status": 0,
      "title": "RS 685+BR 805\u5939\u5668\uff0c6800\u524d\u540e\u62e8",
      "user_id": 109323,
      "last_reply_date": "1561563369000",
      "user_nick_name": "lzyhunter",
      "hits": 127,
      "replies": 6,
      "top": 0,
      "essence": 0,
      "hot": 0,
      "vote": 0,
      "pic_path": ""
    },
    {
      "board_id": 24,
      "topic_id": 301857,
      "type_id": 34,
      "sort_id": 0,
      "subject":
          "SRAM X4 \u548c X7 \u540e\u62e8\u533a\u522b\u8fd9\u4e24\u6b3e\u5dee\u522b\u5728\u54ea\u91cc\uff1f X4\u80fd\u652f\u63019\u901f\u4e48\uff1f\u53e6\u5916 ..",
      "status": 0,
      "title":
          "SRAM X4 \u548c X7 \u540e\u62e8\u533a\u522b \u957f\u817f \u4e2d\u817f \u77ed\u817f \u5982\u4f55\u533a\u5206\uff1f",
      "user_id": 159454,
      "last_reply_date": "1561369869000",
      "user_nick_name": "Airboss",
      "hits": 89,
      "replies": 4,
      "top": 0,
      "essence": 0,
      "hot": 0,
      "vote": 0,
      "pic_path": ""
    },
    {
      "board_id": 24,
      "topic_id": 301787,
      "type_id": 37,
      "sort_id": 0,
      "subject":
          "\u8bf7\u6559\u4e0b\u5404\u4f4d\u5927\u795e\uff0c5501\u957f\u817f\u540e\u62e8\uff0c\u752832\u98de\u8f6e\uff0c\u9700\u8981\u8c03\u5f20\u529b\u87ba\u4e1d\u8c03\u6574\u540e ..",
      "status": 0,
      "title":
          "\u8bf7\u6559\u4e0b5501\u540e\u62e8\u5f20\u529b\u87ba\u4e1d\u8c03\u8282",
      "user_id": 161055,
      "last_reply_date": "1561169015000",
      "user_nick_name": "yexingyang",
      "hits": 90,
      "replies": 10,
      "top": 0,
      "essence": 0,
      "hot": 1,
      "vote": 0,
      "pic_path": ""
    },
    {
      "board_id": 12,
      "topic_id": 301684,
      "type_id": 19,
      "sort_id": 0,
      "subject":
          "FSA\u7259\u76d8 BB386\uff0c BCD110\uff0c\u817f172.5 52\/36T \u95ea\u7535tarmac\u62c6\u8f66\uff0c\u4f7f\u75281 ..",
      "status": 0,
      "title":
          "\u7ec4\u8f66\u4f59\u4e0b\u96f6\u4ef6\u51fa\u552e\uff0c\u7259\u76d8\uff0c\u6307\u62e8\uff0c\u524d\u540e\u62e8\uff0c\u6cb9\u789f",
      "user_id": 164190,
      "last_reply_date": "1561215728000",
      "user_nick_name": "tom_yang",
      "hits": 397,
      "replies": 8,
      "top": 0,
      "essence": 0,
      "hot": 0,
      "vote": 0,
      "pic_path": ""
    },
    {
      "board_id": 2,
      "topic_id": 301645,
      "type_id": 74,
      "sort_id": 0,
      "subject":
          "\u6253\u7b97\u6362\u4e2a\u5c0f\u9e7f\u540e\u62e8\uff0c\u542c\u8bf4\u5728\u6298\u53e0\u8f66\u4e0a\u5c0f\u9e7f\u6bd4105\u4ec0\u4e48\u7684\u8212\u670d\u3002\u53ef\u4e0d\u60f3 ..",
      "status": 0,
      "title": "\u5c0f\u9e7f\u540e\u62e8\u7528\u5565\u540e\u62e8",
      "user_id": 165833,
      "last_reply_date": "1560849444000",
      "user_nick_name": "\u5927\u5927\u602a",
      "hits": 304,
      "replies": 21,
      "top": 0,
      "essence": 0,
      "hot": 1,
      "vote": 0,
      "pic_path":
          "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/xgsize\/Mon_1906\/2_165833_6770f6db3701096.jpg"
    },
    {
      "board_id": 2,
      "topic_id": 301585,
      "type_id": 70,
      "sort_id": 0,
      "subject":
          "4700\u540e\u62e8\u5bfc\u8f6e\u8ddd\u79bb60mm\uff0c\u5e94\u8be5\u662f\u77ed\u817f\u5427\uff0c\u521a\u6362\u4e86\u4e2a12-32\uff08\u4e24S\u5408\u4f53\uff09 ..",
      "status": 0,
      "title":
          "\u5206\u4eab\u4e00\u4e0b\uff1a4700\u77ed\u817f\u540e\u62e8\u652f\u6301\u591a\u5927\u7684\u98de\u8f6e",
      "user_id": 125521,
      "last_reply_date": "1560613015000",
      "user_nick_name": "leica",
      "hits": 224,
      "replies": 8,
      "top": 0,
      "essence": 0,
      "hot": 0,
      "vote": 0,
      "pic_path":
          "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/xgsize\/Mon_1906\/2_125521_03e2afe7d66c079.jpg"
    },
    {
      "board_id": 12,
      "topic_id": 301455,
      "type_id": 19,
      "sort_id": 0,
      "subject":
          "sram red\u540e\u62e8\uff0cxx\u6307\u62e8\uff0cred1090\u98de\u8f6e11-25\uff0ckmc\u5168\u697c\u7a7a10\u901f\u91d1\u8272\u94fe ..",
      "status": 0,
      "title": "sram red\u540e\u62e8\uff0cxx\u6307\u62e8",
      "user_id": 94162,
      "last_reply_date": "1561586695000",
      "user_nick_name": "q18105816",
      "hits": 297,
      "replies": 7,
      "top": 0,
      "essence": 0,
      "hot": 0,
      "vote": 0,
      "pic_path":
          "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/xgsize\/Mon_1906\/12_94162_485688ed3d155a2.jpg"
    },
    {
      "board_id": 12,
      "topic_id": 301447,
      "type_id": 19,
      "sort_id": 0,
      "subject":
          "\u8fea\u5361\u4facrc500\u62c6\u8f66\u8f6e\u7ec4 \u789f\u5239\u516c\u8def\u8f6e\u7ec4 \u5168\u65b0\u62c6\u8f66\u4ef6\u57f9\u6797\u82b1\u9f13\uff0c\u524d100*9 ..",
      "status": 0,
      "title":
          "700C\u789f\u5239\u8f6e\u7ec4 \u5fae\u8f6c\u540e\u62e8 SORA\u524d\u62e8 \u6c49\u65af\u673a\u68b0\u789f\u5239",
      "user_id": 83914,
      "last_reply_date": "1560324624000",
      "user_nick_name": "\u9739\u96f3\u6e38\u4fa0",
      "hits": 166,
      "replies": 6,
      "top": 0,
      "essence": 0,
      "hot": 0,
      "vote": 0,
      "pic_path":
          "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/xgsize\/Mon_1906\/12_83914_dbdf03904dd6bcf.jpg"
    },
    {
      "board_id": 12,
      "topic_id": 301439,
      "type_id": 19,
      "sort_id": 0,
      "subject":
          "\u94f6\u8272\u8001\u6b3e9\u901fX7\u540e\u62e850\u51fa\u540e\u62e89\u901f\u6b63\u5e38\u6ca1\u95ee\u9898\u6709\u9700\u8981\u7684\u575b\u4e0a\u6807\u51c6\u8bed\uff1a\u6211 ..",
      "status": 0,
      "title": "\u94f6\u8272\u8001\u6b3e9\u901fX7\u540e\u62e8\uff0c50\u51fa",
      "user_id": 86709,
      "last_reply_date": "1560308858000",
      "user_nick_name": "gpweijian",
      "hits": 199,
      "replies": 13,
      "top": 0,
      "essence": 0,
      "hot": 1,
      "vote": 0,
      "pic_path":
          "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/xgsize\/Mon_1906\/12_86709_1aa880b2b891c6f.jpg"
    },
    {
      "board_id": 24,
      "topic_id": 301435,
      "type_id": 34,
      "sort_id": 0,
      "subject":
          "\u76ee\u524d\u7684\u60c5\u51b5\u662f\uff0c\u6211\u7259\u76d8\u662f11\u901f\u6b63\u8d1f\u9f7f\uff0c\u94fe\u6761\u7528sram1170\uff0c\u5355\u7247\u98de\u8f6e\u4e5f ..",
      "status": 0,
      "title":
          "\u6c42\u52a9\uff0c\u5173\u4e8e\u7528\u540e\u62e8\u505a\u538b\u94fe\u5668",
      "user_id": 153064,
      "last_reply_date": "1561027255000",
      "user_nick_name": "\u8c46\u5305\u5b50",
      "hits": 153,
      "replies": 16,
      "top": 0,
      "essence": 0,
      "hot": 1,
      "vote": 0,
      "pic_path": ""
    },
    {
      "board_id": 12,
      "topic_id": 301387,
      "type_id": 20,
      "sort_id": 0,
      "subject":
          "\u5982\u9898\uff0c\u6210\u8272\u4f73\u4f18\u5148\uff0c\u94f6\u8272\/\u767d\u8272\u4f18\u5148\u3002\u5982\u6709\u4ef7\u683c\u5408\u9002\u7684X7\u4ea6\u53ef\u3002QQ775 ..",
      "status": 0,
      "title": "\u653610\u901fX7\u540e\u62e8",
      "user_id": 35168,
      "last_reply_date": "1560211242000",
      "user_nick_name": "seanfv",
      "hits": 107,
      "replies": 8,
      "top": 0,
      "essence": 0,
      "hot": 0,
      "vote": 0,
      "pic_path": ""
    },
    {
      "board_id": 12,
      "topic_id": 301244,
      "type_id": 19,
      "sort_id": 0,
      "subject":
          "\u7259\u76d8\uff1atriban rc500\u62c6\u8f66\u4ef6\uff0c\u5356\u573a\u5185\u8bd5\u9a91\u4e0d\u8d85\u8fc7500\u7c73\uff0c170\uff0c\u538b\u7f29\u76d8 ..",
      "status": 0,
      "title":
          "\u51fa R3000\u7259\u76d8 \u5fae\u8f6c\u516c\u8def\u540e\u62e8 BTWIN\u5934\u76d4",
      "user_id": 83914,
      "last_reply_date": "1560229089000",
      "user_nick_name": "\u9739\u96f3\u6e38\u4fa0",
      "hits": 199,
      "replies": 3,
      "top": 0,
      "essence": 0,
      "hot": 0,
      "vote": 0,
      "pic_path":
          "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/xgsize\/Mon_1906\/12_83914_fadf6b5caef3741.jpg"
    },
    {
      "board_id": 31,
      "topic_id": 301165,
      "type_id": 40,
      "sort_id": 0,
      "subject":
          "105  r7000\u540e\u62e8 \u4e2d\u817f\u53ef\u4ee5\u652f\u6301\u523034t  \u6709\u957f\u817f\u5417\u6765\u81ea[Android]\u624b\u673a ..",
      "status": 0,
      "title": "105  r7000\u540e\u62e8",
      "user_id": 161262,
      "last_reply_date": "1560521831000",
      "user_nick_name": "\u4e00\u9a91\u5f53\u4edf",
      "hits": 305,
      "replies": 16,
      "top": 0,
      "essence": 0,
      "hot": 1,
      "vote": 0,
      "pic_path": ""
    },
    {
      "board_id": 31,
      "topic_id": 301160,
      "type_id": 40,
      "sort_id": 0,
      "subject":
          "\u6309\u5b98\u65b9\u8bf4\u660e\uff0c\u5c06\u94fe\u6761\u6302\u5728\u6700\u5927\u98de\u8f6e\u548c\u6700\u5927\u76d8\u7247\u4e0a\uff0c\u7136\u540e\u5982\u56fe\u52a0\u4e86\u4e24\u622a ..",
      "status": 0,
      "title":
          "\u5173\u4e8eR8000\u540e\u62e8\u5f20\u529b\uff0c\u94fe\u6761\u957f\u5ea6\u7684\u95ee\u9898",
      "user_id": 92427,
      "last_reply_date": "1559693265000",
      "user_nick_name": "\u7231\u5403\u9e21\u86cb",
      "hits": 455,
      "replies": 34,
      "top": 0,
      "essence": 0,
      "hot": 1,
      "vote": 0,
      "pic_path":
          "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/xgsize\/Mon_1906\/31_92427_b43477c44b4a41e.jpg"
    },
    {
      "board_id": 12,
      "topic_id": 301077,
      "type_id": 19,
      "sort_id": 0,
      "subject":
          "\u5982\u9898 \u540e\u62e8\u6210\u8272\u4e0d\u9519 9-95 \u94fe\u6761\u4f7f\u7528\u534a\u5e74 50-34\u5e2611-28\u9f7f\u6bd4\u8fd8\u957f\u4e86\u4e00 ..",
      "status": 0,
      "title":
          "\u90fd\u5df2\u51fa etap \u539f\u88c5\u540e\u62e8\u9e21\u817f ybn\u9ed1\u91d1\u5168\u9542\u7a7a\u94fe\u6761",
      "user_id": 107907,
      "last_reply_date": "1559429688000",
      "user_nick_name": "thankycc",
      "hits": 164,
      "replies": 4,
      "top": 0,
      "essence": 0,
      "hot": 0,
      "vote": 0,
      "pic_path":
          "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/xgsize\/Mon_1906\/12_107907_3aa30a1991414d5.png"
    },
    {
      "board_id": 12,
      "topic_id": 301063,
      "type_id": 19,
      "sort_id": 0,
      "subject":
          "force22 \u524d\u540e\u62e8\u98de\u8f6e\u6253\u5305\u98de\u8f6e1170 11-26t\u90012stone\u6b63\u8d1f\u9f7f\u5907\u7528\u4ef6\u51fa6 ..",
      "status": 0,
      "title": "force22 \u524d\u540e\u62e8\u98de\u8f6e\u6253\u5305",
      "user_id": 162280,
      "last_reply_date": "1559461626000",
      "user_nick_name": "Ds-J1n",
      "hits": 129,
      "replies": 4,
      "top": 0,
      "essence": 0,
      "hot": 0,
      "vote": 0,
      "pic_path":
          "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/xgsize\/Mon_1906\/12_162280_8df839ece83cf5f.jpg"
    },
    {
      "board_id": 12,
      "topic_id": 301029,
      "type_id": 19,
      "sort_id": 0,
      "subject":
          "\u5168\u90e8\u5168\u65b0\uff0c\u987a\u4e30\u5305\u90ae\u5230\u706b\u661f[ \u6b64\u5e16\u88abxxxxxjack\u57282019-05-31 21:13 ..",
      "status": 0,
      "title":
          "6600\u94f6\u8272\u77ed\u817f\u540e\u62e8PWPWlp\u66f2\u67c4PWPWgyes\u5750\u57ab",
      "user_id": 161783,
      "last_reply_date": "1559546000000",
      "user_nick_name": "xxxxxjack",
      "hits": 237,
      "replies": 8,
      "top": 0,
      "essence": 0,
      "hot": 0,
      "vote": 0,
      "pic_path":
          "http:\/\/bbs.77bike.com\/mobcent\/app\/runtime\/images\/xgsize\/Mon_1905\/12_161783_23dd83086bab22b.jpg"
    }
  ],
  "searchid": 0
};
*/
