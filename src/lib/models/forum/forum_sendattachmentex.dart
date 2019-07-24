import 'package:flutter/foundation.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';

import '../common.dart';

part 'forum_sendattachmentex.jser.dart';

class SendAttachmentAction {
  static const String action = "forum/sendattachmentex";

  static Map<String, String> buildAlbumRequest({@required String albumId}) {
    return {
      "type": "image",
      "module": "album",
      "albumId": "$albumId",
    };
  }

  /// !!!! 设置了sortId时，返回的结果中不包含附件id
  static Map<String, String> buildForumRequest(
      {@required int fid, // long string
      int sortId = 0 // long string
      }) {
    return {
      "type": "image",
      "module": "forum",
      "fid": "$fid",
      if (sortId > 0) "sortId": "$sortId"
    };
  }

  static SendAttachmentResponse parseResponse(Map<String, dynamic> response) {
    return SendAttachmentResponseSerializer().fromMap(response);
  }
}

class SendAttachmentResponse extends MobcentResponse {
  ResponseBody body;
}

class ResponseBody {
  List<Attachment> attachment;

  dynamic externInfo;
}

class Attachment {
  int id;
  String urlName;
}

@GenSerializer()
class SendAttachmentResponseSerializer
    extends Serializer<SendAttachmentResponse>
    with _$SendAttachmentResponseSerializer {}

@GenSerializer()
class ResponseBodySerializer extends Serializer<ResponseBody>
    with _$ResponseBodySerializer {}

@GenSerializer()
class AttachmentSerializer extends Serializer<Attachment>
    with _$AttachmentSerializer {}

/* QueryString
accessSecret	f01b3418e99ebdc5fda5fa3b8b9c2
accessToken	ac3f19b94085e3b86c228b54f71c7
apphash	4f936bce
fid	23
forumKey	itTovrNYj6jgmwUBcQ
module	forum
r	forum/sendattachmentex
sdkVersion	2.4.0
type	image
*/

/*
Content-Disposition: form-data; name="uploadFile[]"; filename="1.jpg"
Content-Type: image/jpeg	<file>
Content-Disposition: form-data; name="uploadFile[]"; filename="1.jpg"
Content-Type: image/jpeg	<file>
Content-Disposition: form-data; name="uploadFile[]"; filename="1.jpg"
Content-Type: image/jpeg	<file>
Content-Disposition: form-data; name="uploadFile[]"; filename="1.jpg"
Content-Type: image/jpeg	<file>
Content-Disposition: form-data; name="uploadFile[]"; filename="1.jpg"
Content-Type: image/jpeg	<file>
*/

/*
POST /mobcent/app/web/index.php?r=forum/sendattachmentex&module=forum&sdkVersion=2.4.0&apphash=4f936bce&fid=23&type=image&accessToken=ac3f19b94085e3b86c228b54f71c7&accessSecret=f01b3418e99ebdc5fda5fa3b8b9c2&forumKey=itTovrNYj6jgmwUBcQ HTTP/1.1

POST http://bbs.77bike.com/mobcent/app/web/index.php?r=forum/sendattachmentex&module=forum&sdkVersion=2.4.0&apphash=4f936bce&fid=23&type=image&accessToken=ac3f19b94085e3b86c228b54f71c7&accessSecret=f01b3418e99ebdc5fda5fa3b8b9c2&forumKey=itTovrNYj6jgmwUBcQ HTTP/1.1
Host: bbs.77bike.com
Content-Type: multipart/form-data; charset=utf-8; boundary=0xKhTmLbOuNdArY-68AE84CC-FDF2-4234-92E3-80ECEB8FACC5
Connection: close
Cookie: 2f2b9_lastvisit=1087%091563002512%09%2Fmobcent%2Fapp%2Fweb%2Findex.php%3Frmessage%2Fheart; security_session_verify=7234056d2237ff6760f00c891c4f81ee; 2f2b9_lastpos=other; 2f2b9_ck_info=%2F%09; 2f2b9_winduser=BlNSVgxXMFADU1dRDV0EBgEAAlIBUg1SCAdVUgFTDAhVBQ1SU1UAaA; UM_distinctid=16be3c1e0f9a8a-016be13e851b1b-4d1b7f4f-4a640-16be3c1e0fb610; Hm_lvt_b738b124948406f56e606b292ef04731=1562894263; CNZZDATA5520252=cnzz_eid%3D1165914316-1562894262-%26ntime%3D1562894262; 2f2b9_jobpop=0; 2f2b9_wap_scr=a%3A2%3A%7Bs%3A4%3A%22page%22%3Bs%3A5%3A%22reply%22%3Bs%3A5%3A%22extra%22%3Ba%3A2%3A%7Bs%3A3%3A%22tid%22%3Bs%3A6%3A%22300403%22%3Bs%3A3%3A%22pid%22%3Bs%3A7%3A%224937368%22%3B%7D%7D
User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 12_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 Appbyme
Content-Length: 1006772
Accept-Encoding: gzip
Connection: close

--0xKhTmLbOuNdArY-68AE84CC-FDF2-4234-92E3-80ECEB8FACC5
Content-Disposition: form-data; name="uploadFile[]"; filename="1.jpg"
Content-Type: image/jpeg

…………………………………………………………………………………………………………
…………………………………………………………………………………………………………
…………………………………………………………………………………………………………

--0xKhTmLbOuNdArY-68AE84CC-FDF2-4234-92E3-80ECEB8FACC5
Content-Disposition: form-data; name="uploadFile[]"; filename="1.jpg"
Content-Type: image/jpeg

…………………………………………………………………………………………………………
…………………………………………………………………………………………………………
…………………………………………………………………………………………………………

--0xKhTmLbOuNdArY-68AE84CC-FDF2-4234-92E3-80ECEB8FACC5--
*/

//var response = {
//  "rs": 1,
//  "errcode": 0,
//  "head": {
//    "errCode": "",
//    "errInfo": "\u8c03\u7528\u6210\u529f,\u6ca1\u6709\u4efb\u4f55\u9519\u8bef",
//    "version": "2.4.0.1",
//    "alert": 0
//  },
//  "body": {
//    "externInfo": null,
//    "attachment": [
//      {
//        "id": 1333248,
//        "urlName":
//            "http:\/\/bbs.77bike.com\/attachment\/thumb\/Mon_1907\/15_116756_84075800acd6cad.jpg"
//      },
//      {
//        "id": 1333249,
//        "urlName":
//            "http:\/\/bbs.77bike.com\/attachment\/thumb\/Mon_1907\/15_116756_ba0cf52fff09e34.jpg"
//      },
//      {
//        "id": 1333250,
//        "urlName":
//            "http:\/\/bbs.77bike.com\/attachment\/thumb\/Mon_1907\/15_116756_88569071b928b54.jpg"
//      }
//    ]
//  }
//};

/* 设置了 sortId 之后返回的结果结构
var response_with_sortId = {
  "rs": 1,
  "errcode": 0,
  "head": {
    "errCode": "",
    "errInfo": "\u8c03\u7528\u6210\u529f,\u6ca1\u6709\u4efb\u4f55\u9519\u8bef",
    "version": "2.4.0.1",
    "alert": 0
  },
  "body": {
    "externInfo": null,
    "attachment": [
      {"id": "", "urlName": "postcate\/topic\/15\/20190722070347_35990.jpg"},
      {"id": "", "urlName": "postcate\/topic\/15\/20190722070347_59618.jpg"}
    ]
  }
};
*/
