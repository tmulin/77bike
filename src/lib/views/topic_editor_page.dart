import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:photo/photo.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:qiqi_bike/api/mobcent_client.dart';
import 'package:qiqi_bike/core/application.dart';
import 'package:qiqi_bike/models/forum/forum_sendattachmentex.dart' as att;
import 'package:qiqi_bike/models/forum/forum_topicadmin.dart';
import 'package:qiqi_bike/widgets/mobcent_forum_faces.dart';

class TopicEditorPage extends StatefulWidget {
  /// 版块编号
  final int boardId;

  /// 主题编号
  final int topicId;

  /// 子分类编号
  final int typeId;

  /// 引用回帖时的引用编号
  final int replyId;

  TopicEditorPage(
      {this.boardId = 0, this.topicId = 0, this.typeId = 0, this.replyId = 0});

  @override
  _TopicEditorPageState createState() => _TopicEditorPageState();
}

class _TopicEditorPageState extends State<TopicEditorPage> {
  TextEditingController _topicTitleController;
  TextEditingController _topicContentController;
  FocusNode _topicContentFocusNode;

  int _boardId;
  String _boardName;

  /// 子分类编号
  int _typeId;
  String _typeName;

  List<AssetEntity> _attachments = [];

  @override
  void initState() {
    super.initState();

    _emojiController = ScrollController();
    _topicContentFocusNode = FocusNode();
    _topicContentController = TextEditingController();
    _topicTitleController = TextEditingController();

    /// 初始化属性
    this._boardId = widget.boardId;
    this._typeId = widget.typeId;

    print("BoardID => ${_boardId}");
    print("TypeID => ${_typeId}");
    print("ReplyID => ${widget.replyId}");
    print("TopicID => ${widget.topicId}");
  }

