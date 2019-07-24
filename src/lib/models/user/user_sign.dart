// user/sign
import '../common.dart';

class UserSignAction {
  static const String action = "user/sign";

  static Map<String, dynamic> buildRequest() {
    return {};
  }

  static MobcentResponse parseResponse(Map<String, dynamic> response) {
    return MobcentResponseSerializer().fromMap(response);
  }
}

/*
const _samples = {
  "rs": 1,
  "errcode": "\u91d1\u94b1+2", // errcode=金钱+2
  "head": {
    "errCode": "070000006",
    "errInfo": "\u91d1\u94b1+2", // errInfo=金钱+2
    "version": "2.4.0.1",
    "alert": 1
  },
  "body": {"externInfo": null}
};

const _samples2 = {
  "rs": 0,
  "errcode": "\u4f60\u5df2\u7ecf\u6253\u5361,\u8bf7\u660e\u5929\u518d\u6765!", // errcode=你已经打卡,请明天再来!
  "head": {
    "errCode": "070000003",
    "errInfo": "\u4f60\u5df2\u7ecf\u6253\u5361,\u8bf7\u660e\u5929\u518d\u6765!", // errInfo=你已经打卡,请明天再来!
    "version": "2.4.0.1",
    "alert": 1
  },
  "body": {"externInfo": null}
};
*/
