import 'package:flutter/material.dart';
import 'package:qiqi_bike/api/mobcent_client.dart';
import 'package:qiqi_bike/models/message/message_pmsession.dart';
import 'package:qiqi_bike/models/message/message_pmsessionlist.dart' as pmsl;
import 'package:qiqi_bike/widgets/user_avatar_widget.dart';

class MessageChatPage extends StatefulWidget {
  final int pmid;
  final int plid;
  final int userId;
  final String userName;

  MessageChatPage({this.pmid, this.plid, this.userId, this.userName});

  @override
  _MessageChatPageState createState() => _MessageChatPageState();
}

class _MessageChatPageState extends State<MessageChatPage> {
  int _pmid;
  int _plid;
  bool success = false;
  String errorMessage;
  PmSession _session = PmSession();
  PmUserInfo _userInfo = PmUserInfo();
  TextEditingController _controller;
  ScrollController _scrollController;
  FocusNode _focusNode;

  loadData() async {
    final response = await MobcentClient.instance
        .messageGetPmSession(pmid: _pmid, plid: _plid, fromUid: widget.userId);
    success = response.noError;
    errorMessage = response.head?.errInfo;
    _session = response.body.pmList.isNotEmpty
        ? response.body.pmList.first
        : PmSession();
    _userInfo = response.body.userInfo;
    setState(() {});

//    SchedulerBinding.instance.addPostFrameCallback((_) {
//      _scrollController.position
//          .jumpTo(_scrollController.position.maxScrollExtent);
//    });
  }

  Future<void> prepareSession() async {
    print("准备聊天会话 => ${_plid}:${_pmid} ...");
    if (_plid != null && _plid > 0) {
      print("准备聊天会话完成 => ${_plid}:${_pmid} ...");
      return;
    }
    final response = await MobcentClient.instance.messageListPmSession();
    if (response.noError) {
      if (response.body?.list != null) {
        final session = response.body.list.firstWhere(
            (session) => session.toUserId == widget.userId,
            orElse: () => new pmsl.PmSession());
        if (session.pmid != null) this._pmid = session.pmid;
        if (session.plid != null) this._plid = session.plid;

        print("准备聊天会话完成 => ${_plid}:${_pmid} ...");
      }
    } else {
      print("准备聊天会话失败 => ${response.head.errInfo} ...");
    }
  }

  @override
  void initState() {
    super.initState();
    _pmid = widget.pmid;
    _plid = widget.plid;
    _focusNode = FocusNode();
    _controller = TextEditingController();
    _scrollController = ScrollController();
    prepareSession().then((value) {
      loadData();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    if (MediaQuery.of(context).viewInsets.bottom > 0) {
//      SchedulerBinding.instance.addPostFrameCallback((_) {
//        _scrollController.animateTo(
//          _scrollController.position.maxScrollExtent,
//          duration: const Duration(milliseconds: 300),
//          curve: Curves.easeOut,
//        );
//      });
//    }

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text(widget.userName),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () async {
                await loadData();
              })
        ],
      ),
      body: _buildPageBody(context),
    );
  }

  Future<bool> sendMessage() async {
    final String content = _controller.text;
    if (content.trim().length == 0) {
      return false;
    }
    final response = await MobcentClient.instance.userPmSendTo(
        uid: widget.userId,
        pmid: this._pmid,
        plid: this._plid,
        content: content);
    print(response.head.errInfo);
    if (response.noError) {
      /// 发送成功
      this._plid ??= response.body.plid;
      this._pmid ??= response.body.pmid;
      _controller.clear();

      /// 重新加载数据
      /// 处理延迟问题
      loadData();
    } else {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return new SimpleDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            children: <Widget>[Center(child: Text(response.head.errInfo))],
          );
        },
      );
    }
    ;
  }

  _buildEditerPanel(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      padding: EdgeInsets.only(top: 8, bottom: 8, left: 16),
      constraints: BoxConstraints(minHeight: 60, maxHeight: 150),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 4),
              child: TextField(
                minLines: 1,
                maxLines: 5,
                focusNode: _focusNode,
                controller: _controller,
                textInputAction: TextInputAction.send,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  hintText: "说点什么...",
                  border: new OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none),
                ),
                onSubmitted: (value) async {
                  /// 重新申请焦点,实现连续输入
                  FocusScope.of(context).requestFocus(_focusNode);
                  print("准备发送 => ${value}");
                  if (value.trim().length == 0) {
                    return;
                  }
                  await sendMessage();
                },
              ),
            ),
          ),
          Container(
            child: RawMaterialButton(
              padding: EdgeInsets.all(8),
              constraints: BoxConstraints(minWidth: 32, minHeight: 32),
              //materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onPressed: () async {
                await sendMessage();
              },
              child: Text("发送"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageBody(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: _buildMessages(context),
        ),
        _buildEditerPanel(context),
      ],
    );
  }

  Widget _buildMessages(BuildContext context) {
    final msgs = _session.msgList.reversed.toList();
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: (_) {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: ListView.builder(
                reverse: true,
                shrinkWrap: true,
                controller: _scrollController,
                itemCount: msgs.length,
                itemBuilder: (context, index) {
                  return _buildMessageItem(context, msgs[index], index);
                }),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(BuildContext context, PmMessage message, int index) {
    if (message.sender == _session.fromUid) {
      /// 来自对方的消息
      return _buildOtherMessageItem(context, message);
    } else {
      return _buildMineMessageItem(context, message);
    }
  }

  Widget _buildMineMessageItem(BuildContext context, PmMessage message) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Card(
            color: Color(0xff9eea6a),
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 100),
              child: Text(message.content),
            ),
          ),
          UserAvatarWidget(_userInfo.avatar, width: 32, height: 32),
        ],
      ),
    );
  }

  Widget _buildOtherMessageItem(BuildContext context, PmMessage message) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          UserAvatarWidget(_session.avatar, width: 32, height: 32),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width - 100),
                child: Text(message.content)),
          ),
        ],
      ),
    );
  }
}
