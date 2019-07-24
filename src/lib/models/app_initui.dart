/*
accessSecret
accessToken
apphash	9425b1e8
forumKey	itTovrNYj6jgmwUBcQ
sdkVersion	2.4.0
*/
import 'package:jaguar_serializer/jaguar_serializer.dart';

import 'common.dart';

part 'app_initui.jser.dart';

class AppInitUIAction {
  static const String action = "app/initui";

  static Map<String, dynamic> buildRequest() => {};

  static AppInitUIResponse parseResponse(Map<String, dynamic> response) {
    return AppInitUIResponseSerializer().fromMap(response);
  }
}

@GenSerializer()
class AppInitUIResponseSerializer extends Serializer<AppInitUIResponse>
    with _$AppInitUIResponseSerializer {}

@GenSerializer()
class _ResponseBodySerializer extends Serializer<_ResponseBody>
    with _$_ResponseBodySerializer {}

@GenSerializer()
class ModuleSerializer extends Serializer<Module> with _$ModuleSerializer {}

@GenSerializer()
class NavigationSerializer extends Serializer<Navigation>
    with _$NavigationSerializer {}

@GenSerializer()
class NavItemSerializer extends Serializer<NavItem> with _$NavItemSerializer {}

class AppInitUIResponse extends MobcentResponse {
  _ResponseBody body;
}

class _ResponseBody {
  List<Module> moduleList;

  /// 底部导航栏条目及顺序
  Navigation navigation;

  _ResponseBody({this.moduleList = const [], this.navigation});
}

class Module {
  int id;
  String type;
  String style;
  String title;

  /// full url
  String icon;
}

class Navigation {
  String type = "bottom";
  List<NavItem> navItemList;

  Navigation({this.type, this.navItemList = const []});
}

class NavItem {
  int moduleId;
  String title;
  String icon;
}

