import 'package:qiqi_bike/models/forum/forum_search.dart';

class UserTopicListAction {
  static const String action = "user/topiclist";

  static Map<String, dynamic> buildRequest(int userId,
      {int page = 1, int pageSize = 20, String type = "topic"}) {
    return {
      "uid": userId,
      "type": type,
      "page": page,
      "pageSize": pageSize,
    };
  }

  static ForumSearchResponse parseResponse(Map<String, dynamic> response) {
    return ForumSearchResponseSerializer().fromMap(response);
  }
}