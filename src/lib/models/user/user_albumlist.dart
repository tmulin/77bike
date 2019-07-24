/* 用户相册 user/albumlist
uid
page
pageSize
*/

import 'package:jaguar_serializer/jaguar_serializer.dart';

import '../common.dart';

part 'user_albumlist.jser.dart';

class UserAlbumlistAction {
  static const String action = "user/albumlist";

  static Map<String, dynamic> buildRequest(int userId,
      {int page = 1, int pageSize = 100}) {
    return {"uid": userId, "page": page ?? 1, "pageSize": pageSize ?? 100};
  }

  static UserAlbumlistResponse parseResponse(Map<String, dynamic> response) {
    return UserAlbumlistResponseSerializer().fromMap(response);
  }
}

/*
uid 必填
albumId 必填
page 选填,默认1
pageSize 选填,默认10
当前分页参数无效!
*/
class UserPhotolistAction {
  static const String action = "user/photolist";

  static Map<String, dynamic> buildRequest(int userId, int albumId,
      {int page = 1, int pageSize = 100}) {
    return {
      "uid": userId,
      "albumId": albumId,
      "page": page ?? 1,
      "pageSize": pageSize ?? 100
    };
  }

  static UserPhotolistResponse parseResponse(Map<String, dynamic> response) {
    return UserPhotolistResponseSerializer().fromMap(response);
  }
}

class UserAlbumlistResponse extends MobcentResponse {
  int page;
  int has_next;
  int total_num;
  List<UserAlbum> list;
}

class UserAlbum {
  int album_id;
  int user_id;
  String release_date;
  String title;
  String info;
  String user_nick_name;
  String last_update_date;
  String thumb_pic;

  DateTime get release_date_value =>
      DateTime.fromMillisecondsSinceEpoch(int.tryParse(this.release_date));

  DateTime get last_update_date_value =>
      DateTime.fromMillisecondsSinceEpoch(int.tryParse(this.last_update_date));
}

class UserPhotolistResponse extends MobcentResponse {
  int page;
  int has_next;
  int total_num;

  List<UserPhoto> list;
}

class UserPhoto {
  int album_id;
  int pic_id;
  int user_id;
  String last_update_date; // 可能为空
  String release_date;
  String user_nick_name;
  int hot;
  int replies;
  String thumb_pic;
  String origin_pic;

  DateTime get release_date_value =>
      DateTime.fromMillisecondsSinceEpoch(int.tryParse(this.release_date) ?? 0);

  DateTime get last_update_date_value => DateTime.fromMillisecondsSinceEpoch(
      int.tryParse(this.last_update_date) ?? 0);
}

@GenSerializer()
class UserAlbumlistResponseSerializer extends Serializer<UserAlbumlistResponse>
    with _$UserAlbumlistResponseSerializer {}

@GenSerializer()
class UserPhotolistResponseSerializer extends Serializer<UserPhotolistResponse>
    with _$UserPhotolistResponseSerializer {}

@GenSerializer()
class UserAlbumSerializer extends Serializer<UserAlbum>
    with _$UserAlbumSerializer {}

@GenSerializer()
class UserPhotoSerializer extends Serializer<UserPhoto>
    with _$UserPhotoSerializer {}

