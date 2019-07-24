import 'package:jaguar_serializer/jaguar_serializer.dart';

import '../common.dart';

part 'message_heart.jser.dart';

class MessageHeartAction {
  static const String action = "message/heart";

  static Map<String, dynamic> buildRequest() => {};

  static MessageHeartResponse parseResponse(Map<String, dynamic> response) {
    return MessageHeartResponseSerializer().fromMap(response);
  }
}

class MessageHeartResponse extends MobcentResponse {
  ResponseBody body;
}

class ResponseBody {
  HeartPeriod externInfo;

  CountTime friendInfo;

  CountTime replyInfo;

  CountTime atMeInfo;

  dynamic pmInfos;
}

class HeartPeriod {
  String heartPeriod;
  String pmPeriod;

  int get heartPeriodValue => int.tryParse(heartPeriod) ?? 30000;

  int get pmPeriodValue => int.tryParse(pmPeriod) ?? 30000;
}

class CountTime {
  int count;
  String time;

  CountTime({this.count = 0, this.time = "0"});
}

@GenSerializer()
class MessageHeartResponseSerializer extends Serializer<MessageHeartResponse>
    with _$MessageHeartResponseSerializer {}

@GenSerializer()
class ResponseBodySerializer extends Serializer<ResponseBody>
    with _$ResponseBodySerializer {}

@GenSerializer()
class HeartPeriodSerializer extends Serializer<HeartPeriod>
    with _$HeartPeriodSerializer {}

@GenSerializer()
class CountTimeSerializer extends Serializer<CountTime>
    with _$CountTimeSerializer {}

const _sample = {
  "rs": 1,
  "errcode": "",
  "head": {
    "errCode": "",
    "errInfo": "\u8c03\u7528\u6210\u529f,\u6ca1\u6709\u4efb\u4f55\u9519\u8bef",
    "version": "2.4.0.1",
    "alert": 0
  },
  "body": {
    "externInfo": {"heartPeriod": "30000", "pmPeriod": "30000"},
    "friendInfo": {"count": 0, "time": "0"},
    "replyInfo": {"count": 0, "time": "0"},
    "atMeInfo": {"count": 0, "time": "0"},
    "pmInfos": []
  }
};
