import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:path/path.dart' as iop;
import 'package:qiqi_bike/common/data_helper.dart';
import 'package:qiqi_bike/core/application.dart';
import 'package:qiqi_bike/core/build.dart';
import 'package:qiqi_bike/models/app_initui.dart';
import 'package:qiqi_bike/models/common.dart';
import 'package:qiqi_bike/models/forum/forum_forumlist.dart';
import 'package:qiqi_bike/models/forum/forum_postlist.dart';
import 'package:qiqi_bike/models/forum/forum_search.dart';
import 'package:qiqi_bike/models/forum/forum_sendattachmentex.dart';
import 'package:qiqi_bike/models/forum/forum_topicadmin.dart';
import 'package:qiqi_bike/models/forum/forum_topiclist.dart';
import 'package:qiqi_bike/models/message/message_heart.dart';
import 'package:qiqi_bike/models/message/message_notifylist.dart';
import 'package:qiqi_bike/models/message/message_pmsessionlist.dart';
import 'package:qiqi_bike/models/user/user_albumlist.dart';
import 'package:qiqi_bike/models/user/user_getsetting.dart';
import 'package:qiqi_bike/models/user/user_login.dart';
import 'package:qiqi_bike/models/user/user_register.dart';
import 'package:qiqi_bike/models/user/user_sign.dart';
import 'package:qiqi_bike/models/user/user_topiclist.dart';
import 'package:qiqi_bike/models/user/user_userinfo.dart';

/// https://github.com/appbyme/mobcent-discuz/tree/84a86890c6e116a0ebfd25058c5e436868e7be80/app/controllers/user
class MobcentClient {
  static const String baseUrl =
      "http://bbs.77bike.com/mobcent/app/web/index.php";

  factory MobcentClient() => _getInstance();

  static String _userAgent =
      "Mozilla/5.0 (iPhone; CPU iPhone OS 12_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 Appbyme";

  //  "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 7 Build/MOB30X; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/44.0.2403.117 Safari/537.36 Appbyme"
  //  "Mozilla/5.0 (Linux; Android 9; ELE-AL00 Build/HUAWEIELE-AL00; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/72.0.3626.121 Mobile Safari/537.36"

  static String get userAgent {
    if (Platform.isAndroid)
      return "Mozilla/5.0 (Linux; Android 6.0.1; Nexus 7 Build/MOB30X; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/44.0.2403.117 Safari/537.36 Appbyme";
    return _userAgent;
  }

  static set userAgent(String value) => _userAgent = value;

  static MobcentClient get instance => _getInstance();
  static MobcentClient _instance;

  Dio _dio;