  Future<PostResult> _submitTopicContent(BuildContext context) async {
    final task = PostTask(
        boardId: _boardId,
        typeId: _typeId,
        topicId: widget.topicId,
        replyId: widget.replyId,
        title: _topicTitleController.text?.trim() ?? "",
        content: _topicContentController.text?.trim() ?? "",
        attachments: _attachments);

    final result = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return PostSubmitDialog(task);
        });
    if (result != null && result == true) {
      print("发帖成功, 关闭编辑器...");
      Navigator.of(context).pop<bool>(true);
    } else {
      print("发帖失败, 保留编辑器...");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool keyboardShowing = MediaQuery.of(context).viewInsets.bottom > 0;
    print("键盘状态 => ${keyboardShowing}");
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.topicId == 0 ? "发帖" : "回帖"),
          actions: <Widget>[
            Builder(builder: (context) {
              return RawMaterialButton(
                  child: Text("发布",
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                  constraints: BoxConstraints(minWidth: 60),
                  onPressed: () => _submitTopicContent(context));
            })
          ],
        ),
        body: Builder(builder: (context) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanDown: (_) {
              // FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Stack(
              children: <Widget>[
                Scrollbar(
                  child: ListView(
                    //shrinkWrap: true,
                    children: <Widget>[
                      if (widget.topicId == 0) ...[
                        _buildBoardSelection(context),
                        Divider(height: 0),
                        _buildBoardTypeSelection(context),
                        Divider(height: 0),
                        _buildTopicTitleEditor(context),
                      ],
                      _buildTopicContentEditor(context),
                      Divider(height: 0),
                      _buildTopicImagesEditor(context),
                    ],
                  ),
                ),
                if (keyboardShowing || _showEmojiPanel)
                  Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: _buildEmojiContainer()),
              ],
            ),
          );
        }));
  }

  bool _showEmojiPanel = false;
  ScrollController _emojiController;

  Widget _buildEmojiContainer() {
    final emojis = <Widget>[
      for (var face in MobcentForumFaces.faceLabelMap.entries)
        EmojiWidget(
            key: ValueKey(face.key),
            size: 32,
            face: face.value,
            topicContentController: _topicContentController),
    ];

    return Stack(
      alignment: Alignment.centerRight,
      children: <Widget>[
        Container(
          constraints: BoxConstraints(maxHeight: 150),
          padding: EdgeInsets.only(left: 32, top: 8, bottom: 8, right: 32),
          color: Colors.grey.shade100,
          child: _showEmojiPanel
              ? GridView.count(
                  scrollDirection: Axis.horizontal,
                  crossAxisCount: 3,
                  children: emojis)
              : SingleChildScrollView(
                  controller: _emojiController,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(children: emojis),
                ),
        ),
        Positioned(
          left: 0,
          child: GestureDetector(
            onTap: () {
              final offset = _emojiController.offset -
                  MediaQuery.of(context).size.width +
                  80;
              _emojiController.animateTo(offset < 0 ? -30 : offset,
                  duration: Duration(milliseconds: 350),
                  curve: Curves.fastOutSlowIn);
            },
            child: Container(
              child: Icon(Icons.chevron_left, size: 28, color: Colors.black),
            ),
          ),
        ),
        Positioned(
          right: 0,
          child: GestureDetector(
            onTap: () {
              final width = MediaQuery.of(context).size.width;
              final offset = _emojiController.offset + width - 80;
              _emojiController.animateTo(
                  offset > _emojiController.offset + width - 80 ? 30 : offset,
                  duration: Duration(milliseconds: 350),
                  curve: Curves.fastOutSlowIn);
            },
            child: Container(
              child: Icon(Icons.chevron_right, size: 28, color: Colors.black),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildEmojiContainerEx() {
    final emojis = <Widget>[
      for (var face in MobcentForumFaces.faceLabelMap.entries)
        EmojiWidget(
            key: ValueKey(face.key),
            size: 32,
            face: face.value,
            topicContentController: _topicContentController),
    ];

    return Stack(
      alignment: Alignment.centerRight,
      children: <Widget>[
        Container(
          constraints: BoxConstraints(maxHeight: 150),
          padding: EdgeInsets.only(left: 8, top: 8, bottom: 8, right: 40),
          color: Colors.grey.shade100,
          child: _showEmojiPanel
              ? GridView.count(
                  scrollDirection: Axis.horizontal,
                  crossAxisCount: 3,
                  children: emojis)
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: emojis),
                ),
        ),
        Positioned(
          right: 8,
          child: Container(
            padding: EdgeInsets.only(left: 4),
            decoration: BoxDecoration(
                border: Border(
                    left: BorderSide(color: Colors.grey.shade400, width: 2))),
            child: GestureDetector(
              onTap: () {
                print("显示全部表情 ……");
                FocusScope.of(context).requestFocus(FocusNode());
                setState(() {
                  _showEmojiPanel = !_showEmojiPanel;
                });
                if (!_showEmojiPanel) {
                  _topicContentFocusNode.requestFocus();
                }
              },
              child: Center(
                child: Icon(
                  _showEmojiPanel ? Icons.keyboard : Icons.tag_faces,
                  size: 28,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildBoardSelection(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListTile(
        title: Text("版块"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(_boardName ?? "请选择版块"),
            Icon(Icons.chevron_right)
          ],
        ),
        onTap: () {
          //Scaffold.of(context).showBottomSheet((BuildContext context) {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                    child: ListView(
                  shrinkWrap: true,
                  children: ApplicationCore.forum.boardCategories.map((cate) {
                    return Column(children: [
                      Container(
                        color: Colors.grey.shade200,
                        child: ListTile(
                          dense: true,
                          title: Text(
                            cate.board_category_name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final board = cate.board_list[index];
                            return ListTile(
                                dense: true,
                                title: Text(board.board_name),
                                trailing: Icon(Icons.check_circle_outline,
                                    color: board.board_id == this._boardId
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey.shade300),
                                onTap: () {
                                  setState(() {
                                    if (board.board_id != this._boardId) {
                                      /// 切换版块,清空已经选择的分类
                                      this._typeId = 0;
                                      this._typeName = null;
                                    }
                                    this._boardId = board.board_id;
                                    this._boardName = board.board_name;
                                  });
                                  Navigator.pop<bool>(context, true);
                                });
                          },
                          separatorBuilder: (context, index) =>
                              Divider(height: 0),
                          itemCount: cate.board_list.length)
                    ]);
                  }).toList(),
                ));
              });
        },
      ),
    );
  }

  Widget _buildBoardTypeSelection(BuildContext context) {
    final classes = ApplicationCore.forum.boardClasses[this._boardId] ?? [];
    if (classes.length == 0) return Container();
    return Container(
      color: Colors.white,
      child: ListTile(
        title: Text("分类"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(_typeName ?? "请选择分类"),
            Icon(Icons.chevron_right)
          ],
        ),
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                  child: ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ListTile(
                            dense: true,
                            title: Text(classes[index].name),
                            trailing: Icon(Icons.check_circle_outline,
                                color: classes[index].id == this._typeId
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey.shade300),
                            onTap: () {
                              setState(() {
                                this._typeId = classes[index].id;
                                this._typeName = classes[index].name;
                              });
                              Navigator.pop<bool>(context, true);
                            });
                      },
                      separatorBuilder: (context, index) => Divider(height: 0),
                      itemCount: classes.length));
            },
          );
        },
      ),
    );
  }

  Widget _buildTopicTitleEditor(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 8, bottom: 0),
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 0),
      child: TextField(
        maxLines: 2,
        controller: _topicTitleController,
        decoration: InputDecoration(
            hintText: "标题...",
            border: InputBorder.none,
            focusedBorder: InputBorder.none),
      ),
    );
  }

  Widget _buildTopicContentEditor(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 8, bottom: 0),
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: TextField(
        maxLength: 8192,
        maxLines: null,
        minLines: 8,
        focusNode: _topicContentFocusNode,
        scrollPhysics: NeverScrollableScrollPhysics(),
        controller: _topicContentController,
        decoration: InputDecoration(hintText: "说点什么吧..."),
      ),
    );
  }

  Widget _buildTopicImagesEditor(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 8, bottom: 8),
      child: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        children: <Widget>[
          ..._buildTopicImagesGalerry(context),
          if (_attachments.length < 9)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ImageSelectButton(
                onTap: () async {
                  await _handleImageSelect(context);
                },
              ),
            ),
          if (_attachments.length == 0)
            Align(alignment: Alignment.centerLeft, child: Text("添加照片")),
        ],
      ),
    );
  }

  List<Widget> _buildTopicImagesGalerry(BuildContext context,
      {double imageSize = 96}) {
    return this._attachments.map((attachment) {
      return Stack(
        key: ValueKey(attachment.id),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ImageAssetWidget(asset: attachment, size: imageSize),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _attachments
                      .removeWhere((asset) => asset.id == attachment.id);
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24)),
                padding: EdgeInsets.all(2),
                child: Icon(Icons.cancel, color: Colors.red, size: 24),
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

  void _handleImageSelect(BuildContext context) async {
    List<AssetEntity> selectedImages = await PhotoPicker.pickAsset(
        context: context,
        pickType: PickType.onlyImage,
        rowCount: 4,
        maxSelected: 8);

    if (selectedImages == null) {
      /// 未获取权限时可能返回null
      return;
    }

    for (var asset in selectedImages) {
      print("==> ${asset.id}");
      if (_attachments.indexWhere((file) => file.id == asset.id) < 0) {
        _attachments.add(asset);
      }
    }

    //_attachments.addAll(selectedImages[0].id);
    setState(() {});
  }
}

class EmojiWidget extends StatelessWidget {
  const EmojiWidget({
    Key key,
    @required this.face,
    @required this.size,
    @required TextEditingController topicContentController,
  })  : _topicContentController = topicContentController,
        super(key: key);

  final double size;
  final String face;
  final TextEditingController _topicContentController;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: GestureDetector(
            onTap: () {
              print("表情 ==> ${face} : ${_topicContentController.selection}");

              final text = _topicContentController.text;
              final selection = _topicContentController.selection;
              final int fixStart = selection.start < 0 ? 0 : selection.start;
              final int fixEnd = selection.end < 0 ? 0 : selection.end;
              final newText = text.replaceRange(fixStart, fixEnd, face);
              _topicContentController.value = _topicContentController.value
                  .copyWith(
                      text: newText,
                      selection: TextSelection.collapsed(
                          offset: fixStart + face.length));
            },
            child: MobcentForumFaces.loadAssetImage(face, size: size)));
  }
}

