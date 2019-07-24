/*
accessSecret
accessToken
apphash	9425b1e8
forumKey	itTovrNYj6jgmwUBcQ
getSetting	{"body":{"postInfo":{"forumIds":"0"}}}
sdkVersion	2.4.0
*/

import 'dart:convert';

import 'package:jaguar_serializer/jaguar_serializer.dart';

import '../common.dart';

part 'user_getsetting.jser.dart';

class UserGetSettingAction {
  static const String action = "user/getsetting";

  static Map<String, dynamic> buildRequest() {
    var getSetting = {
      "body": {
        "postInfo": {"forumIds": "0"}
      }
    };
    return {"getSetting": jsonEncode(getSetting)};
  }

  static UserGetSettingResponse parseResponse(Map<String, dynamic> response) {
    return UserGetSettingResponseSerializer().fromMap(response);
  }
}

@GenSerializer()
class UserGetSettingResponseSerializer
    extends Serializer<UserGetSettingResponse>
    with _$UserGetSettingResponseSerializer {}

@GenSerializer()
class _ResponseBodySerializer extends Serializer<_ResponseBody>
    with _$_ResponseBodySerializer {}

@GenSerializer()
class _ForumSerializer extends Serializer<_Forum> with _$_ForumSerializer {}

@GenSerializer()
class _MessageSerializer extends Serializer<_Message>
    with _$_MessageSerializer {}

@GenSerializer()
class _ModuleSerializer extends Serializer<_Module> with _$_ModuleSerializer {}

@GenSerializer()
class _PluginSerializer extends Serializer<_Plugin> with _$_PluginSerializer {}

@GenSerializer()
class _PortalSerializer extends Serializer<_Portal> with _$_PortalSerializer {}

@GenSerializer()
class _UserSerializer extends Serializer<_User> with _$_UserSerializer {}

@GenSerializer()
class _PostInfoSerializer extends Serializer<_PostInfo>
    with _$_PostInfoSerializer {}

@GenSerializer()
class PostSerializer extends Serializer<Post> with _$PostSerializer {}

@GenSerializer()
class TopicSerializer extends Serializer<Topic> with _$TopicSerializer {}

@GenSerializer()
class ClassificationTypeSerializer extends Serializer<ClassificationType>
    with _$ClassificationTypeSerializer {}

@GenSerializer()
class NewTopicPanelSerializer extends Serializer<NewTopicPanel>
    with _$NewTopicPanelSerializer {}

class UserGetSettingResponse extends MobcentResponse {
  _ResponseBody body;

  UserGetSettingResponse({this.body, rs, errcode, head})
      : super(rs: rs, errcode: errcode, head: head);
}

class _ResponseBody {
  String serverTime;

  _Forum forum;

  _Message message;

  // Map<String, dynamic> misc;

  List<_Module> moduleList;

  _Plugin plugin;

  _Portal portal;

  _User user;

  List<_PostInfo> postInfo;
}

class _Forum {
  int isSummaryShow;
  int isTodayPostCount;
  int postlistOrderby;
  int postAudioLimit;

  _Forum(
      {this.isSummaryShow = 0,
      this.isTodayPostCount = 0,
      this.postlistOrderby = 0,
      this.postAudioLimit = 0});
}

class _Message {
  int allowPostImage;
  int pmAudioLimit;

  _Message({this.allowPostImage = 0, this.pmAudioLimit = 0});
}

class _Misc {}

class _Module {
  int moduleId;
  String moduleName;

  _Module({this.moduleId = 0, this.moduleName});
}

class _Plugin {
  int qqconnect;
  int dsu_paulsign;
  int wxconnect;
  int isMobileRegisterValidation;

  _Plugin(
      {this.qqconnect = 0,
      this.dsu_paulsign = 0,
      this.wxconnect = 0,
      this.isMobileRegisterValidation = 0});
}

class _Portal {
  int isSummaryShow;

  _Portal({this.isSummaryShow = 0});
}

class _User {
  int allowAt;
  int allowRegister;
  String wapRegisterUrl;

  _User({this.allowAt = 0, this.allowRegister = 0, this.wapRegisterUrl = ""});
}

class _PostInfo {
  int fid;

  Topic topic;

  Post post;
}

class Post {
  int isHidden;
  int isAnonymous;
  int isOnlyAuthor;
  int allowPostAttachment;
  int allowPostImage;

