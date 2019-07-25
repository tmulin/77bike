import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:qiqi_bike/core/application.dart';
import 'package:qiqi_bike/widgets/cache_manager.dart';

class ImageViewer extends StatefulWidget {
  final String initImage;
  final List<String> images;

  ImageViewer({@required List<String> images, String initImage})
      : initImage = translateImage(initImage),
        images = translateImages(images);

  @override
  _ImageViewerState createState() => _ImageViewerState();

  static String translateImage(String image) {
    String newImage = ApplicationCore.imageTranslate(image,
        cloudProcess: ApplicationCore.settings.cloudProcess > 0,
        processor: "!webp");
    return newImage.replaceAll(
        "/mobcent/app/runtime/images/mobcentSmallPreview", "/attachment");
  }

  static List<String> translateImages(List<String> images) =>
      images?.map((image) => translateImage(image)).toList();
}

class _ImageViewerState extends State<ImageViewer> {
  int currentPage = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    widget.images.forEach((url) {
      print("ImageViewer => ${url}");
    });

    currentPage = widget.images.indexOf(widget.initImage);
    if (currentPage < 0) currentPage = 0;
    _pageController = PageController(initialPage: currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPageBody(context),
    );
  }

  Widget _buildPageBody(BuildContext context) {
    return Stack(
      children: <Widget>[
        PhotoViewGallery.builder(
          onPageChanged: (value) {
            setState(() {
              currentPage = value;
            });
          },
          loadingChild: Container(
            color: Colors.black,
            child: Center(child: CircularProgressIndicator()),
          ),
          pageController: _pageController,
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              onTapUp: (BuildContext context, TapUpDetails details,
                  PhotoViewControllerValue controllerValue) {
                Navigator.of(context).pop();
              },
              maxScale: 1.0,
              imageProvider: CachedNetworkImageProvider(widget.images[index],
                  cacheManager: CustomCacheManager(),
                  headers: {
                    HttpHeaders.userAgentHeader:
                        "Mozilla/5.0 (iPhone; CPU iPhone OS 12_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 Appbyme"
                  }),
              initialScale: PhotoViewComputedScale.contained,
              heroTag: widget.images[index],
            );
          },
          itemCount: widget.images.length,
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _buildBottomPanel(context),
        )
      ],
    );
  }

  Widget _buildBottomPanel(BuildContext context) {
    return Container(
      height: 32,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "${currentPage + 1}/${widget.images.length}",
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}
