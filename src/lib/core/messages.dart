import 'package:scoped_model/scoped_model.dart';

class MessagesModel extends Model {
  MessagesModel() {}

  MessageDetails _atMeInfo = MessageDetails();

  MessageDetails _friendInfo = MessageDetails();

  MessageDetails _replyInfo = MessageDetails();

  MessageDetails get atMeInfo => _atMeInfo;

  MessageDetails get friendInfo => _friendInfo;

  MessageDetails get replyInfo => _replyInfo;

  bool get hasMessage =>
      atMeInfo.count > 0 || friendInfo.count > 0 || replyInfo.count > 0;

  dynamic pmInfos;

  void update(
      {MessageDetails atMeInfo,
      MessageDetails friendInfo,
      MessageDetails replyInfo}) {
    bool changed = false;
    if (this.atMeInfo.update(atMeInfo)) changed = true;
    if (this.friendInfo.update(friendInfo)) changed = true;
    if (this.replyInfo.update(replyInfo)) changed = true;
    if (changed) {
      notifyListeners();
    }
  }
}

class MessageDetails {
  MessageDetails({this.count = 0, this.time = "0"});

  /// 消息数量
  int count;

  /// 消息发生时间
  String time;

  DateTime get timeValue =>
      DateTime.fromMillisecondsSinceEpoch(int.tryParse(this.time));

  bool update(MessageDetails newInfo) {
    if (newInfo == null) return false;
    if (newInfo.count != this.count || newInfo.time != this.time) {
      this.time = newInfo.time;
      this.count = newInfo.count;
      return true;
    } else {
      return false;
    }
  }
}
