/*
accessSecret	f01b3418e99ebdc5fda5fa3b8b9c2
accessToken	ac3f19b94085e3b86c228b54f71c7
apphash	9425b1e8
forumKey	itTovrNYj6jgmwUBcQ
sdkVersion	2.4.0
*/
import 'package:jaguar_serializer/jaguar_serializer.dart';

import '../common.dart';

part 'forum_forumlist.jser.dart';

class ForumListAction {
  static const String action = "forum/forumlist";

  static Map<String, dynamic> buildRequest() => {};

  static ForumListResponse parseResponse(Map<String, dynamic> response) {
    return ForumListResponseSerializer().fromMap(response);
  }
}

class ForumListResponse extends MobcentResponse {
  List<BoardCategory> list;
  int online_user_num;
  String img_url;
  int td_visitors;

  ForumListResponse(
      {this.list = const [],
      this.online_user_num = 0,
      this.img_url = "",
      this.td_visitors = 0});
}

class BoardCategory {
  int board_category_id;
  String board_category_name;
  int board_category_type;
  List<Board> board_list;

  BoardCategory(
      {this.board_category_id,
      this.board_category_name,
      this.board_category_type,
      this.board_list = const []});
}

class Board {
  int board_id;
  String board_name;
  String description;
  int board_child;
  String board_img;
  int board_content;
  int td_posts_num;
  int topic_total_num;
  int posts_total_num;
  String last_posts_date;
  String forumRedirect;
  int is_focus;

  DateTime get last_posts_date_value =>
      DateTime.fromMillisecondsSinceEpoch(int.tryParse(this.last_posts_date));
}

@GenSerializer()
class ForumListResponseSerializer extends Serializer<ForumListResponse>
    with _$ForumListResponseSerializer {}

@GenSerializer()
class BoardCategorySerializer extends Serializer<BoardCategory>
    with _$BoardCategorySerializer {}

