import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qiqi_bike/core/application.dart';

import 'cache_manager.dart';

class PostImageWidget extends StatelessWidget {
  final String imageUrl;

  final double width;

  final double height;

  final double borderRadius;

  const PostImageWidget(this.imageUrl,
      {Key key, this.width, this.height, this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String targetImageUrl = ApplicationCore.imageTranslate(this.imageUrl,
        cloudProcess: ApplicationCore.settings.cloudProcess > 0,
        processor: "!webp");

    return CachedNetworkImage(
        fadeInDuration: Duration.zero,
        fadeOutDuration: Duration.zero,
        cacheManager: CustomCacheManager(),
        imageUrl: targetImageUrl,
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
                "POST IMAGE imageStream ERROR => ${exception} : ${targetImageUrl}");
            CustomCacheManager().removeFile(targetImageUrl);
          }));
          final image = Image(
            image: provider,
            fit: BoxFit.cover,
          );
          return borderRadius == null
              ? image
              : ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: image,
                );
        },
        placeholder: (context, url) => Container(
            height: 150,
            child: new Icon(
              Icons.image,
              color: Colors.grey.shade200,
            )),
        errorWidget: (context, url, error) {
          print("Load POST IMAGE ERROR => $error : ${targetImageUrl}");
          return new Icon(
            Icons.image,
            color: Colors.grey.shade200,
          );
        });
  }
}