//var _samples = {
//  "rs": 1,
//  "errcode": "",
//  "head": {
//    "errCode": "",
//    "errInfo": "调用成功,没有任何错误",
//    "version": "2.4.0.1",
//    "alert": 0
//  },
//  "body": {"externInfo": null},
//  "page": 1,
//  "has_next": 0,
//  "total_num": 4,
//  "list": [
//    {
//      "album_id": 9190,
//      "user_id": 116756,
//      "release_date": "1527652018000",
//      "title": "451轮组",
//      "info": "",
//      "user_nick_name": "caimumu",
//      "last_update_date": "1527680880000",
//      "thumb_pic":
//          "http://bbs.77bike.com/attachment/photo/Mon_1805/s_9190_2ac5152765213309cf94fc7ebb946.jpg"
//    },
//    {
//      "album_id": 9189,
//      "user_id": 116756,
//      "release_date": "1527651717000",
//      "title": "牙盘夹器",
//      "info": "",
//      "user_nick_name": "caimumu",
//      "last_update_date": "1527885660000",
//      "thumb_pic":
//          "http://bbs.77bike.com/attachment/photo/Mon_1805/s_9189_de4915276518414056970941f2ba4.jpg"
//    },
//    {
//      "album_id": 8529,
//      "user_id": 116756,
//      "release_date": "1498978775000",
//      "title": "骑行台",
//      "info": "",
//      "user_nick_name": "caimumu",
//      "last_update_date": "1499007720000",
//      "thumb_pic":
//          "http://bbs.77bike.com/attachment/photo/Mon_1707/s_8529_8c2a149897897036b71adb4aada46.jpg"
//    },
//    {
//      "album_id": 6786,
//      "user_id": 116756,
//      "release_date": "1459087926000",
//      "title": "默认相册",
//      "info": "",
//      "user_nick_name": "caimumu",
//      "last_update_date": "1502749860000",
//      "thumb_pic":
//          "http://bbs.77bike.com/attachment/photo/Mon_1603/s_6786_feee1459088260e8a3913fa03c3dc.jpg"
//    }
//  ]
//};

