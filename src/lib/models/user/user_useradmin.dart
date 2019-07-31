import '../common.dart';

class UserAdminAction {
  static const String action = "user/useradmin";

  static Map<String, dynamic> buildFollowRequest(int userId) {
    return {"uid": userId, "type": "follow"};
  }

  static Map<String, dynamic> buildUnFollowRequest(int userId) {
    return {"uid": userId, "type": "unfollow"};
  }

  static MobcentResponse parseResponse(Map<String, dynamic> response) {
    return MobcentResponseSerializer().fromMap(response);
  }
}