  Post(
      {this.isHidden = 0,
      this.isAnonymous = 0,
      this.isOnlyAuthor = 0,
      this.allowPostAttachment = 0,
      this.allowPostImage = 0});
}

class Topic {
  int isHidden;
  int isAnonymous;
  int isOnlyAuthor;
  int allowPostAttachment;
  int allowPostImage;

  /// 板块中的分类列表
  List<ClassificationType> classificationType_list;

  int isOnlyTopicType;
  List<NewTopicPanel> newTopicPanel;

  Topic(
      {this.isHidden = 0,
      this.isAnonymous = 0,
      this.isOnlyAuthor = 0,
      this.allowPostAttachment = 0,
      this.allowPostImage = 0,
      this.classificationType_list = const [],
      this.isOnlyTopicType = 1,
      this.newTopicPanel = const []});
}

/// 板块中的分类
class ClassificationType {
  int classificationType_id;
  String classificationType_name;

  ClassificationType(
      {this.classificationType_id, this.classificationType_name});
}

class NewTopicPanel {
  String type; // normal
  String title;

  NewTopicPanel({this.type, this.title});
}

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
  "body": {
    "serverTime": "1562806409000",
    "misc": {
      "weather": {"allowUsage": 1, "allowCityQuery": 1}
    },
    "plugin": {
      "qqconnect": 0,
      "dsu_paulsign": 1,
      "wxconnect": 0,
      "isMobileRegisterValidation": 0
    },
    "forum": {
      "isSummaryShow": 1,
      "isTodayPostCount": 1,
      "postlistOrderby": 0,
      "postAudioLimit": -1
    },
    "portal": {"isSummaryShow": 1},
    "user": {"allowAt": 0, "allowRegister": 0, "wapRegisterUrl": ""},
    "message": {"allowPostImage": 1, "pmAudioLimit": -1},
    "moduleList": [
      {"moduleId": 0, "moduleName": "\u95e8\u6237"}
    ],
    "postInfo": [
      {
        "fid": 2,
        "topic": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0,
          "classificationType_list": [
            {
              "classificationType_id": 70,
              "classificationType_name": "\u7ecf\u9a8c\u5206\u4eab"
            },
            {
              "classificationType_id": 71,
              "classificationType_name": "\u8d44\u6599\u6570\u636e"
            },
            {
              "classificationType_id": 72,
              "classificationType_name": "\u4f18\u79c0\u6848\u4f8b"
            },
            {
              "classificationType_id": 73,
              "classificationType_name": "\u5b9e\u7528\u7406\u8bba"
            },
            {
              "classificationType_id": 74,
              "classificationType_name": "\u7cbe\u5f69\u8ba8\u8bba"
            },
            {
              "classificationType_id": 75,
              "classificationType_name": "\u5176\u4ed6\u4fe1\u606f"
            }
          ],
          "isOnlyTopicType": 1,
          "newTopicPanel": [
            {"type": "normal", "title": "\u53d1\u5e16"}
          ]
        },
        "post": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0
        }
      },
      {
        "fid": 15,
        "topic": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0,
          "classificationType_list": [
            {
              "classificationType_id": 83,
              "classificationType_name": "\u751f\u6d3b"
            },
            {
              "classificationType_id": 84,
              "classificationType_name": "\u60c5\u611f"
            },
            {
              "classificationType_id": 85,
              "classificationType_name": "\u5410\u69fd"
            },
            {
              "classificationType_id": 86,
              "classificationType_name": "\u8f66\u9a91"
            },
            {
              "classificationType_id": 87,
              "classificationType_name": "\u5e72\u8d27"
            },
            {
              "classificationType_id": 88,
              "classificationType_name": "\u5176\u5b83"
            },
            {
              "classificationType_id": 89,
              "classificationType_name": "\u5173\u4e8e\u8bba\u575b"
            },
            {
              "classificationType_id": 105,
              "classificationType_name": "\u7f8e\u98df"
            }
          ],
          "isOnlyTopicType": 1,
          "newTopicPanel": [
            {"type": "normal", "title": "\u53d1\u5e16"}
          ]
        },
        "post": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0
        }
      },
      {
        "fid": 5,
        "topic": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0,
          "classificationType_list": [
            {
              "classificationType_id": 10,
              "classificationType_name": "\u5176\u5b83"
            },
            {
              "classificationType_id": 11,
              "classificationType_name": "\u5c71\u5730"
            },
            {
              "classificationType_id": 12,
              "classificationType_name": "\u516c\u8def"
            },
            {"classificationType_id": 13, "classificationType_name": ""},
            {
              "classificationType_id": 14,
              "classificationType_name": "14\u5bf8"
            },
            {
              "classificationType_id": 15,
              "classificationType_name": "16\u5bf8"
            },
            {
              "classificationType_id": 16,
              "classificationType_name": "18\u5bf8"
            },
            {
              "classificationType_id": 17,
              "classificationType_name": "20\u5bf8"
            },
            {"classificationType_id": 18, "classificationType_name": "451"}
          ],
          "isOnlyTopicType": 1,
          "newTopicPanel": [
            {"type": "normal", "title": "\u53d1\u5e16"}
          ]
        },
        "post": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0
        }
      },
      {
        "fid": 16,
        "topic": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0,
          "classificationType_list": [
            {
              "classificationType_id": 76,
              "classificationType_name": "\u524d\u53f0\u7ba1\u7406"
            },
            {
              "classificationType_id": 77,
              "classificationType_name": "\u540e\u53f0\u7ba1\u7406"
            },
            {
              "classificationType_id": 78,
              "classificationType_name": "\u5e95\u5c42\u7ef4\u62a4"
            },
            {
              "classificationType_id": 96,
              "classificationType_name": "\u63d0\u8bae\u8ba8\u8bba"
            },
            {
              "classificationType_id": 97,
              "classificationType_name": "\u4f1a\u5458\u7533\u8bc9"
            }
          ],
          "isOnlyTopicType": 1,
          "newTopicPanel": [
            {"type": "normal", "title": "\u53d1\u5e16"}
          ]
        },
        "post": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0
        }
      },
      {
        "fid": 12,
        "topic": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0,
          "classificationType_list": [
            {
              "classificationType_id": 19,
              "classificationType_name": "\u51fa\u552e"
            },
            {
              "classificationType_id": 20,
              "classificationType_name": "\u6c42\u8d2d"
            },
            {
              "classificationType_id": 69,
              "classificationType_name": "\u9650\u552e\u672c\u5730"
            },
            {
              "classificationType_id": 91,
              "classificationType_name": "\u4e0e\u8f66\u65e0\u5173"
            }
          ],
          "isOnlyTopicType": 1,
          "newTopicPanel": [
            {"type": "normal", "title": "\u53d1\u5e16"}
          ]
        },
        "post": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0
        }
      },
      {
        "fid": 73,
        "topic": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0,
          "classificationType_list": [
            {
              "classificationType_id": 99,
              "classificationType_name": "\u54c1\u724c\u6545\u4e8b"
            },
            {
              "classificationType_id": 100,
              "classificationType_name": "\u4ea7\u54c1\u4ecb\u7ecd"
            },
            {
              "classificationType_id": 98,
              "classificationType_name": "\u8bd5\u7528\u4f53\u9a8c"
            },
            {
              "classificationType_id": 101,
              "classificationType_name": "\u62bd\u5956\u6d3b\u52a8"
            },
            {
              "classificationType_id": 102,
              "classificationType_name": "\u5176\u4ed6\u8d44\u8baf"
            }
          ],
          "isOnlyTopicType": 1,
          "newTopicPanel": [
            {"type": "normal", "title": "\u53d1\u5e16"}
          ]
        },
        "post": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0
        }
      },
      {
        "fid": 40,
        "topic": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0,
          "classificationType_list": [],
          "isOnlyTopicType": 0,
          "newTopicPanel": []
        },
        "post": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0
        }
      },
      {
        "fid": 13,
        "topic": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0,
          "classificationType_list": [
            {
              "classificationType_id": 25,
              "classificationType_name": "\u6e38\u8bb0\u5206\u4eab"
            },
            {
              "classificationType_id": 24,
              "classificationType_name": "\u53d1\u8d77\u6d3b\u52a8"
            },
            {
              "classificationType_id": 27,
              "classificationType_name": "\u653b\u7565\u8def\u4e66"
            },
            {
              "classificationType_id": 26,
              "classificationType_name": "\u63d0\u95ee\u8ba8\u8bba"
            },
            {
              "classificationType_id": 103,
              "classificationType_name": "\u5fae\u6e38\u8bb0"
            }
          ],
          "isOnlyTopicType": 1,
          "newTopicPanel": [
            {"type": "normal", "title": "\u53d1\u5e16"}
          ]
        },
        "post": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0
        }
      },
      {
        "fid": 23,
        "topic": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0,
          "classificationType_list": [
            {
              "classificationType_id": 28,
              "classificationType_name": "\u516c\u544a"
            },
            {
              "classificationType_id": 29,
              "classificationType_name": "\u5956\u52b1"
            },
            {
              "classificationType_id": 30,
              "classificationType_name": "\u5904\u7f5a"
            },
            {
              "classificationType_id": 31,
              "classificationType_name": "\u5efa\u8bae"
            },
            {
              "classificationType_id": 33,
              "classificationType_name": "\u7ea0\u7eb7"
            },
            {
              "classificationType_id": 51,
              "classificationType_name": "\u63d0\u95ee"
            }
          ],
          "isOnlyTopicType": 1,
          "newTopicPanel": [
            {"type": "normal", "title": "\u53d1\u5e16"}
          ]
        },
        "post": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0
        }
      },
      {
        "fid": 36,
        "topic": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0,
          "classificationType_list": [
            {
              "classificationType_id": 54,
              "classificationType_name": "\u5546\u5bb6"
            },
            {
              "classificationType_id": 55,
              "classificationType_name": "\u56e2\u8d2d"
            },
            {
              "classificationType_id": 56,
              "classificationType_name": "\u642c\u7816\u5934"
            }
          ],
          "isOnlyTopicType": 1,
          "newTopicPanel": [
            {"type": "normal", "title": "\u53d1\u5e16"}
          ]
        },
        "post": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0
        }
      },
      {
        "fid": 24,
        "topic": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0,
          "classificationType_list": [
            {
              "classificationType_id": 34,
              "classificationType_name": "\u6539\u88c5\u95ee\u9898"
            },
            {
              "classificationType_id": 35,
              "classificationType_name": "\u8f66\u51b5\u95ee\u9898"
            },
            {
              "classificationType_id": 37,
              "classificationType_name": "\u5176\u4ed6\u95ee\u9898"
            }
          ],
          "isOnlyTopicType": 1,
          "newTopicPanel": [
            {"type": "normal", "title": "\u53d1\u5e16"}
          ]
        },
        "post": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0
        }
      },
      {
        "fid": 38,
        "topic": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0,
          "classificationType_list": [
            {
              "classificationType_id": 95,
              "classificationType_name": "\u5bb6\u5ead\u4f5c\u4e1a"
            },
            {
              "classificationType_id": 52,
              "classificationType_name": "\u5668\u6750\u8ba8\u8bba"
            },
            {
              "classificationType_id": 60,
              "classificationType_name": "\u6280\u672f\u8ba8\u8bba"
            },
            {
              "classificationType_id": 57,
              "classificationType_name": "\u539f\u521b\u4f5c\u54c1"
            },
            {
              "classificationType_id": 58,
              "classificationType_name": "\u7f8e\u56fe\u5171\u8d4f"
            },
            {
              "classificationType_id": 59,
              "classificationType_name": "\u8d2d\u4e70\u54a8\u8be2"
            }
          ],
          "isOnlyTopicType": 1,
          "newTopicPanel": [
            {"type": "normal", "title": "\u53d1\u5e16"}
          ]
        },
        "post": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0
        }
      },
      {
        "fid": 31,
        "topic": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0,
          "classificationType_list": [
            {
              "classificationType_id": 40,
              "classificationType_name": "\u6539\u88c5\u54a8\u8be2"
            },
            {
              "classificationType_id": 41,
              "classificationType_name": "\u7efc\u5408\u8ba8\u8bba"
            },
            {
              "classificationType_id": 42,
              "classificationType_name": "\u516c\u8def\u79c0\u8f66"
            },
            {
              "classificationType_id": 43,
              "classificationType_name": "\u5c71\u5730\u79c0\u8f66"
            },
            {
              "classificationType_id": 44,
              "classificationType_name": "\u5355\u8f66\u6b23\u8d4f"
            },
            {
              "classificationType_id": 45,
              "classificationType_name": "\u77e5\u8bc6\u4ecb\u7ecd"
            }
          ],
          "isOnlyTopicType": 1,
          "newTopicPanel": [
            {"type": "normal", "title": "\u53d1\u5e16"}
          ]
        },
        "post": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0
        }
      },
      {
        "fid": 32,
        "topic": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0,
          "classificationType_list": [
            {
              "classificationType_id": 110,
              "classificationType_name": "\u7535\u5b50\u6e38\u620f"
            },
            {
              "classificationType_id": 46,
              "classificationType_name": "\u7535\u8111\u7f51\u7edc"
            },
            {
              "classificationType_id": 48,
              "classificationType_name": "\u6d88\u8d39\u7535\u5b50"
            },
            {
              "classificationType_id": 50,
              "classificationType_name": "\u6237\u5916\u88c5\u5907"
            },
            {
              "classificationType_id": 64,
              "classificationType_name": "\u82b1\u9e1f\u9c7c\u866b"
            },
            {
              "classificationType_id": 62,
              "classificationType_name": "\u52a8\u6f2b\u5f71\u97f3"
            },
            {
              "classificationType_id": 66,
              "classificationType_name": "\u96c6\u85cf\u6000\u65e7"
            },
            {
              "classificationType_id": 67,
              "classificationType_name": "\u670d\u9970\u978b\u5e3d"
            },
            {
              "classificationType_id": 68,
              "classificationType_name": "\u5176\u4ed6"
            }
          ],
          "isOnlyTopicType": 1,
          "newTopicPanel": [
            {"type": "normal", "title": "\u53d1\u5e16"}
          ]
        },
        "post": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0
        }
      },
      {
        "fid": 42,
        "topic": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0,
          "classificationType_list": [
            {
              "classificationType_id": 79,
              "classificationType_name": "\u8d60\u4e88"
            },
            {
              "classificationType_id": 80,
              "classificationType_name": "\u4e49\u5356"
            },
            {
              "classificationType_id": 104,
              "classificationType_name": "\u6c42\u8d60"
            }
          ],
          "isOnlyTopicType": 1,
          "newTopicPanel": [
            {"type": "normal", "title": "\u53d1\u5e16"}
          ]
        },
        "post": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0
        }
      },
      {
        "fid": 50,
        "topic": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0,
          "classificationType_list": [],
          "isOnlyTopicType": 0,
          "newTopicPanel": [
            {"type": "normal", "title": "\u53d1\u5e16"}
          ]
        },
        "post": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0
        }
      },
      {
        "fid": 49,
        "topic": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0,
          "classificationType_list": [],
          "isOnlyTopicType": 0,
          "newTopicPanel": []
        },
        "post": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0
        }
      },
      {
        "fid": 48,
        "topic": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0,
          "classificationType_list": [
            {"classificationType_id": 81, "classificationType_name": "AUTO"},
            {"classificationType_id": 82, "classificationType_name": "MOTO"},
            {"classificationType_id": 92, "classificationType_name": "4+2"}
          ],
          "isOnlyTopicType": 1,
          "newTopicPanel": [
            {"type": "normal", "title": "\u53d1\u5e16"}
          ]
        },
        "post": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0
        }
      },
      {
        "fid": 51,
        "topic": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0,
          "classificationType_list": [
            {
              "classificationType_id": 90,
              "classificationType_name": "\u65b0\u4eba\u62a5\u5230"
            },
            {
              "classificationType_id": 93,
              "classificationType_name": "\u8d2d\u8f66\u54a8\u8be2"
            },
            {
              "classificationType_id": 94,
              "classificationType_name": "\u65b0\u4eba\u804a\u8f66"
            }
          ],
          "isOnlyTopicType": 1,
          "newTopicPanel": [
            {"type": "normal", "title": "\u53d1\u5e16"}
          ]
        },
        "post": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0
        }
      },
      {
        "fid": 52,
        "topic": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0,
          "classificationType_list": [],
          "isOnlyTopicType": 0,
          "newTopicPanel": [
            {"type": "normal", "title": "\u53d1\u5e16"}
          ]
        },
        "post": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0
        }
      },
      {
        "fid": 53,
        "topic": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0,
          "classificationType_list": [],
          "isOnlyTopicType": 0,
          "newTopicPanel": [
            {"type": "normal", "title": "\u53d1\u5e16"}
          ]
        },
        "post": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0
        }
      },
      {
        "fid": 104,
        "topic": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0,
          "classificationType_list": [],
          "isOnlyTopicType": 0,
          "newTopicPanel": [
            {"type": "normal", "title": "\u53d1\u5e16"}
          ]
        },
        "post": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0
        }
      },
      {
        "fid": 102,
        "topic": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0,
          "classificationType_list": [],
          "isOnlyTopicType": 0,
          "newTopicPanel": [
            {"type": "normal", "title": "\u53d1\u5e16"}
          ]
        },
        "post": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0
        }
      },
      {
        "fid": 108,
        "topic": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0,
          "classificationType_list": [
            {
              "classificationType_id": 108,
              "classificationType_name": "\u5171\u4eab\u5355\u8f66"
            },
            {
              "classificationType_id": 109,
              "classificationType_name": "\u4e70\u83dc\u8f66"
            }
          ],
          "isOnlyTopicType": 1,
          "newTopicPanel": [
            {"type": "normal", "title": "\u53d1\u5e16"}
          ]
        },
        "post": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0
        }
      },
      {
        "fid": 106,
        "topic": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0,
          "classificationType_list": [
            {
              "classificationType_id": 106,
              "classificationType_name": "\u6df7\u52a8"
            },
            {
              "classificationType_id": 107,
              "classificationType_name": "\u7eaf\u7535"
            }
          ],
          "isOnlyTopicType": 1,
          "newTopicPanel": [
            {"type": "normal", "title": "\u53d1\u5e16"}
          ]
        },
        "post": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0
        }
      },
      {
        "fid": 86,
        "topic": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0,
          "classificationType_list": [],
          "isOnlyTopicType": 0,
          "newTopicPanel": [
            {"type": "normal", "title": "\u53d1\u5e16"}
          ]
        },
        "post": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0
        }
      },
      {
        "fid": 88,
        "topic": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0,
          "classificationType_list": [],
          "isOnlyTopicType": 0,
          "newTopicPanel": [
            {"type": "normal", "title": "\u53d1\u5e16"}
          ]
        },
        "post": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0
        }
      },
      {
        "fid": 89,
        "topic": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0,
          "classificationType_list": [],
          "isOnlyTopicType": 0,
          "newTopicPanel": [
            {"type": "normal", "title": "\u53d1\u5e16"}
          ]
        },
        "post": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0
        }
      },
      {
        "fid": 93,
        "topic": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0,
          "classificationType_list": [],
          "isOnlyTopicType": 0,
          "newTopicPanel": [
            {"type": "normal", "title": "\u53d1\u5e16"}
          ]
        },
        "post": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0
        }
      },
      {
        "fid": 95,
        "topic": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0,
          "classificationType_list": [],
          "isOnlyTopicType": 0,
          "newTopicPanel": [
            {"type": "normal", "title": "\u53d1\u5e16"}
          ]
        },
        "post": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0
        }
      },
      {
        "fid": 96,
        "topic": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0,
          "classificationType_list": [],
          "isOnlyTopicType": 0,
          "newTopicPanel": [
            {"type": "normal", "title": "\u53d1\u5e16"}
          ]
        },
        "post": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0
        }
      },
      {
        "fid": 97,
        "topic": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0,
          "classificationType_list": [],
          "isOnlyTopicType": 0,
          "newTopicPanel": [
            {"type": "normal", "title": "\u53d1\u5e16"}
          ]
        },
        "post": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0
        }
      },
      {
        "fid": 103,
        "topic": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0,
          "classificationType_list": [],
          "isOnlyTopicType": 0,
          "newTopicPanel": [
            {"type": "normal", "title": "\u53d1\u5e16"}
          ]
        },
        "post": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0
        }
      },
      {
        "fid": 105,
        "topic": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0,
          "classificationType_list": [],
          "isOnlyTopicType": 0,
          "newTopicPanel": [
            {"type": "normal", "title": "\u53d1\u5e16"}
          ]
        },
        "post": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0
        }
      },
      {
        "fid": 101,
        "topic": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0,
          "classificationType_list": [],
          "isOnlyTopicType": 0,
          "newTopicPanel": [
            {"type": "normal", "title": "\u53d1\u5e16"}
          ]
        },
        "post": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0
        }
      },
      {
        "fid": 109,
        "topic": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0,
          "classificationType_list": [],
          "isOnlyTopicType": 0,
          "newTopicPanel": []
        },
        "post": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0
        }
      },
      {
        "fid": 111,
        "topic": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0,
          "classificationType_list": [],
          "isOnlyTopicType": 0,
          "newTopicPanel": [
            {"type": "normal", "title": "\u53d1\u5e16"}
          ]
        },
        "post": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0
        }
      },
      {
        "fid": 110,
        "topic": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0,
          "classificationType_list": [],
          "isOnlyTopicType": 0,
          "newTopicPanel": [
            {"type": "normal", "title": "\u53d1\u5e16"}
          ]
        },
        "post": {
          "isHidden": 0,
          "isAnonymous": 0,
          "isOnlyAuthor": 0,
          "allowPostAttachment": 0,
          "allowPostImage": 0
        }
      }
    ]
  }
};
*/
