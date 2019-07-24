import 'package:flutter/foundation.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';

import '../common.dart';

part 'user_register.jser.dart';

class UserRegisterAction {
  static const String action = "user/register";

  static Map<String, dynamic> buildRequest(
      {@required String username,
      @required String password,
      @required String email}) {
    return {
      "username": username,
      "password": password,
      "email": email,
    };
  }

  static UserRegisterResponse parseResponse(Map<String, dynamic> response) {
    return UserRegisterResponseSerializer().fromMap(response);
  }
}

@GenSerializer()
class UserRegisterResponseSerializer extends Serializer<UserRegisterResponse>
    with _$UserRegisterResponseSerializer {}

class UserRegisterResponse extends MobcentResponse {
  int uid;
  String token;
  String secret;

  UserRegisterResponse({this.uid = 0, this.token = "", this.secret = ""});
}

// errInfo=管理员关闭了客户端注册功能
/*
const _samples = {
  "rs": 0,
  "errcode":
      "\u7ba1\u7406\u5458\u5173\u95ed\u4e86\u5ba2\u6237\u7aef\u6ce8\u518c\u529f\u80fd",
  "head": {
    "errCode": "015000002",
    "errInfo":
        "\u7ba1\u7406\u5458\u5173\u95ed\u4e86\u5ba2\u6237\u7aef\u6ce8\u518c\u529f\u80fd",    
    "version": "2.4.0.1",
    "alert": 1
  },
  "body": {"externInfo": null}
};
*/
