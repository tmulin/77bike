import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo/photo.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:qiqi_bike/api/mobcent_client.dart';
import 'package:qiqi_bike/common/data_helper.dart';
import 'package:qiqi_bike/models/forum/forum_sendattachmentex.dart' as att;
import 'package:qiqi_bike/models/user/user_albumlist.dart';

import '../topic_editor_page.dart';

class UserAlbumsPage extends StatefulWidget {
  final int userId;

  UserAlbumsPage({@required this.userId});

  @override
  _UserAlbumsPageState createState() => _UserAlbumsPageState();
}

class _UserAlbumsPageState extends State<UserAlbumsPage> {
  List<UserAlbum> _albums = [];

  @override
  void initState() {
    super.initState();

    MobcentClient.instance.userListAlbum(widget.userId).then((response) {
      if (response.noError) {
        setState(() {
          _albums = response.list;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: AppBar(
        title: Text("我的相册"),
      ),
      body: _buildPageBody(context),
    );
  }

  Widget _buildPageBody(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 0.8,
      children: [
        ...this._albums.map((album) => _buildAlbumView(context, album))
      ],
    );
  }

  Widget _buildAlbumView(BuildContext context, UserAlbum album) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AlbumPage(album)));
            },
            child: Container(
              padding: EdgeInsets.all(16),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  album.thumb_pic,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(child: Center(child: Text(album.title))),
        ],
      ),
    );
  }
}

class AlbumPage extends StatefulWidget {
  final UserAlbum album;

  AlbumPage(this.album);

  @override
  _AlbumPageState createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  List<UserPhoto> _photos = [];

  void _loadData() {
    MobcentClient.instance
        .userListPhotosInAlbum(widget.album.user_id, widget.album.album_id)
        .then((response) {
      if (response.noError) {
        setState(() {
          _photos = response.list;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this._loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: AppBar(
        title: Text(widget.album.title),
        actions: <Widget>[
          RawMaterialButton(
              child: Text("上传",
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              constraints: BoxConstraints(minWidth: 60),
              onPressed: () {
                Navigator.of(context)
                    .push<bool>(MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => AlbumUploadPage(widget.album)))
                    .then((result) {
                  if (result != null && result) {
                    /// TODO: 刷新
                    this._loadData();
                  }
                });
              })
        ],
      ),
      body: _buildPageBody(context),
    );
  }

  Widget _buildPageBody(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 0.8,
      children: <Widget>[
        ...this._photos.map((photo) => _buildPhotoView(context, photo))
      ],
    );
  }

  Widget _buildPhotoView(BuildContext context, UserPhoto photo) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.all(4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () async {},
            child: Container(
              padding: EdgeInsets.all(8),
              child: AspectRatio(
                aspectRatio: 1,
                child: CachedNetworkImage(
                  imageUrl: photo.thumb_pic,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
              child: Center(
                  child:
                      Text(DataHelper.toDateString(photo.release_date_value)))),
        ],
      ),
    );
  }
}

class AlbumUploadPage extends StatefulWidget {
  final UserAlbum album;

  AlbumUploadPage(this.album);

  @override
  _AlbumUploadPageState createState() => _AlbumUploadPageState();
}

class _AlbumUploadPageState extends State<AlbumUploadPage> {
  List<AssetEntity> _attachments = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: AppBar(
        title: Text(widget.album.title),
        actions: <Widget>[
          Builder(builder: (context) => _buildUploadButton(context))
        ],
      ),
      body: _buildPageBody(context),
    );
  }

  Widget _buildPageBody(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 8, bottom: 8),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        children: <Widget>[
          ..._buildImagesGalerry(context),
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

  List<Widget> _buildImagesGalerry(BuildContext context,
      {double imageSize = 128}) {
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
        maxSelected: 9 - _attachments.length);

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

  _handleUploadPhotos(BuildContext context) async {
    final arguments = att.SendAttachmentAction.buildAlbumRequest(
        albumId: "${widget.album.album_id}");

    final attachments = List<File>();
    for (var asset in _attachments) {
      attachments.add(await asset.file);
    }
    final attachmentResponse = await MobcentClient.instance
        .sendAttactment(arguments, attachments, onSendProgress: (count, total) {
      print(
          "正在上传 ${count}/${total} => ${(count.toDouble() * 100 / total).toStringAsFixed(2)}% ...");
    });
    print(
        "照片上传结果 => ${att.SendAttachmentResponseSerializer().toMap(attachmentResponse)}");

    Scaffold.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.grey.shade200,
        content: Text(
          attachmentResponse.head.errInfo,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18,
              color: attachmentResponse.noError
                  ? Theme.of(context).primaryColorDark
                  : Colors.red),
        )));

    if (attachmentResponse.noError) {
      Future.delayed(Duration(milliseconds: 2000)).then((value) {
        Navigator.of(context).pop<bool>(true);
      });
    }
  }

  _buildUploadButton(BuildContext context) {
    final bool hasAttachments = this._attachments.length == 0;
    final String label =
        hasAttachments ? "上传" : "上传(${this._attachments.length})";
    return RawMaterialButton(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(label, style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
      constraints: BoxConstraints(minWidth: 60),
      onPressed: hasAttachments
          ? null
          : () async {
              await _handleUploadPhotos(context);
            },
    );
  }
}