class ImageSelectButton extends StatelessWidget {
  final double size;
  final GestureTapCallback onTap;

  ImageSelectButton({this.onTap, this.size = 64});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        dashPattern: [8, 3],
        color: Colors.grey.shade400,
        child: Align(
          alignment: Alignment.center,
          child: Icon(
            Icons.add,
            color: Colors.grey.shade200,
            size: size,
          ),
        ),
      ),
    );
  }
}

class ImageAssetWidget extends StatefulWidget {
  final AssetEntity asset;
  final double size;

  ImageAssetWidget({@required this.asset, this.size = 64});

  @override
  _ImageAssetWidgetState createState() => _ImageAssetWidgetState();
}

class _ImageAssetWidgetState extends State<ImageAssetWidget> {
  File _file;
  Uint8List _fileData;

  @override
  void initState() {
    super.initState();
    widget.asset.thumbData.then((value) {
      setState(() {
        _fileData = value;
      });
    });
//    widget.asset.file.then((value) {
//      setState(() {
//        _file = value;
//      });
//    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size,
      width: widget.size,
      color: Colors.white,
      child: _fileData == null
          ? Container()
          : Image.memory(_fileData, fit: BoxFit.cover),
    );
  }
}

class PostResult {
  bool success;

  String message;

  PostResult({this.success, this.message});

  PostResult.success(String message) : this(success: true, message: message);

  PostResult.failed(String message) : this(success: false, message: message);
}

class PostTask {
  /// 版块编号
  final int boardId;

  /// 主题编号
  final int topicId;