/* 相册内照片
var _samples = {
  "page": 1,
  "has_next": 0,
  "total_num": 12,
  "rs": 1,
  "errcode": "",
  "head": {
    "errCode": "",
    "errInfo": "调用成功,没有任何错误",
    "version": "2.4.0.1",
    "alert": 0
  },
  "body": {"externInfo": null},
  "list": [
    {
      "album_id": 9190,
      "pic_id": 87976,
      "user_id": 116756,
      "last_update_date": "",
      "release_date": "1527680880000",
      "user_nick_name": "caimumu",
      "hot": 8,
      "replies": 0,
      "thumb_pic":
          "http://bbs.77bike.com/attachment/photo/Mon_1805/s_9190_187515276521353804d1c2558cebf.jpg",
      "origin_pic":
          "http://bbs.77bike.com/attachment/photo/Mon_1805/9190_187515276521353804d1c2558cebf.jpg"
    },
    {
      "album_id": 9190,
      "pic_id": 87975,
      "user_id": 116756,
      "last_update_date": "",
      "release_date": "1527680880000",
      "user_nick_name": "caimumu",
      "hot": 6,
      "replies": 0,
      "thumb_pic":
          "http://bbs.77bike.com/attachment/photo/Mon_1805/s_9190_15141527652135a3f84c824787fa9.jpg",
      "origin_pic":
          "http://bbs.77bike.com/attachment/photo/Mon_1805/9190_15141527652135a3f84c824787fa9.jpg"
    },
    {
      "album_id": 9190,
      "pic_id": 87974,
      "user_id": 116756,
      "last_update_date": "",
      "release_date": "1527680880000",
      "user_nick_name": "caimumu",
      "hot": 6,
      "replies": 0,
      "thumb_pic":
          "http://bbs.77bike.com/attachment/photo/Mon_1805/s_9190_6a9c15276521346cb082cb20cd5fa.jpg",
      "origin_pic":
          "http://bbs.77bike.com/attachment/photo/Mon_1805/9190_6a9c15276521346cb082cb20cd5fa.jpg"
    },
    {
      "album_id": 9190,
      "pic_id": 87973,
      "user_id": 116756,
      "last_update_date": "",
      "release_date": "1527680880000",
      "user_nick_name": "caimumu",
      "hot": 12,
      "replies": 0,
      "thumb_pic":
          "http://bbs.77bike.com/attachment/photo/Mon_1805/s_9190_c8ae15276521340b9091f75141c45.jpg",
      "origin_pic":
          "http://bbs.77bike.com/attachment/photo/Mon_1805/9190_c8ae15276521340b9091f75141c45.jpg"
    },
    {
      "album_id": 9190,
      "pic_id": 87972,
      "user_id": 116756,
      "last_update_date": "",
      "release_date": "1527680880000",
      "user_nick_name": "caimumu",
      "hot": 6,
      "replies": 0,
      "thumb_pic":
          "http://bbs.77bike.com/attachment/photo/Mon_1805/s_9190_e7f515276521344421220656267b6.jpg",
      "origin_pic":
          "http://bbs.77bike.com/attachment/photo/Mon_1805/9190_e7f515276521344421220656267b6.jpg"
    },
    {
      "album_id": 9190,
      "pic_id": 87971,
      "user_id": 116756,
      "last_update_date": "",
      "release_date": "1527680880000",
      "user_nick_name": "caimumu",
      "hot": 5,
      "replies": 0,
      "thumb_pic":
          "http://bbs.77bike.com/attachment/photo/Mon_1805/s_9190_db001527652134d470d0f1a08fbfd.jpg",
      "origin_pic":
          "http://bbs.77bike.com/attachment/photo/Mon_1805/9190_db001527652134d470d0f1a08fbfd.jpg"
    },
    {
      "album_id": 9190,
      "pic_id": 87970,
      "user_id": 116756,
      "last_update_date": "",
      "release_date": "1527680880000",
      "user_nick_name": "caimumu",
      "hot": 4,
      "replies": 0,
      "thumb_pic":
          "http://bbs.77bike.com/attachment/photo/Mon_1805/s_9190_45451527652134ea1180c703f665c.jpg",
      "origin_pic":
          "http://bbs.77bike.com/attachment/photo/Mon_1805/9190_45451527652134ea1180c703f665c.jpg"
    },
    {
      "album_id": 9190,
      "pic_id": 87969,
      "user_id": 116756,
      "last_update_date": "",
      "release_date": "1527680880000",
      "user_nick_name": "caimumu",
      "hot": 3,
      "replies": 0,
      "thumb_pic":
          "http://bbs.77bike.com/attachment/photo/Mon_1805/s_9190_441a1527652134dcc02d4a00a6e87.jpg",
      "origin_pic":
          "http://bbs.77bike.com/attachment/photo/Mon_1805/9190_441a1527652134dcc02d4a00a6e87.jpg"
    },
    {
      "album_id": 9190,
      "pic_id": 87968,
      "user_id": 116756,
      "last_update_date": "",
      "release_date": "1527680880000",
      "user_nick_name": "caimumu",
      "hot": 4,
      "replies": 0,
      "thumb_pic":
          "http://bbs.77bike.com/attachment/photo/Mon_1805/s_9190_80d51527652133ecf5c74246a4a13.jpg",
      "origin_pic":
          "http://bbs.77bike.com/attachment/photo/Mon_1805/9190_80d51527652133ecf5c74246a4a13.jpg"
    },
    {
      "album_id": 9190,
      "pic_id": 87967,
      "user_id": 116756,
      "last_update_date": "",
      "release_date": "1527680880000",
      "user_nick_name": "caimumu",
      "hot": 3,
      "replies": 0,
      "thumb_pic":
          "http://bbs.77bike.com/attachment/photo/Mon_1805/s_9190_b7701527652133cfa8f3b54114104.jpg",
      "origin_pic":
          "http://bbs.77bike.com/attachment/photo/Mon_1805/9190_b7701527652133cfa8f3b54114104.jpg"
    },
    {
      "album_id": 9190,
      "pic_id": 87966,
      "user_id": 116756,
      "last_update_date": "",
      "release_date": "1527680880000",
      "user_nick_name": "caimumu",
      "hot": 5,
      "replies": 0,
      "thumb_pic":
          "http://bbs.77bike.com/attachment/photo/Mon_1805/s_9190_28111527652133c1a575dfbc70d42.jpg",
      "origin_pic":
          "http://bbs.77bike.com/attachment/photo/Mon_1805/9190_28111527652133c1a575dfbc70d42.jpg"
    },
    {
      "album_id": 9190,
      "pic_id": 87965,
      "user_id": 116756,
      "last_update_date": "",
      "release_date": "1527680880000",
      "user_nick_name": "caimumu",
      "hot": 6,
      "replies": 0,
      "thumb_pic":
          "http://bbs.77bike.com/attachment/photo/Mon_1805/s_9190_2ac5152765213309cf94fc7ebb946.jpg",
      "origin_pic":
          "http://bbs.77bike.com/attachment/photo/Mon_1805/9190_2ac5152765213309cf94fc7ebb946.jpg"
    }
  ]
};
*/
