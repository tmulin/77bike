import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qiqi_bike/models/forum/forum_postlist.dart';
import 'package:qiqi_bike/widgets/mobcent_forum_faces.dart';

import '../../topic_page_sliver.dart';

class DemoEmbedPage extends StatefulWidget {
  @override
  _DemoEmbedPageState createState() => _DemoEmbedPageState();
}

class _DemoEmbedPageState extends State<DemoEmbedPage> {
  PostContent postContent = PostContent();
  TextStyle textStyle;
  double padding = 0;
  double fontSize = 15;
  double paraCount = 1;

  @override
  void initState() {
    super.initState();
    postContent.type = 0;
    postContent.infor = """


经常看到有人说碟刹重，我真的不知道碟刹重在哪里[mobcent_phiz=http://bbs.77bike.com/images/post/smile/qq/12.gif]

造价约5000整

这对轮组是群里白云帮扛把子的
为了让我暂停训练给他编轮组，骑游假装抽筋让我拉爆，演的真好！[ 此帖被光光在2019-06-16 10:34重新编辑 ]""";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("排版测试"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: ListView.separated(
          cacheExtent: 0,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text("PARA = ${paraCount}"),
                  Slider(
                    value: paraCount,
                    label: "$paraCount",
                    min: 1,
                    max: 200,
                    divisions: 199,
                    onChanged: (value) {
                      setState(() {
                        paraCount = value;
                      });
                    },
                  ),
                  Text("PADDING = ${padding}"),
                  Slider(
                    value: padding,
                    label: "$padding",
                    min: 0,
                    max: 50,
                    divisions: 50,
                    onChanged: (value) {
                      setState(() {
                        padding = value;
                      });
                    },
                  ),
                  Text("FONTSIZE = ${fontSize}"),
                  Slider(
                    value: fontSize,
                    label: "$fontSize",
                    min: 5,
                    max: 30,
                    divisions: 25,
                    onChanged: (value) {
                      setState(() {
                        fontSize = value;
                      });
                    },
                  ),
                ],
              );
            } else {
              final textSpan = TextSpan(
                  children: <InlineSpan>[...parseContent(postContent.infor)]);
              return Text.rich(textSpan);
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
//                  child: PostContentWidget(
//                          PostContent(
//                              type: 0, infor: "$index:${postContent.infor}"),
//                          debugLabel: "${index}"),
                child: Text.rich(textSpan),
              );
            }
          },
          separatorBuilder: (context, index) => Divider(height: 1),
          itemCount: paraCount.toInt() + 1,
        ),
      ),
    );
  }

  static List<InlineSpan> parseContent(String contentString) {
    final size = 20.0;
    List<InlineSpan> contentItems = List();
    contentString.splitMapJoin(RegExp(r"(\[.+?\])"), onMatch: (Match match) {
      final matchContent = match.group(0);
      String emojiContent;
      if (matchContent.startsWith("[mobcent_phiz=")) {
        emojiContent =
            matchContent.replaceAll("[mobcent_phiz=", "")?.replaceAll("]", "");

        final imageProvider = CachedNetworkImageProvider(
          emojiContent,
          headers: {
            HttpHeaders.userAgentHeader:
                "Mozilla/5.0 (iPhone; CPU iPhone OS 12_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 Appbyme"
          },
        );
        contentItems.add(
          WidgetSpan(
            child: Image(
                image: imageProvider,
                width: size,
                height: size,
                fit: BoxFit.fill),
          ),
        );
      } else {
        emojiContent = MobcentForumFaces.findAsset(matchContent);
        if (emojiContent != null) {
          contentItems.add(
            WidgetSpan(
              child: Image.asset(emojiContent,
                  width: size, height: size, fit: BoxFit.fill),
            ),
          );
        }
      }
      if (emojiContent == null) {
        contentItems.add(TextSpan(text: matchContent));
      }
      return "";
    }, onNonMatch: (String nonMatch) {
      contentItems.add(TextSpan(text: nonMatch));
      return "";
    });
    return contentItems;
  }
}
