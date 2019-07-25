import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:qiqi_bike/core/application.dart';

class TopicImageWidget extends StatelessWidget {
  final String imageUrl;

  final double width;

  final double height;

  final double borderRadius;

  final double aspectRatio;

  final Function(String image) onTapImage;

  const TopicImageWidget(this.imageUrl,
      {Key key,
      this.width,
      this.height,
      this.borderRadius,
      this.aspectRatio,
      this.onTapImage})
      : super(key: key);

  Widget _wrapAspectRatio(Widget child) {
    return aspectRatio == null
        ? child
        : AspectRatio(
            aspectRatio: 1.0,
            child: child,
          );
  }

  Widget _wrapBorderRadius(Widget child) {
    return borderRadius == null
        ? child
        : ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: child,
          );
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) {
      return _wrapBorderRadius(_wrapAspectRatio(Container()));
    }

    final imageCache = PaintingBinding.instance.imageCache;
    print(
        "imageCache SIZE => ${imageCache.currentSize} | MEMORY ${(imageCache.currentSizeBytes / 1024.0 / 1024.0).toStringAsFixed(2)}M");

    String targetImageUrl = ApplicationCore.imageTranslate(this.imageUrl,
        cloudProcess: ApplicationCore.settings.cloudProcess > 0,
        processor: "!square300webp");

    return GestureDetector(
      onTap: () {
        if (this.onTapImage != null) this.onTapImage(targetImageUrl);
      },
      child: CachedNetworkImage(
        imageUrl: targetImageUrl,
        fadeInDuration: Duration.zero,
        fadeOutDuration: Duration.zero,
        httpHeaders: {
          HttpHeaders.userAgentHeader:
              "Mozilla/5.0 (iPhone; CPU iPhone OS 12_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 Appbyme"
        },
        imageBuilder: (context, provider) {
          var imageStream = provider.resolve(ImageConfiguration.empty);
          imageStream.addListener(
              ImageStreamListener((ImageInfo image, bool synchronousCall) {},
                  onError: (dynamic exception, StackTrace stackTrace) {
            print(
                "TOPIC imageStream ERROR => ${exception} : ${targetImageUrl}");
            DefaultCacheManager().removeFile(targetImageUrl);
          }));
          return _wrapBorderRadius(
            _wrapAspectRatio(
              Image(
                image: provider,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
        placeholder: (context, url) => _wrapBorderRadius(_wrapAspectRatio(
          Icon(
            Icons.image,
            color: Colors.grey.shade200,
          ),
        )),
        errorWidget: (context, url, error) {
          print("Load Image ERROR => $error : ${targetImageUrl}");
          return _wrapBorderRadius(
            _wrapAspectRatio(
              Icon(
                Icons.image,
                color: Colors.grey.shade200,
              ),
            ),
          );
        },
      ),
    );
  }
}
