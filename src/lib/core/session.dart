import 'package:scoped_model/scoped_model.dart';

class Session extends Model {
  int uid;
  String token;
  String secret;
  String avatar;
  String userName;

  Session(
      {this.uid = 0,
      this.token = "",
      this.secret = "",
      this.avatar = "",
      this.userName = ""});

  void clear() {
    this.uid = 0;
    this.token = "";
    this.secret = "";
    this.avatar = "";
    this.userName = "";
    notifyListeners();
  }

  void update(
      {int uid, String token, String secret, String avatar, String userName}) {
    this.uid = uid ?? this.uid;
    this.token = token ?? this.token;
    this.secret = secret ?? this.secret;
    this.avatar = avatar ?? this.avatar;
    this.userName = userName ?? this.userName;
    notifyListeners();
  }

  Session.fromJson(Map<String, dynamic> json)
      : uid = json['uid'] ?? 0,
        token = json['token'] ?? "",
        secret = json['secret'] ?? "",
        avatar = json['avatar'] ?? "",
        userName = json['userName'] ?? "";

  Map<String, dynamic> toJson() => {
        'uid': uid ?? 0,
        'token': token,
        'secret': secret,
        'avatar': avatar,
        'userName': userName
      };
}