  MobcentClient._internal() {
    _dio = new Dio(new BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: 30000,
      receiveTimeout: 30000,
      headers: {HttpHeaders.userAgentHeader: userAgent},
      contentType: ContentType.json,
    ));

    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      if (Build.inDevelopment && ApplicationCore.settings.enableProxy > 0) {
        client.findProxy = (uri) {
          return "PROXY 192.168.1.10:8888";
        };
      }
    };
  }

  static MobcentClient _getInstance() {
    if (_instance == null) {
      _instance = MobcentClient._internal();
    }
    return _instance;
  }

  Options _buildOptions() {
    return Options(headers: {});
  }

  /// (dynamic, StackTrace) -> FutureOr<T>
  Response<Map<String, dynamic>> dioErrorTransformer(error, stackTrace) {
    print("dio catchError ...");
    print(error);
    if (error is DioError) {
      if (error.response != null) {
        print(error.response);
        try {
          return Response(
              data: MobcentResponseSerializer().toMap(MobcentResponse(
                  errcode: error.response.statusCode,
                  head: ResponseHead(
                      errCode: error.response.statusCode,
                      errInfo: error.response.statusMessage))));
        } catch (exp) {
          return Response(
              data: MobcentResponseSerializer().toMap(MobcentResponse(
                  errcode: error.response.statusCode,
                  head: ResponseHead(
                      errCode: error.response.statusCode,
                      errInfo: error.response.statusMessage))));
        }
      } else {
        final data = MobcentResponseSerializer().toMap(MobcentResponse(
            errcode: -1,
            head: ResponseHead(errCode: -1, errInfo: error.message)));
        return Response(data: data);
      }
    } else {
      final data = MobcentResponseSerializer().toMap(MobcentResponse(
          errcode: -1,
          head: ResponseHead(errCode: -1, errInfo: "未知错误"))) as dynamic;
      return Response(data: data);
    }
  }

  Future<dynamic> _get(String path, {var data}) async {
    var response = await _dio
        .get<Map<String, dynamic>>(path,
            queryParameters: data, options: _buildOptions())
        .catchError(dioErrorTransformer);
    return response.data;
  }

  Future<AppInitUIResponse> appInitUI() async {
    Map<String, dynamic> data = AppInitUIAction.buildRequest();

    var response = await _post(AppInitUIAction.action,
        data: ApplicationCore.buildCommonParameters()..addAll(data));

    assert(response is Map);

    return AppInitUIAction.parseResponse(response);
  }

  /// 返回map格式的请求body
  Future<dynamic> _post(String action,
      {Map<String, dynamic> data,
      Map<String, dynamic> queryParameters,
      void Function(int count, int total) onSendProgress}) async {
    Response response = await _dio
        .post<Map<String, dynamic>>("?r=${action}",
            data: data,
            queryParameters: queryParameters,
            options: _buildOptions().merge(
                responseType: ResponseType.json,
                contentType:
                    ContentType.parse("application/x-www-form-urlencoded")),
            onSendProgress: onSendProgress)
        .catchError(dioErrorTransformer);
    return response.data;
  }

  Future<MobcentResponse> userSign() async {
    Map<String, dynamic> data = UserSignAction.buildRequest();

    var response = await _post(UserSignAction.action,
        data: ApplicationCore.buildCommonParameters()..addAll(data));

    assert(response is Map);

    return UserSignAction.parseResponse(response);
  }

  Future<UserGetSettingResponse> userGetSetting() async {
    Map<String, dynamic> data = UserGetSettingAction.buildRequest();

    var response = await _post(UserGetSettingAction.action,
        data: ApplicationCore.buildCommonParameters()..addAll(data));

    assert(response is Map);

    return UserGetSettingAction.parseResponse(response);
  }

  Future<UserLoginResponse> userLogin(
      {String username = "MOBCENT@hacker#007",
      String password = "MOBCENT@hacker#007"}) async {
    Map<String, dynamic> data =
        UserLoginAction.buildRequest(username: username, password: password);

    var response = await _post(UserLoginAction.action,
        data: ApplicationCore.buildCommonParameters()..addAll(data));

    assert(response is Map);

    return UserLoginAction.parseResponse(response);
  }

  Future<UserRegisterResponse> userRegister(
      {String username, String password, String email}) async {
    assert(!DataHelper.isIsNullOrWhiteSpaceString(username));
    assert(!DataHelper.isIsNullOrWhiteSpaceString(password));
    assert(!DataHelper.isIsNullOrWhiteSpaceString(email));

    Map<String, dynamic> data = UserRegisterAction.buildRequest(
        username: username, password: password, email: email);

    var response = await _post(UserRegisterAction.action,
        data: ApplicationCore.buildCommonParameters()..addAll(data));

    assert(response is Map);

    return UserRegisterAction.parseResponse(response);
  }

  Future<UserInfoResponse> userGetUserInfo(int userId) async {
    Map<String, dynamic> data = UserGetInfoAction.buildRequest(userId);

    var response = await _post(UserGetInfoAction.action,
        data: ApplicationCore.buildCommonParameters()..addAll(data));

    assert(response is Map);

    return UserGetInfoAction.parseResponse(response);
  }

  /// 获取用户发表的帖子列表
  Future<ForumSearchResponse> userTopicList(int userId,
      {int page: 1, int pageSize: 20}) async {
    Map<String, dynamic> data = UserTopicListAction.buildRequest(userId,
        page: page, pageSize: pageSize);

    var response = await _post(UserTopicListAction.action,
        data: ApplicationCore.buildCommonParameters()..addAll(data));

    assert(response is Map);

    return UserTopicListAction.parseResponse(response);
  }

  /// 获取用户发表的帖子列表
  Future<ForumSearchResponse> userReplyList(int userId,
      {int page: 1, int pageSize: 20}) async {
    Map<String, dynamic> data = UserTopicListAction.buildRequest(userId,
        page: page, pageSize: pageSize, type: "reply");

    var response = await _post(UserTopicListAction.action,
        data: ApplicationCore.buildCommonParameters()..addAll(data));

    assert(response is Map);

    return UserTopicListAction.parseResponse(response);
  }

  Future<ForumListResponse> forumList() async {
    Map<String, dynamic> data = ForumListAction.buildRequest();

    var response = await _post(ForumListAction.action,
        data: ApplicationCore.buildCommonParameters()..addAll(data));

    assert(response is Map);

    return ForumListAction.parseResponse(response);
  }

  Future<ForumSearchResponse> forumSearch(String keyword,
      {int page: 1, int pageSize: 20}) async {
    Map<String, dynamic> data = ForumSearchAction.buildRequest(
        keyword: keyword, page: page, pageSize: pageSize);

    var response = await _post(ForumSearchAction.action,
        data: ApplicationCore.buildCommonParameters()..addAll(data));

    assert(response is Map);

    return ForumSearchAction.parseResponse(response);
  }

  Future<TopicListResponse> topicList(
      {int boardId = 0,
      int filterId = 0,
      int page = 1,
      String sortBy = TopicListAction.sortByNew}) async {
    Map<String, dynamic> data = TopicListAction.buildRequest(
        boardId: boardId ?? 0,
        filterId: filterId ?? 0,
        page: page ?? 1,
        isImageList: 1,
        isRatio: 0,
        sortBy: sortBy ?? TopicListAction.sortByNew);

    var response = await _post(TopicListAction.action,
        data: ApplicationCore.buildCommonParameters()..addAll(data));

    assert(response is Map);

    return TopicListAction.parseResponse(response);
  }

  /// 最新帖子
  Future<TopicListResponse> newTopicList(
      {int boardId = 0, int filterId, int page = 1}) async {
    return topicList(
        boardId: boardId, page: page, sortBy: TopicListAction.sortByNew);
  }

  /// 精华帖子
  Future<TopicListResponse> marrowTopicList(
      {int boardId = 0, int filterId, int page = 1}) async {
    return topicList(
        boardId: boardId,
        filterId: filterId,
        page: page,
        sortBy: TopicListAction.sortByMarrow);
  }

  /// 全部帖子
  Future<TopicListResponse> allTopicList(
      {int boardId, int filterId, int page = 1}) async {
    assert(boardId != null && boardId > 0);

    return topicList(
        boardId: boardId,
        filterId: filterId,
        page: page,
        sortBy: TopicListAction.sortByAll);
  }

  /// 置顶帖子
  Future<TopicListResponse> topTopicList(
      {int boardId, int filterId, int page = 1}) async {
    assert(boardId != null && boardId > 0);
    return topicList(
        boardId: boardId,
        filterId: filterId,
        page: page,
        sortBy: TopicListAction.sortByTop);
  }

  /*
   * authorId: 作者用户编号(只看某个人的回复)
   */
  Future<PostListResponse> postList(
      {int topicId,
      int authorId = 0,
      int page = 1,
      int order: PostListAction.orderByAsc}) async {
    Map<String, dynamic> data = PostListAction.buildRequest(
        topicId: topicId, authorId: authorId, page: page, order: order);

    var response = await _post(PostListAction.action,
        data: ApplicationCore.buildCommonParameters()..addAll(data));

    assert(response is Map);

    return PostListAction.parseResponse(response);
  }

  /// 发帖
  Future<MobcentResponse> createTopic(PublishTopicModel model) async {
    Map<String, dynamic> data = TopicAdminAction.buildCreateRequest(model);

    var response = await _post(TopicAdminAction.action,
        data: ApplicationCore.buildCommonParameters()..addAll(data));

    assert(response is Map);

    return TopicAdminAction.parseResponse(response);
  }

  /// 回帖
  Future<MobcentResponse> createTopicReply(PublishTopicModel model) async {
    Map<String, dynamic> data = TopicAdminAction.buildReplyRequest(model);

    var response = await _post(TopicAdminAction.action,
        data: ApplicationCore.buildCommonParameters()..addAll(data));

    assert(response is Map);

    return TopicAdminAction.parseResponse(response);
  }

  Size calcSize(int width, int height) {
    final double maxWidth = 720;
    final double maxHeight = 1280;
    double ratio = 1;
    if ((width / maxWidth) > (height / maxHeight)) {
      ratio = width / maxWidth;
    } else {
      ratio = height / maxHeight;
    }

    return Size(width / ratio, height / ratio);
  }

  Future<File> compressImage(File sourceImage) async {
    try {
      final int sourceLength = sourceImage.lengthSync();
      if (sourceLength < 400 * 1000) {
        print("压缩图片 : 原文件字节数 ${sourceImage.lengthSync()} 小于 400k, 无需压缩");
        return sourceImage;
      }

      ImageProperties properties =
          await FlutterNativeImage.getImageProperties(sourceImage.path);
      Size targetSize = calcSize(properties.width, properties.height);

      print(
          "压缩图片 : 原尺寸 W:${properties.width} H:${properties.height} => 新尺寸 W:${targetSize.width} H:${targetSize.height}");

      File compressedImage = await FlutterNativeImage.compressImage(
        sourceImage.path,
        quality: 80,
        targetWidth: targetSize.width.toInt(),
        targetHeight: targetSize.height.toInt(),
      );

      print(
          "压缩图片 : 原文件字节数 ${sourceImage.lengthSync()} => 新文件字节数 ${compressedImage.lengthSync()}");

      return compressedImage;
    } catch (exp) {
      print("压缩图片失败 : ${exp}");
      return sourceImage;
    }
  }

  /// 上传图片
  /// argument 使用 SendAttachmentAction 的build方法构建
  Future<SendAttachmentResponse> sendAttactment(
      Map<String, String> arguments, List<File> attachments,
      {void Function(int count, int total) onSendProgress}) async {
    Map<String, dynamic> parameters = ApplicationCore.buildCommonParameters()
      ..addAll(arguments);

    List<UploadFileInfo> uploadInfos = [];

    for (var file in attachments) {
      /// 获取文件名
      final fileName = iop.basename(file.path);

      /// 获取文件类型
      final ContentType contentType = getContentType(iop.extension(file.path));

      /// 压缩图片
      final compressedFile = await compressImage(file);

      /// 构建上传信息
      uploadInfos.add(new UploadFileInfo(compressedFile, fileName,
          contentType: contentType));
    }

    FormData formData = new FormData.from({
      /// 服务器端为PHP,需要加[]
      "uploadFile[]": uploadInfos
    });

    var response = await _post(SendAttachmentAction.action,
        data: formData,
        queryParameters: parameters,
        onSendProgress: onSendProgress);

    assert(response is Map);

    return SendAttachmentAction.parseResponse(response);
  }

  Future<MessageHeartResponse> messageHeart() async {
    Map<String, dynamic> data = MessageHeartAction.buildRequest();

    var response = await _post(MessageHeartAction.action,
        data: ApplicationCore.buildCommonParameters()..addAll(data));

    assert(response is Map);

    return MessageHeartAction.parseResponse(response);
  }

  Future<MessagePmSessionListResponse> messageListPmSession({int page}) async {
    Map<String, dynamic> data =
        MessagePmSessionListAction.buildRequest(page: page);

    var response = await _post(MessagePmSessionListAction.action,
        data: ApplicationCore.buildCommonParameters()..addAll(data));

    assert(response is Map);

    return MessagePmSessionListAction.parseResponse(response);
  }

  /// 评论
  Future<MessageNotifyListResponse> messageListNotify({int page = 1}) async {
    Map<String, dynamic> data =
        MessageNotifyListAction.buildRequest(page: page);

    var response = await _post(MessageNotifyListAction.action,
        data: ApplicationCore.buildCommonParameters()..addAll(data));

    assert(response is Map);

    return MessageNotifyListAction.parseResponse(response);
  }

  ContentType getContentType(String extension) {
    switch (extension) {
      case ".jpg":
      case ".jpeg":
        return ContentType("image", "jpeg");
      case ".png":
        return ContentType("image", "png");
      case ".mp3":
        return ContentType("audio", "mp3");
      default:
        return ContentType.binary;
    }
  }

  Future<UserAlbumlistResponse> userListAlbum(int userId,
      {int page = 1, int pageSize = 20}) async {
    Map<String, dynamic> data = UserAlbumlistAction.buildRequest(userId,
        page: page, pageSize: pageSize);

    var response = await _post(UserAlbumlistAction.action,
        data: ApplicationCore.buildCommonParameters()..addAll(data));

    assert(response is Map);

    return UserAlbumlistAction.parseResponse(response);
  }

  Future<UserPhotolistResponse> userListPhotosInAlbum(int userId, int albumId,
      {int page = 1, int pageSize = 20}) async {
    Map<String, dynamic> data = UserPhotolistAction.buildRequest(
        userId, albumId,
        page: page, pageSize: pageSize);

    var response = await _post(UserPhotolistAction.action,
        data: ApplicationCore.buildCommonParameters()..addAll(data));

    assert(response is Map);

    return UserPhotolistAction.parseResponse(response);
  }
}
