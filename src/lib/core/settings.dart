import 'package:scoped_model/scoped_model.dart';

class Settings extends Model {
  /// 1 = 无图模式
  /// 0 = 正常模式
  int textMode;

  /// 1 = 帖子内显示小图片
  /// 0 = 正常显示
  int smallImage;

  int cloudProcess;

  /// 1 = 倒序浏览
  /// 0 = 正序浏览
  int reverseOrder;

  int enableProxy;

  Settings(
      {this.textMode = 0,
      this.smallImage = 0,
      this.cloudProcess = 0,
      this.reverseOrder = 0,
      this.enableProxy = 0});

  void reset() {
    this.textMode = 0;
    this.smallImage = 0;
    this.cloudProcess = 0;
    this.reverseOrder = 0;
    this.enableProxy = 0;
    notifyListeners();
  }

  void update(
      {int textMode,
      int smallImage,
      int cloudProcess,
      int reverseOrder,
      int enableProxy}) {
    this.textMode = textMode ?? this.textMode;
    this.smallImage = smallImage ?? this.smallImage;
    this.cloudProcess = cloudProcess ?? this.cloudProcess;
    this.reverseOrder = reverseOrder ?? this.reverseOrder;
    this.enableProxy = enableProxy ?? this.enableProxy;
    notifyListeners();
  }

  Settings.fromJson(Map<String, dynamic> json)
      : textMode = json['textMode'] ?? 0,
        smallImage = json['smallImage'] ?? 0,
        cloudProcess = json['cloudProcess'] ?? 0,
        reverseOrder = json['reverseOrder'] ?? 0,
        enableProxy = json['enableProxy'] ?? 0;

  Map<String, dynamic> toJson() => {
        'textMode': textMode ?? 0,
        'smallImage': smallImage ?? 0,
        'cloudProcess': cloudProcess ?? 0,
        'reverseOrder': reverseOrder ?? 0,
        'enableProxy': enableProxy ?? 0
      };
}
