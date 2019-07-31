import 'package:flutter/foundation.dart';

import '../common.dart';

class UserFavoriteAction {
  static const String action = "user/userfavorite";

  static Map<String, dynamic> buildFavoriteRequest(
      {String action = "favorite", @required int id, String idType = "tid"}) {
    return {"action": action, "id": id, "idType": idType};
  }

  static Map<String, dynamic> buildUnFavoriteRequest(
      {String action = "delfavorite",
      @required int id,
      String idType = "tid"}) {
    return {"action": action, "id": id, "idType": idType};
  }

  static MobcentResponse parseResponse(Map<String, dynamic> response) {
    return MobcentResponseSerializer().fromMap(response);
  }
}