  /// 子分类编号
  final int typeId;

  /// 引用回帖时的引用编号
  final int replyId;

  final String title;

  final String content;

  final List<AssetEntity> attachments;

  PostTask(
      {this.boardId = 0,
      this.topicId = 0,
      this.typeId = 0,
      this.replyId = 0,
      String title = "",
      String content = "",
      List<AssetEntity> attachments})
      : this.title = title?.trim() ?? "",
        this.content = content?.trim() ?? "",
        this.attachments = attachments ?? [];

  String isValid() {
    if (topicId == 0) {
      if (title.length == 0) {
        return "标题不能为空 ~~~";
      }
    }
    if (content.length == 0) {
      return "内容不能为空 ~~~!";
    }
    return null;
  }
}

class PostSubmitDialog extends StatefulWidget {
  final PostTask task;

  PostSubmitDialog(this.task);

  @override
  _PostSubmitDialogState createState() => _PostSubmitDialogState();
}

class _PostSubmitDialogState extends State<PostSubmitDialog> {
  /// stage
  /// 0 : 未启动
  /// 1 : 已启动
  /// 2 : 成功完成
  /// < 0 : 执行失败
  int stage = 0;
  String message;

  Future<void> _executePostTask() async {
    final String errorMessage = widget.task.isValid();
    if (errorMessage != null) {
      setState(() {
        stage = -1;
        message = errorMessage;
      });
      return;
    }
    stage = 1;

    List<Attachment> postAttachments = [];

    if (widget.task.attachments.length > 0) {
      final arguments =
          att.SendAttachmentAction.buildForumRequest(fid: widget.task.boardId);
      final attachments = List<File>();
      for (var asset in widget.task.attachments) {
        attachments.add(await asset.file);
      }
      final attachmentResponse = await MobcentClient.instance
          .sendAttactment(arguments, attachments, timeout: 120000,
              onSendProgress: (count, total) {
        print(
            "正在上传 ${count}/${total} => ${(count.toDouble() * 100 / total).toStringAsFixed(2)}% ...");
      });
      print(
          "附件上传结果 => ${att.SendAttachmentResponseSerializer().toMap(attachmentResponse)}");

      if (!attachmentResponse.noError) {
        setState(() {
          stage = -2;
          message = attachmentResponse?.head?.errInfo;
        });
        return;
      }

      postAttachments = attachmentResponse.body.attachment
          .map((item) => new Attachment(id: item.id, urlName: item.urlName))
          .toList();
    }

    if (widget.task.topicId == 0) {
      /// 发帖
      var model = PublishTopicModel.post(
          fid: widget.task.boardId,
          title: widget.task.title,
          typeId: widget.task.typeId,
          textContent: widget.task.content,
          attachments: postAttachments);
      Map<String, dynamic> data = TopicAdminAction.buildCreateRequest(model);
      print(data);

      final response = await MobcentClient.instance.createTopic(model);

      setState(() {
        stage = response.noError ? 2 : -3;
        message = response?.head?.errInfo;
      });
    } else {
      /// 回帖
      var model = PublishTopicModel.reply(
          fid: widget.task.boardId,
          tid: widget.task.topicId,
          textContent: widget.task.content,
          replyId: widget.task.replyId,
          attachments: postAttachments);
      Map<String, dynamic> data = TopicAdminAction.buildReplyRequest(model);
      print(data);

      final response = await MobcentClient.instance.createTopicReply(model);
      setState(() {
        stage = response.noError ? 2 : -3;
        message = response?.head?.errInfo;
      });
    }
    if (stage == 2) {
      /// 操作成功,延迟2秒自动关闭
      Future.delayed(Duration(milliseconds: 2000)).then((_) {
        Navigator.of(context).pop<bool>(true);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    print("ExecutePostTask ...");
    this._executePostTask();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        print("Empty Space Taped!");
        if (stage < 0) {
          Navigator.pop<bool>(context, false);
        } else if (stage == 2) {
          Navigator.of(context).pop<bool>(true);
        }
      },
      child: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (stage == 1)
                SpinKitFadingCircle(
                  color: Colors.white,
                  size: 80,
                ),
              if (stage < 0) _buildFailedMessage(context),
              if (stage == 2) _buildSuccessMessage(context),
            ],
          ),
        ),
      ),
    );
  }

  _buildFailedMessage(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 32),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(message ?? "",
                    softWrap: true,
                    style: TextStyle(color: Colors.red, fontSize: 18)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildSuccessMessage(BuildContext context) {
    return Card(
        color: Theme.of(context).backgroundColor,
        margin: EdgeInsets.symmetric(horizontal: 32),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "发帖成功!",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, letterSpacing: 2),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
