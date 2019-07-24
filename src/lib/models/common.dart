import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'common.jser.dart';

@GenSerializer(fields: {
  "rs": const EnDecode(processor: const IntOrEmptyStringField()),
  "errcode": const EnDecode(processor: const IntOrEmptyStringField()),
})
class MobcentResponseSerializer extends Serializer<MobcentResponse>
    with _$MobcentResponseSerializer {}

@GenSerializer(fields: {
  "alert": const EnDecode(processor: const IntOrEmptyStringField()),
  "errCode": const EnDecode(processor: const IntOrEmptyStringField()),
})
class ResponseHeadSerializer extends Serializer<ResponseHead>
    with _$ResponseHeadSerializer {}

class MobcentResponse {
  int rs;

  dynamic errcode; // int or ""

  ResponseHead head;

  MobcentResponse({this.rs = 0, this.errcode = 0, this.head});

  bool get noError =>
      head != null && (head.errCode == null ? true : (head.errCode == 0));
}

class ResponseHead {
  int alert;
  int errCode;
  String errInfo;
  String version;

  ResponseHead({this.alert, this.errCode, this.errInfo, this.version});
}

class IntOrEmptyStringField implements FieldProcessor<int, dynamic> {
  final int defaultValue;

  @override
  deserialize(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return defaultValue;
  }

  @override
  serialize(int value) {
    return value ?? "";
  }

  const IntOrEmptyStringField({this.defaultValue});
}

/*
const _sample = {
  "rs": 0,
  "errcode": "\u641c\u7d22\u5173\u952e\u8bcd\u4e0d\u80fd\u4e3a\u7a7a!",
  "head": {
    "errCode": "090000001",
    "errInfo": "\u641c\u7d22\u5173\u952e\u8bcd\u4e0d\u80fd\u4e3a\u7a7a!",
    "version": "2.4.0.1",
    "alert": 1
  },
  "body": {"externInfo": null}
};
*/