@GenSerializer()
class BoardSerializer extends Serializer<Board> with _$BoardSerializer {}

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
  "online_user_num": 0,
  "img_url": "",
  "td_visitors": 0,
  "list": [
    {
      "board_category_id": 1,
      "board_category_name": "\u5355\u8f66\u9891\u9053",
      "board_category_type": 2,
      "board_list": [
        {
          "board_id": 23,
          "board_name": "\u7ad9\u52a1\u516c\u544a",
          "description":
              "\u2026\u2026\u8bba\u575b\u516c\u544a\u548c\u7ad9\u52a1\u4fe1\u606f\u516c\u793a\u533a\uff0c\u4e5f\u6b22\u8fce\u5927\u5bb6\u5bf9\u8bba\u575b\u7684\u53d1\u5c55\u63d0\u51fa\u5efa\u8bae\uff0c\u975e\u7ad9\u52a1\u5185\u5bb9\u8bf7\u52ff\u53d1\u5e03",
          "board_child": 0,
          "board_img": "",
          "board_content": 1,
          "td_posts_num": 0,
          "topic_total_num": 1773,
          "posts_total_num": 30563,
          "last_posts_date": "1562583631000",
          "forumRedirect": "",
          "is_focus": 0
        },
        {
          "board_id": 51,
          "board_name": "77\u65b0\u624b\u6751",
          "description":
              "\u2026\u2026\u65b0\u4eba\u8bf7\u5148\u9605\u8bfb\u7f6e\u9876\u8d34\uff0c\u5b8c\u6210\u65b0\u4eba\u4efb\u52a1\u540e\u65b9\u53ef\u83b7\u5f97\u5176\u4ed6\u677f\u5757\u53d1\u5e16\u6743\u3002\u672c\u533a\u4ec5\u9650\u5e7c\u513f\u56ed\u53d1\u5e16",
          "board_child": 0,
          "board_img": "",
          "board_content": 1,
          "td_posts_num": 0,
          "topic_total_num": 14163,
          "posts_total_num": 213265,
          "last_posts_date": "1562370245000",
          "forumRedirect": "",
          "is_focus": 0
        },
        {
          "board_id": 24,
          "board_name": "\u63d0\u95ee\u89e3\u7b54",
          "description":
              "\u2026\u2026\u767e\u5ea6\u4e0d\u77e5\u9053\u768477\u90fd\u77e5\u9053\u3002\u6709\u95ee\u9898\u8bf7\u5148\u641c\u5173\u952e\u8bcd\u548c\u7cbe\u534e\u533a\uff0c\u517b\u6210\u826f\u597d\u8bba\u575b\u4e60\u60ef\u624d\u662f\u597d\u540c\u5b66",
          "board_child": 0,
          "board_img": "",
          "board_content": 1,
          "td_posts_num": 79,
          "topic_total_num": 54462,
          "posts_total_num": 782268,
          "last_posts_date": "1562805428000",
          "forumRedirect": "",
          "is_focus": 0
        },
        {
          "board_id": 13,
          "board_name": "\u6d3b\u52a8\u6e38\u8bb0",
          "description":
              "\u2026\u2026\u8fd9\u91cc\u662f\u53d1\u8d77\u6d3b\u52a8\u548c\u53d1\u8868\u6e38\u8bb0\u7684\u5730\u65b9\u3002\u4f11\u95f2\u4e5f\u597d\uff0c\u81ea\u8650\u4e5f\u597d\uff0c\u91cd\u8981\u7684\u662f\u548c\u5927\u5bb6\u5206\u4eab\u5feb\u4e50\uff01",
          "board_child": 1,
          "board_img": "",
          "board_content": 1,
          "td_posts_num": 1,
          "topic_total_num": 11367,
          "posts_total_num": 313990,
          "last_posts_date": "1562646358000",
          "forumRedirect": "",
          "is_focus": 0
        },
        {
          "board_id": 31,
          "board_name": "\u516c\u8def\u5c71\u5730",
          "description":
              "\u2026\u2026\u516c\u8def\u8f66\u3001\u5c71\u5730\u8f66\u3001\u65c5\u884c\u8f66\u3001\u6b7b\u98de\u8f66\uff0c\u9ad8\u7cbe\u5c16\u96f6\u4ef6\u3001\u5de5\u5177\u3001\u6539\u88c5\u3002\u5404\u79cd\u524d\u6cbf\u9ed1\u79d1\u6280\u7b49\u4f60\u6765\u63a2\u8ba8\uff01",
          "board_child": 0,
          "board_img": "",
          "board_content": 1,
          "td_posts_num": 1,
          "topic_total_num": 8243,
          "posts_total_num": 239490,
          "last_posts_date": "1562669600000",
          "forumRedirect": "",
          "is_focus": 0
        },
        {
          "board_id": 2,
          "board_name": "\u6298\u53e0\u5c0f\u8f6e\u5f84",
          "description":
              "\u2026\u2026\u6298\u53e0\u8f66\u4e0e\u5c0f\u8f6e\u5f84\u8f66\u7684\u6280\u672f\u8ba8\u8bba\u533a\uff0c\u6280\u672f\u542b\u91cf\u4f4e\u7684\u5e16\u5b50\u8bf7\u53d177\u65b0\u624b\u6751\uff0c\u63d0\u95ee\u8bf7\u79fb\u6b65\u63d0\u95ee\u89e3\u7b54\u533a",
          "board_child": 0,
          "board_img": "",
          "board_content": 1,
          "td_posts_num": 54,
          "topic_total_num": 16082,
          "posts_total_num": 479491,
          "last_posts_date": "1562804775000",
          "forumRedirect": "",
          "is_focus": 0
        },
        {
          "board_id": 5,
          "board_name": "\u8d85\u7ea7\u79c0\u8f66",
          "description":
              "\u2026\u2026\u5343\u8f9b\u4e07\u82e6\u6512\u4e86\u4e00\u5806\u96f6\u4ef6\uff0c\u7ec4\u597d\u7684\u9753\u8f66\u7ec8\u4e8e\u53ef\u4ee5\u62ff\u51fa\u6765show\u4e86\uff01 \u4e5f\u53ef\u4ee5\u79c0\u6f02\u4eae\u7684\u96f6\u4ef6\uff01",
          "board_child": 1,
          "board_img": "",
          "board_content": 1,
          "td_posts_num": 13,
          "topic_total_num": 19149,
          "posts_total_num": 656502,
          "last_posts_date": "1562774006000",
          "forumRedirect": "",
          "is_focus": 0
        },
        {
          "board_id": 53,
          "board_name": "\u8fd0\u52a8\u8d5b\u4e8b",
          "description":
              "\u2026\u2026\u9a91\u884c\u6280\u672f\u548c\u8bad\u7ec3\u65b9\u6cd5\u3001\u8fd0\u52a8\u5b89\u5168\u548c\u5065\u5eb7\uff08\u4e0d\u9650\u4e8e\u9a91\u884c\uff09\u3001\u81ea\u884c\u8f66\u8d5b\u4e8b\u3001\u81ea\u884c\u8f66\u5c55\u4f1a",
          "board_child": 0,
          "board_img": "",
          "board_content": 1,
          "td_posts_num": 0,
          "topic_total_num": 555,
          "posts_total_num": 12845,
          "last_posts_date": "1560423924000",
          "forumRedirect": "",
          "is_focus": 0
        },
        {
          "board_id": 106,
          "board_name": "\u7535\u52a8\u4f60\u597d",
          "description":
              "\u2026\u2026\u5e26\u7535\u7684\uff01\u725b\u903c\u554a\uff01\u4e0d\u670d\u4f60\u6765\u8ffd\u6211\u5440\uff01\u7eaf\u7535\u3001\u8089\u7535\u6df7\u52a8\u90fd\u5230\u8fd9\u91cc\u6765\u62a5\u5230\uff01",
          "board_child": 0,
          "board_img": "",
          "board_content": 1,
          "td_posts_num": 0,
          "topic_total_num": 555,
          "posts_total_num": 11991,
          "last_posts_date": "1561557311000",
          "forumRedirect": "",
          "is_focus": 0
        },
        {
          "board_id": 108,
          "board_name": "\u5171\u4eab\u5355\u8f66\u548c\u4e70\u83dc\u8f66",
          "description":
              "\u2026\u2026\u6469\u62dcofo\u4f60\u559c\u6b22\u9a91\u54ea\u4e2a\uff1f\u771f\u7684\u53ea\u6709\u4e70\u83dc\u8f66\u624d\u80fd\u5e26\u59b9\u5b50\uff1f\u901a\u52e4\u7248\u6bcf\u5929\u90fd\u6709\u65b0\u9c9c\u8bdd\u9898\uff01",
          "board_child": 0,
          "board_img": "",
          "board_content": 1,
          "td_posts_num": 0,
          "topic_total_num": 187,
          "posts_total_num": 2719,
          "last_posts_date": "1561470686000",
          "forumRedirect": "",
          "is_focus": 0
        }
      ]
    },
    {
      "board_category_id": 37,
      "board_category_name": "\u751f\u6d3b\u9891\u9053",
      "board_category_type": 2,
      "board_list": [
        {
          "board_id": 38,
          "board_name": "\u6d6e\u5149\u63a0\u5f71",
          "description":
              "\u2026\u2026\u6b63\u5f0f\u5f00\u7248\u55bd\uff01 \u6b22\u8fce\u4e0a\u4f20\u539f\u521b\u4f5c\u54c1\uff0c\u5206\u4eab\u6444\u5f71\u7cbe\u54c1\uff01",
          "board_child": 0,
          "board_img": "",
          "board_content": 1,
          "td_posts_num": 17,
          "topic_total_num": 4109,
          "posts_total_num": 80396,
          "last_posts_date": "1562744617000",
          "forumRedirect": "",
          "is_focus": 0
        },
        {
          "board_id": 48,
          "board_name": "\u673a\u52a8\u8f66\u9053",
          "description":
              "\u2026\u2026\u7acb\u5fd7\u6253\u8d25\u6c7d\u8f66\u4e4b\u5bb6\uff0c\u54c7\u54c8\u54c8\u54c8\uff01",
          "board_child": 0,
          "board_img": "",
          "board_content": 1,
          "td_posts_num": 0,
          "topic_total_num": 4567,
          "posts_total_num": 119847,
          "last_posts_date": "1561646082000",
          "forumRedirect": "",
          "is_focus": 0
        },
        {
          "board_id": 32,
          "board_name": "\u73a9\u4e3b\u8d25\u5bb6",
          "description":
              "\u2026\u2026\u9664\u4e86\u8f66\u5927\u5bb6\u4e00\u5b9a\u8fd8\u6709\u5176\u4ed6\u7231\u597d\u5427\uff1f\u8fd9\u91cc\u662f\u53d1\u70e7\u53cb\u4eec\u4ea4\u6d41\u3001\u4eae\u9a9a\u7684\u56ed\u5b50\uff01",
          "board_child": 1,
          "board_img": "",
          "board_content": 1,
          "td_posts_num": 0,
          "topic_total_num": 2853,
          "posts_total_num": 74663,
          "last_posts_date": "1561623720000",
          "forumRedirect": "",
          "is_focus": 0
        },
        {
          "board_id": 15,
          "board_name": "\u751f\u6d3b\u95f2\u804a",
          "description":
              "\u2026\u2026\u73a9\u8f66\u9a91\u8f66\u7d2f\u4e86\u4e4b\u540e\u5927\u5bb6\u53ef\u4ee5\u6765\u8fd9\u91cc\u804a\u804a\u5929\uff0c\u53d1\u53d1\u5446\uff0c\u751f\u6d3b\u3001\u5de5\u4f5c\u3001\u7231\u60c5\u3001\u6d77\u9614\u5929\u7a7a",
          "board_child": 0,
          "board_img": "",
          "board_content": 1,
          "td_posts_num": 6,
          "topic_total_num": 38421,
          "posts_total_num": 768010,
          "last_posts_date": "1562805079000",
          "forumRedirect": "",
          "is_focus": 0
        }
      ]
    },
    {
      "board_category_id": 39,
      "board_category_name": "\u5546\u4e1a\u9891\u9053",
      "board_category_type": 2,
      "board_list": [
        {
          "board_id": 73,
          "board_name": "\u5546\u4e1a\u8d44\u8baf",
          "description":
              "\u2026\u2026\u5382\u5546\u8d44\u8baf\u53d1\u5e03\u4e13\u533a\uff0c\u4e0d\u5f97\u53d1\u5e03\u4e0e\u81ea\u884c\u8f66\u884c\u4e1a\u65e0\u5173\u7684\u8baf\u606f\uff0c\u672c\u533a\u4e25\u7981\u53d1\u5e03\u5404\u7c7b\u9500\u552e\u4fe1\u606f",
          "board_child": 0,
          "board_img": "",
          "board_content": 1,
          "td_posts_num": 0,
          "topic_total_num": 448,
          "posts_total_num": 9841,
          "last_posts_date": "1562594412000",
          "forumRedirect": "",
          "is_focus": 0
        },
        {
          "board_id": 42,
          "board_name": "\u8d60\u9001\u4e49\u5356",
          "description":
              "\u2026\u2026\u4e50\u5584\u597d\u65bd\uff0c\u4e0d\u8c0b\u5c0f\u5229\uff0c\u5949\u732e\u7231\u5fc3\u3002\u5c06\u95f2\u7f6e\u7269\u54c1\u8d60\u4e88\u6709\u9700\u6c42\u7684\u4eba\u3002\u5c0f\u4e09\u53d1\u5e16\uff0c\u5c0f\u4e00\u56de\u5e16",
          "board_child": 0,
          "board_img": "",
          "board_content": 1,
          "td_posts_num": 0,
          "topic_total_num": 2927,
          "posts_total_num": 47131,
          "last_posts_date": "1562587234000",
          "forumRedirect": "",
          "is_focus": 0
        },
        {
          "board_id": 36,
          "board_name": "\u56e2\u8d2d\u5546\u5bb6",
          "description":
              "\u2026\u2026\u56e2\u8d2d\u548c\u5546\u5bb6\u9500\u552e\u4e13\u533a\uff0c\u8bf7\u9075\u5b88\u54c1\u724c\u89c4\u5b9a\uff0c\u52ff\u6270\u4e71\u6b63\u5e38\u5e02\u573a\u3002\u672c\u7248\u5c0f\u4e00\u56de\u5e16",
          "board_child": 0,
          "board_img": "",
          "board_content": 1,
          "td_posts_num": 0,
          "topic_total_num": 2756,
          "posts_total_num": 83058,
          "last_posts_date": "1561302063000",
          "forumRedirect": "",
          "is_focus": 0
        },
        {
          "board_id": 12,
          "board_name": "\u4e2a\u4eba\u4ea4\u6613",
          "description":
              "\u2026\u2026\u8f66\u53cb\u95f2\u7f6e\u96f6\u4ef6\u8df3\u86a4\u5e02\u573a\uff0c\u4e5f\u53ef\u51fa\u552e\u548c\u5355\u8f66\u65e0\u5173\u7684\u4e2a\u4eba\u7269\u54c1\u3002\u672c\u7248\u5c0f\u4e00\u53d1\u5e16\uff0c\u5927\u73ed\u56de\u5e16",
          "board_child": 1,
          "board_img": "",
          "board_content": 1,
          "td_posts_num": 61,
          "topic_total_num": 76931,
          "posts_total_num": 1143213,
          "last_posts_date": "1562781418000",
          "forumRedirect": "",
          "is_focus": 0
        }
      ]
    },
    {
      "board_category_id": 100,
      "board_category_name": "\u54c1\u724c\u4e13\u533a",
      "board_category_type": 2,
      "board_list": [
        {
          "board_id": 86,
          "board_name": "Pacific \u592a\u5e73\u6d0b",
          "description": "",
          "board_child": 0,
          "board_img": "",
          "board_content": 1,
          "td_posts_num": 0,
          "topic_total_num": 28,
          "posts_total_num": 541,
          "last_posts_date": "1554129997000",
          "forumRedirect": "",
          "is_focus": 0
        },
        {
          "board_id": 88,
          "board_name": "fnhon \u98ce\u884c",
          "description": "",
          "board_child": 0,
          "board_img": "",
          "board_content": 1,
          "td_posts_num": 0,
          "topic_total_num": 27,
          "posts_total_num": 1725,
          "last_posts_date": "1553771806000",
          "forumRedirect": "",
          "is_focus": 0
        },
        {
          "board_id": 89,
          "board_name": "700bike \u67d2\u4f70",
          "description": "",
          "board_child": 0,
          "board_img": "",
          "board_content": 1,
          "td_posts_num": 0,
          "topic_total_num": 48,
          "posts_total_num": 345,
          "last_posts_date": "1522293039000",
          "forumRedirect": "",
          "is_focus": 0
        },
        {
          "board_id": 101,
          "board_name": "MAITU \u8109\u9014",
          "description": "",
          "board_child": 0,
          "board_img": "",
          "board_content": 1,
          "td_posts_num": 0,
          "topic_total_num": 15,
          "posts_total_num": 308,
          "last_posts_date": "1559055815000",
          "forumRedirect": "",
          "is_focus": 0
        },
        {
          "board_id": 96,
          "board_name": "\u7c73\u6d1b",
          "description": "",
          "board_child": 0,
          "board_img": "",
          "board_content": 1,
          "td_posts_num": 0,
          "topic_total_num": 8,
          "posts_total_num": 255,
          "last_posts_date": "1547002567000",
          "forumRedirect": "",
          "is_focus": 0
        },
        {
          "board_id": 95,
          "board_name": "fitibike\u98de\u767e\u5ba2",
          "description": "",
          "board_child": 0,
          "board_img": "",
          "board_content": 1,
          "td_posts_num": 0,
          "topic_total_num": 8,
          "posts_total_num": 121,
          "last_posts_date": "1505961972000",
          "forumRedirect": "",
          "is_focus": 0
        },
        {
          "board_id": 97,
          "board_name": "COOANT",
          "description": "",
          "board_child": 0,
          "board_img": "",
          "board_content": 1,
          "td_posts_num": 0,
          "topic_total_num": 0,
          "posts_total_num": 0,
          "last_posts_date": "1463015913000",
          "forumRedirect": "",
          "is_focus": 0
        },
        {
          "board_id": 93,
          "board_name": "\u54c1\u724c\u4e13\u533a8",
          "description": "",
          "board_child": 0,
          "board_img": "",
          "board_content": 1,
          "td_posts_num": 0,
          "topic_total_num": 0,
          "posts_total_num": 0,
          "last_posts_date": "1502708075000",
          "forumRedirect": "",
          "is_focus": 0
        },
        {
          "board_id": 102,
          "board_name": "OYAMA\u6b27\u4e9a\u9a6c",
          "description": "",
          "board_child": 0,
          "board_img": "",
          "board_content": 1,
          "td_posts_num": 0,
          "topic_total_num": 43,
          "posts_total_num": 1025,
          "last_posts_date": "1552896558000",
          "forumRedirect": "",
          "is_focus": 0
        },
        {
          "board_id": 103,
          "board_name": "MaxtroN \u7f8e\u58ee",
          "description": "",
          "board_child": 0,
          "board_img": "",
          "board_content": 1,
          "td_posts_num": 0,
          "topic_total_num": 15,
          "posts_total_num": 255,
          "last_posts_date": "1547106365000",
          "forumRedirect": "",
          "is_focus": 0
        },
        {
          "board_id": 104,
          "board_name": "\u8d85\u60a6\u667a\u80fd\u7535\u5355\u8f66",
          "description": "",
          "board_child": 0,
          "board_img": "",
          "board_content": 1,
          "td_posts_num": 0,
          "topic_total_num": 201,
          "posts_total_num": 1121,
          "last_posts_date": "1540453290000",
          "forumRedirect": "",
          "is_focus": 0
        },
        {
          "board_id": 105,
          "board_name": "RIDEA \u745e\u5b9c\u8fbe",
          "description": "",
          "board_child": 0,
          "board_img": "",
          "board_content": 1,
          "td_posts_num": 0,
          "topic_total_num": 15,
          "posts_total_num": 390,
          "last_posts_date": "1492673576000",
          "forumRedirect": "",
          "is_focus": 0
        }
      ]
    }
  ]
};
*/
