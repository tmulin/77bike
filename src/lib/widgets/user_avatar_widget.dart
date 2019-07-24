import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:qiqi_bike/core/application.dart';

import 'cache_manager.dart';

class UserAvatarWidget extends StatelessWidget {
  final String imageUrl;

  final double width;

  final double height;

  final double borderRadius;

  final VoidCallback onTap;

  const UserAvatarWidget(this.imageUrl,
      {Key key,
      this.width = 56.0,
      this.height = 56.0,
      this.borderRadius = 8.0,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String targetImageUrl = ApplicationCore.imageTranslate(this.imageUrl,
        cloudProcess: ApplicationCore.settings.cloudProcess > 0,
        processor: "!webp");

    return CachedNetworkImage(
        cacheManager: CustomCacheManager(),
        fadeInDuration: Duration.zero,
        fadeOutDuration: Duration.zero,
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
                "AVATAR imageStream ERROR => ${exception} : ${targetImageUrl}");
            DefaultCacheManager().removeFile(targetImageUrl);
          }));
          return ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Container(
              width: this.width,
              height: this.height,
              child: Image(
                image: provider,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
        placeholder: (context, url) => Container(
            width: this.width,
            height: this.height,
            child: new Icon(
              Icons.account_box,
              color: Colors.grey.shade200,
            )),
        errorWidget: (context, url, error) {
          print("Load Avatar ERROR => $error : ${targetImageUrl}");
          return new Icon(
            Icons.account_box,
            color: Colors.grey.shade200,
          );
        });
  }
}
