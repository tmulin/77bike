/*
首次启动
accessSecret
accessToken
apphash	9425b1e8
forumKey	itTovrNYj6jgmwUBcQ
isValidation	0
password	MOBCENT%40hacker%23007
sdkVersion	2.4.0
type	login
username	MOBCENT%40hacker%23007
*/

/*
启动APP后登录
accessSecret
accessToken
apphash	9425b1e8
forumKey	itTovrNYj6jgmwUBcQ
isValidation	1
password	xxxxxx
sdkVersion	2.4.0
type	login
username	xxxxxx
*/

/*
登录状态重新打开APP
accessSecret	f01b3418e99ebdc5fda5fa3b8b9c2
accessToken	ac3f19b94085e3b86c228b54f71c7
apphash	9425b1e8
forumKey	itTovrNYj6jgmwUBcQ
isValidation	0
password	MOBCENT%40hacker%23007
sdkVersion	2.4.0
type	login
username	MOBCENT%40hacker%23007
*/

import 'package:jaguar_serializer/jaguar_serializer.dart';

import '../common.dart';

part 'user_login.jser.dart';

class UserLoginAction {
  static const String action = "user/login";
  static const String HACKER = "MOBCENT@hacker#007";

  static Map<String, dynamic> buildRequest(
      {String username = HACKER,
      String password = HACKER,
      int isValidation = 0}) {
    /// 用户登录验证=1, 自动登录=0,
    isValidation = username == HACKER ? 0 : 1;
    return {
      "type": "login",
      "isValidation": isValidation,
      "username": username,
      "password": password
    };
  }

  static UserLoginResponse parseResponse(Map<String, dynamic> response) {
    return UserLoginResponseSerializer().fromMap(response);
  }
}

@GenSerializer()
class UserLoginResponseSerializer extends Serializer<UserLoginResponse>
    with _$UserLoginResponseSerializer {}

class UserLoginResponse extends MobcentResponse {
  int uid;
  String token;
  String secret;
  String avatar;
  String userName;

  UserLoginResponse(
      {this.uid = 0,
      this.token = "",
      this.secret = "",
      this.avatar = "",
      this.userName = ""});
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
  "body": {"externInfo": null},
  "token": "",
  "secret": "",
  "uid": 0,
  "avatar": "http:\/\/bbs.77bike.com\/images\/face\/none.gif",
  "userName": null
};

const _sample1 = {
  "rs": 1,
  "errcode": "",
  "head": {
    "errCode": "",
    "errInfo": "\u8c03\u7528\u6210\u529f,\u6ca1\u6709\u4efb\u4f55\u9519\u8bef",
    "version": "2.4.0.1",
    "alert": 0
  },
  "body": {"externInfo": null},
  "token": "ac3f19b94085e3b86c228b54f71c7",
  "secret": "f01b3418e99ebdc5fda5fa3b8b9c2",
  "uid": 116756,
  "avatar":
      "http:\/\/bbs.77bike.com\/attachment\/upload\/middle\/56\/116756.jpg",
  "userName": "caimumu"
};
*/