/*
const _sample = {
  "rs": 1,
  "errcode": "",
  "head": {"errCode": "", "errInfo": null, "version": "2.4.0.1", "alert": 0},
  "body": {
    "navigation": {
      "type": "bottom",
      "navItemList": [
        {
          "moduleId": 3,
          "title": "\u9996\u9875",
          "icon": "mc_forum_main_bar_button1"
        },
        {
          "moduleId": 4,
          "title": "\u793e\u533a",
          "icon": "mc_forum_main_bar_button2"
        },
        {
          "moduleId": 2,
          "title": "\u5feb\u901f\u53d1\u8868",
          "icon": "mc_forum_main_bar_button17"
        },
        {
          "moduleId": 5,
          "title": "\u6d88\u606f",
          "icon": "mc_forum_main_bar_button4"
        },
        {
          "moduleId": 1,
          "title": "\u53d1\u73b0",
          "icon": "mc_forum_main_bar_button5"
        }
      ]
    },
    "moduleList": [
      {
        "id": 1,
        "type": "full",
        "style": "flat",
        "title": "\u53d1\u73b0",
        "icon":
            "http:\/\/bbs.77bike.com\/mobcent\/app\/web\/images\/admin\/module-default.png",
        "leftTopbars": [],
        "rightTopbars": [],
        "componentList": [
          {
            "id": "c13",
            "type": "discover",
            "style": "flat",
            "title": "",
            "desc": "",
            "icon": "",
            "iconStyle": "image",
            "componentList": [
              {
                "id": "c5",
                "type": "layout",
                "style": "discoverSlider",
                "title": "",
                "desc": "",
                "icon": "",
                "iconStyle": "image",
                "componentList": [],
                "extParams": {
                  "dataId": 0,
                  "titlePosition": "left",
                  "pageTitle": "",
                  "newsModuleId": 0,
                  "forumId": 0,
                  "moduleId": 0,
                  "topicId": 0,
                  "articleId": 0,
                  "fastpostForumIds": [],
                  "isShowTopicTitle": 1,
                  "isShowMessagelist": 0,
                  "filter": "",
                  "filterId": 0,
                  "order": 0,
                  "orderby": "",
                  "redirect": "",
                  "listTitleLength": 40,
                  "listSummaryLength": 40,
                  "listImagePosition": 2,
                  "subListStyle": "flat",
                  "subDetailViewStyle": "flat"
                }
              },
              {
                "id": "c11",
                "type": "layout",
                "style": "discoverDefault",
                "title": "",
                "desc": "",
                "icon": "",
                "iconStyle": "image",
                "componentList": [
                  {
                    "id": "c6",
                    "type": "userinfo",
                    "style": "flat",
                    "title": "\u4e2a\u4eba\u4e2d\u5fc3",
                    "desc": "",
                    "icon": "mc_forum_squre_icon9",
                    "iconStyle": "image",
                    "componentList": [],
                    "extParams": {
                      "dataId": 0,
                      "titlePosition": "left",
                      "pageTitle": "",
                      "newsModuleId": 0,
                      "forumId": 0,
                      "moduleId": 0,
                      "topicId": 0,
                      "articleId": 0,
                      "fastpostForumIds": [],
                      "isShowTopicTitle": 1,
                      "isShowMessagelist": 0,
                      "filter": "",
                      "filterId": 0,
                      "order": 0,
                      "orderby": "",
                      "redirect": "",
                      "listTitleLength": 40,
                      "listSummaryLength": 40,
                      "listImagePosition": 2,
                      "subListStyle": "flat",
                      "subDetailViewStyle": "flat"
                    }
                  },
                  {
                    "id": "c7",
                    "type": "userlist",
                    "style": "flat",
                    "title": "\u5468\u8fb9\u7528\u6237",
                    "desc": "",
                    "icon": "mc_forum_squre_icon5",
                    "iconStyle": "image",
                    "componentList": [],
                    "extParams": {
                      "filter": "all",
                      "orderby": "distance",
                      "fastpostForumIds": [],
                      "subListStyle": null,
                      "subDetailViewStyle": null
                    }
                  },
                  {
                    "id": "c8",
                    "type": "surroudingPostlist",
                    "style": "flat",
                    "title": "\u5468\u8fb9\u5e16\u5b50",
                    "desc": "",
                    "icon": "mc_forum_squre_icon4",
                    "iconStyle": "image",
                    "componentList": [],
                    "extParams": {
                      "dataId": 0,
                      "titlePosition": "left",
                      "pageTitle": "",
                      "newsModuleId": 0,
                      "forumId": 0,
                      "moduleId": 0,
                      "topicId": 0,
                      "articleId": 0,
                      "fastpostForumIds": [],
                      "isShowTopicTitle": 1,
                      "isShowMessagelist": 0,
                      "filter": "",
                      "filterId": 0,
                      "order": 0,
                      "orderby": "",
                      "redirect": "",
                      "listTitleLength": 40,
                      "listSummaryLength": 40,
                      "listImagePosition": 2,
                      "subListStyle": "flat",
                      "subDetailViewStyle": "flat"
                    }
                  },
                  {
                    "id": "c9",
                    "type": "userlist",
                    "style": "flat",
                    "title": "\u63a8\u8350\u7528\u6237",
                    "desc": "",
                    "icon": "mc_forum_squre_icon6",
                    "iconStyle": "image",
                    "componentList": [],
                    "extParams": {
                      "filter": "recommend",
                      "orderby": "dateline",
                      "fastpostForumIds": [],
                      "subListStyle": null,
                      "subDetailViewStyle": null
                    }
                  },
                  {
                    "id": "c10",
                    "type": "setting",
                    "style": "flat",
                    "title": "\u8bbe\u7f6e",
                    "desc": "",
                    "icon": "mc_forum_squre_icon7",
                    "iconStyle": "image",
                    "componentList": [],
                    "extParams": {
                      "dataId": 0,
                      "titlePosition": "left",
                      "pageTitle": "",
                      "newsModuleId": 0,
                      "forumId": 0,
                      "moduleId": 0,
                      "topicId": 0,
                      "articleId": 0,
                      "fastpostForumIds": [],
                      "isShowTopicTitle": 1,
                      "isShowMessagelist": 0,
                      "filter": "",
                      "filterId": 0,
                      "order": 0,
                      "orderby": "",
                      "redirect": "",
                      "listTitleLength": 40,
                      "listSummaryLength": 40,
                      "listImagePosition": 2,
                      "subListStyle": "flat",
                      "subDetailViewStyle": "flat"
                    }
                  }
                ],
                "extParams": {
                  "dataId": 0,
                  "titlePosition": "left",
                  "pageTitle": "",
                  "newsModuleId": 0,
                  "forumId": 0,
                  "moduleId": 0,
                  "topicId": 0,
                  "articleId": 0,
                  "fastpostForumIds": [],
                  "isShowTopicTitle": 1,
                  "isShowMessagelist": 0,
                  "filter": "",
                  "filterId": 0,
                  "order": 0,
                  "orderby": "",
                  "redirect": "",
                  "listTitleLength": 40,
                  "listSummaryLength": 40,
                  "listImagePosition": 2,
                  "subListStyle": "flat",
                  "subDetailViewStyle": "flat"
                }
              },
              {
                "id": "c12",
                "type": "layout",
                "style": "discoverCustom",
                "title": "",
                "desc": "",
                "icon": "",
                "iconStyle": "image",
                "componentList": [],
                "extParams": {
                  "dataId": 0,
                  "titlePosition": "left",
                  "pageTitle": "",
                  "newsModuleId": 0,
                  "forumId": 0,
                  "moduleId": 0,
                  "topicId": 0,
                  "articleId": 0,
                  "fastpostForumIds": [],
                  "isShowTopicTitle": 1,
                  "isShowMessagelist": 0,
                  "filter": "",
                  "filterId": 0,
                  "order": 0,
                  "orderby": "",
                  "redirect": "",
                  "listTitleLength": 40,
                  "listSummaryLength": 40,
                  "listImagePosition": 2,
                  "subListStyle": "flat",
                  "subDetailViewStyle": "flat"
                }
              }
            ],
            "extParams": {
              "dataId": 0,
              "titlePosition": "left",
              "pageTitle": "",
              "newsModuleId": 0,
              "forumId": 0,
              "moduleId": 0,
              "topicId": 0,
              "articleId": 0,
              "fastpostForumIds": [],
              "isShowTopicTitle": 1,
              "isShowMessagelist": 0,
              "filter": "",
              "filterId": 0,
              "order": 0,
              "orderby": "",
              "redirect": "",
              "listTitleLength": 40,
              "listSummaryLength": 40,
              "listImagePosition": 2,
              "subListStyle": "flat",
              "subDetailViewStyle": "flat"
            }
          }
        ],
        "extParams": {"padding": ""}
      },
      {
        "id": 2,
        "type": "fastpost",
        "style": "flat",
        "title": "\u5feb\u901f\u53d1\u8868",
        "icon":
            "http:\/\/bbs.77bike.com\/mobcent\/app\/web\/images\/admin\/module-default.png",
        "leftTopbars": [],
        "rightTopbars": [],
        "componentList": [
          {
            "type": "fasttext",
            "style": "flat",
            "icon": "mc_forum_ico27",
            "iconStyle": "image",
            "title": "\u6587\u5b57",
            "desc": "",
            "extParams": {
              "dataId": 0,
              "titlePosition": "left",
              "newsModuleId": 0,
              "forumId": 0,
              "moduleId": 1,
              "topicId": 0,
              "fastpostForumIds": [],
              "isShowTopicTitle": 1,
              "isShowMessagelist": 0,
              "filterId": 0,
              "filter": "",
              "orderby": "",
              "order": 0,
              "redirect": "",
              "listTitleLength": 40,
              "listSummaryLength": 40,
              "listImagePosition": 2,
              "subListStyle": "",
              "subDetailViewStyle": ""
            },
            "id": "c86",
            "componentList": []
          },
          {
            "type": "fastimage",
            "style": "flat",
            "icon": "mc_forum_ico28",
            "iconStyle": "image",
            "title": "\u56fe\u7247",
            "desc": "",
            "extParams": {
              "dataId": 0,
              "titlePosition": "left",
              "newsModuleId": 0,
              "forumId": 0,
              "moduleId": 1,
              "topicId": 0,
              "fastpostForumIds": [],
              "isShowTopicTitle": 1,
              "isShowMessagelist": 0,
              "filterId": 0,
              "filter": "",
              "orderby": "",
              "order": 0,
              "redirect": "",
              "listTitleLength": 40,
              "listSummaryLength": 40,
              "listImagePosition": 2,
              "subListStyle": "",
              "subDetailViewStyle": ""
            },
            "id": "c87",
            "componentList": []
          },
          {
            "type": "fastcamera",
            "style": "flat",
            "icon": "mc_forum_ico29",
            "iconStyle": "image",
            "title": "\u62cd\u7167",
            "desc": "",
            "extParams": {
              "dataId": 0,
              "titlePosition": "left",
              "newsModuleId": 0,
              "forumId": 0,
              "moduleId": 1,
              "topicId": 0,
              "fastpostForumIds": [],
              "isShowTopicTitle": 1,
              "isShowMessagelist": 0,
              "filterId": 0,
              "filter": "",
              "orderby": "",
              "order": 0,
              "redirect": "",
              "listTitleLength": 40,
              "listSummaryLength": 40,
              "listImagePosition": 2,
              "subListStyle": "",
              "subDetailViewStyle": ""
            },
            "id": "c88",
            "componentList": []
          },
          {
            "type": "fastaudio",
            "style": "flat",
            "icon": "mc_forum_ico45",
            "iconStyle": "image",
            "title": "\u8bed\u97f3",
            "desc": "",
            "extParams": {
              "dataId": 0,
              "titlePosition": "left",
              "newsModuleId": 0,
              "forumId": 0,
              "moduleId": 1,
              "topicId": 0,
              "fastpostForumIds": [],
              "isShowTopicTitle": 1,
              "isShowMessagelist": 0,
              "filterId": 0,
              "filter": "",
              "orderby": "",
              "order": 0,
              "redirect": "",
              "listTitleLength": 40,
              "listSummaryLength": 40,
              "listImagePosition": 2,
              "subListStyle": "",
              "subDetailViewStyle": ""
            },
            "id": "c89",
            "componentList": []
          },
          {
            "type": "sign",
            "style": "flat",
            "icon":
                "http:\/\/bbs.77bike.com\/attachment\/uidiy\/201603\/02\/W26g32YLlxrg.png",
            "iconStyle": "image",
            "title": "\u7b7e\u5230",
            "desc": "",
            "extParams": {
              "dataId": 0,
              "titlePosition": "left",
              "newsModuleId": 0,
              "forumId": 0,
              "moduleId": 1,
              "topicId": 0,
              "fastpostForumIds": [],
              "isShowTopicTitle": 1,
              "isShowMessagelist": 0,
              "filterId": 0,
              "filter": "",
              "orderby": "",
              "order": 0,
              "redirect": "",
              "listTitleLength": 40,
              "listSummaryLength": 40,
              "listImagePosition": 2,
              "subListStyle": "",
              "subDetailViewStyle": ""
            },
            "id": "c90",
            "componentList": []
          }
        ],
        "extParams": {"padding": ""}
      },
      {
        "id": 3,
        "type": "subnav",
        "style": "flat",
        "title": "\u9996\u9875",
        "icon":
            "http:\/\/bbs.77bike.com\/mobcent\/app\/web\/images\/admin\/module-default.png",
        "leftTopbars": [],
        "rightTopbars": [
          {
            "id": "c36",
            "type": "userinfo",
            "style": "flat",
            "title": "",
            "desc": "",
            "icon": "mc_forum_top_bar_button6",
            "iconStyle": "image",
            "componentList": [],
            "extParams": {
              "dataId": 0,
              "titlePosition": "left",
              "pageTitle": "",
              "newsModuleId": 0,
              "forumId": 0,
              "moduleId": 0,
              "topicId": 0,
              "articleId": 0,
              "fastpostForumIds": [],
              "isShowTopicTitle": 1,
              "isShowMessagelist": 0,
              "filter": "",
              "filterId": 0,
              "order": 0,
              "orderby": "",
              "redirect": "",
              "listTitleLength": 40,
              "listSummaryLength": 40,
              "listImagePosition": 2,
              "subListStyle": "flat",
              "subDetailViewStyle": "flat"
            }
          }
        ],
        "componentList": [
          {
            "id": "c31",
            "type": "topiclistSimple",
            "style": "tieba",
            "title": "\u6700\u65b0",
            "desc": "",
            "icon": "",
            "iconStyle": "image",
            "componentList": [],
            "extParams": {
              "forumId": 0,
              "fastpostForumIds": [],
              "filter": "typeid",
              "filterId": 0,
              "orderby": "new",
              "listTitleLength": 40,
              "listSummaryLength": 40,
              "listImagePosition": 2,
              "subDetailViewStyle": "card",
              "subListStyle": null
            }
          },
          {
            "id": "c32",
            "type": "topiclistSimple",
            "style": "neteaseNews",
            "title": "\u7cbe\u534e",
            "desc": "",
            "icon": "",
            "iconStyle": "image",
            "componentList": [],
            "extParams": {
              "forumId": 0,
              "fastpostForumIds": [],
              "filter": "typeid",
              "filterId": 0,
              "orderby": "marrow",
              "listTitleLength": 40,
              "listSummaryLength": 0,
              "listImagePosition": 2,
              "subDetailViewStyle": "flat",
              "subListStyle": null
            }
          }
        ],
        "extParams": {"padding": ""}
      },
      {
        "id": 4,
        "type": "full",
        "style": "flat",
        "title": "\u793e\u533a",
        "icon":
            "http:\/\/bbs.77bike.com\/mobcent\/app\/web\/images\/admin\/module-default.png",
        "leftTopbars": [],
        "rightTopbars": [
          {
            "id": "c43",
            "type": "search",
            "style": "flat",
            "title": "",
            "desc": "",
            "icon": "mc_forum_top_bar_button10",
            "iconStyle": "image",
            "componentList": [],
            "extParams": {
              "dataId": 0,
              "titlePosition": "left",
              "pageTitle": "",
              "newsModuleId": 0,
              "forumId": 0,
              "moduleId": 0,
              "topicId": 0,
              "articleId": 0,
              "fastpostForumIds": [],
              "isShowTopicTitle": 1,
              "isShowMessagelist": 0,
              "filter": "",
              "filterId": 0,
              "order": 0,
              "orderby": "",
              "redirect": "",
              "listTitleLength": 40,
              "listSummaryLength": 40,
              "listImagePosition": 2,
              "subListStyle": "flat",
              "subDetailViewStyle": "flat"
            }
          },
          {
            "id": "c44",
            "type": "userinfo",
            "style": "flat",
            "title": "",
            "desc": "",
            "icon": "mc_forum_top_bar_button6",
            "iconStyle": "image",
            "componentList": [],
            "extParams": {
              "dataId": 0,
              "titlePosition": "left",
              "pageTitle": "",
              "newsModuleId": 0,
              "forumId": 0,
              "moduleId": 0,
              "topicId": 0,
              "articleId": 0,
              "fastpostForumIds": [],
              "isShowTopicTitle": 1,
              "isShowMessagelist": 0,
              "filter": "",
              "filterId": 0,
              "order": 0,
              "orderby": "",
              "redirect": "",
              "listTitleLength": 40,
              "listSummaryLength": 40,
              "listImagePosition": 2,
              "subListStyle": "flat",
              "subDetailViewStyle": "flat"
            }
          }
        ],
        "componentList": [
          {
            "id": "c41",
            "type": "forumlist",
            "style": "flat",
            "title": "\u7248\u5757",
            "desc": "",
            "icon": "",
            "iconStyle": "image",
            "componentList": [],
            "extParams": {
              "dataId": 0,
              "titlePosition": "left",
              "pageTitle": "",
              "newsModuleId": 0,
              "forumId": 0,
              "moduleId": 0,
              "topicId": 0,
              "articleId": 0,
              "fastpostForumIds": [],
              "isShowTopicTitle": 1,
              "isShowMessagelist": 0,
              "filter": "",
              "filterId": 0,
              "order": 0,
              "orderby": "",
              "redirect": "",
              "listTitleLength": 40,
              "listSummaryLength": 40,
              "listImagePosition": 2,
              "subListStyle": "flat",
              "subDetailViewStyle": "flat"
            }
          }
        ],
        "extParams": {"padding": ""}
      },
      {
        "id": 5,
        "type": "full",
        "style": "flat",
        "title": "\u6d88\u606f",
        "icon":
            "http:\/\/bbs.77bike.com\/mobcent\/app\/web\/images\/admin\/module-default.png",
        "leftTopbars": [],
        "rightTopbars": [],
        "componentList": [
          {
            "id": "c48",
            "type": "messagelist",
            "style": "flat",
            "title": "",
            "desc": "",
            "icon": "",
            "iconStyle": "image",
            "componentList": [],
            "extParams": {
              "dataId": 0,
              "titlePosition": "left",
              "pageTitle": "",
              "newsModuleId": 0,
              "forumId": 0,
              "moduleId": 0,
              "topicId": 0,
              "articleId": 0,
              "fastpostForumIds": [],
              "isShowTopicTitle": 1,
              "isShowMessagelist": 0,
              "filter": "",
              "filterId": 0,
              "order": 0,
              "orderby": "",
              "redirect": "",
              "listTitleLength": 40,
              "listSummaryLength": 40,
              "listImagePosition": 2,
              "subListStyle": "flat",
              "subDetailViewStyle": "flat"
            }
          }
        ],
        "extParams": {"padding": ""}
      }
    ]
  }
};
*/
