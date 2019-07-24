import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:qiqi_bike/views/discovery/demo/emoji_text_widget.dart' as demo;
import 'package:qiqi_bike/widgets/emoji_text_widget.dart' as ui;
import 'package:qiqi_bike/widgets/post_image_widget.dart';

const String infor1 =
    "\r\n\r\n\r\n经常看到有人说碟刹重，我真的不知道碟刹重在哪里[mobcent_phiz=http://bbs.77bike.com/images/post/smile/qq/12.gif]\r\n\r\n造价约5000整\r\n\r\n这对轮组是群里白云帮扛把子的\r\n为了让我暂停训练给他编轮组，骑游假装抽筋让我拉爆，演的真好！[ 此帖被光光在2019-06-16 10:34重新编辑 ]";
const String infor =
    "经常看到有人说碟刹重，我真的不知道碟刹重在哪里[mobcent_phiz=http://bbs.77bike.com/images/post/smile/qq/12.gif]造价约5000整这对轮组是群里白云帮扛把子的为了让我暂停训练给他编轮组，骑游假装抽筋让我拉爆，演的真好！[ 此帖被光光在2019-06-16 10:34重新编辑 ]";

class DemoEmojiWidgetPage extends StatefulWidget {
  @override
  _DemoEmojiWidgetPageState createState() => _DemoEmojiWidgetPageState();
}

class _DemoEmojiWidgetPageState extends State<DemoEmojiWidgetPage> {
  TextStyle textStyle;
  bool demoWidget = false;
  double padding = 0;
  double fontSize = 18;
  double paraCount = 1;
  double emojiSize = 30;

  
  String postContent =
      "自定义排版[嘻嘻]自定义排版[嘻嘻][嘻嘻]自定义排版自定义排版[嘻嘻][嘻嘻]自定义排版自定义排版自定义排版自定义排版自定义排版自定义排版[嘿嘿]自定义排版自定义排版自定义排版[mobcent_phiz=http://bbs.77bike.com/images/post/smile/qq/12.gif]自定义排版自定义排版自定义排版。";

  String postContent1;

  @override
  Widget build(BuildContext context) {
    postContent =
        "\r\n\r\n\r\n经常看到有人说碟刹重，我真的不知道碟刹重在哪里[mobcent_phiz=http://bbs.77bike.com/images/post/smile/qq/12.gif]造价约5000整这对轮组是群里白云帮扛把子的为了让我暂停训练给他编轮组，骑游假装抽筋让我拉爆，演的真好！[ 此帖被光光在2019-06-16 10:34重新编辑 ]";

    postContent1 =
      "\r\n\r\n\r\n自定义排版[嘻嘻]自定义排版[嘻嘻][嘻嘻]自定义排版自定义排版[嘻嘻][嘻嘻]自定义排版自定义排版自定义排版自定义排版自定义排版自定义排版[嘿嘿]自定义排版自定义排版自定义排版[mobcent_phiz=http://bbs.77bike.com/images/post/smile/qq/12.gif]自定义排版自定义排版自定义排版。";


    return Scaffold(
      appBar: AppBar(
        title: Text("自定义排版"),
      ),
      body: _buildPageBody(context),
    );
  }

  static int _loop = 0;

  _buildPageBody(BuildContext context) {
    _loop++;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: ListView.separated(
        cacheExtent: 0,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text("段落数 = ${paraCount.toStringAsFixed(0)}"),
                Slider(
                  value: paraCount,
                  label: "$paraCount",
                  min: 1,
                  max: 1000,
                  divisions: 999,
                  onChanged: (value) {
                    setState(() {
                      paraCount = value;
                    });
                  },
                ),
                Text("内边距 = ${padding.toStringAsFixed(0)}"),
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
                Text("字号 = ${fontSize.toStringAsFixed(0)}"),
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
                Text("表情大小 = ${emojiSize.toStringAsFixed(0)}"),
                Slider(
                  value: emojiSize,
                  label: "$emojiSize",
                  min: 20,
                  max: 100,
                  divisions: 80,
                  onChanged: (value) {
                    setState(() {
                      emojiSize = value;
                    });
                  },
                ),
                SwitchListTile(
                    value: demoWidget,
                    title: Text("DEMO组件"),
                    onChanged: (value) {
                      setState(() {
                        demoWidget = value;
                      });
                    })
              ],
            );
          } else {
            return Column(
              children: <Widget>[
                Container(
                  color: Colors.lightGreen,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  padding: EdgeInsets.all(8),
                  // height: 300,
                  child: demoWidget
                      ? demo.EmojiTextWidget(text: postContent)
                      : ui.EmojiTextWidget(
                          text: postContent,
                          emojiSize: emojiSize,
                          textStyle:
                              TextStyle(fontSize: fontSize, color: Colors.red),
                          debugLabel: "DEMO-${index}@${_loop}",
                        ),
                )
              ],
            );
          }
        },
        separatorBuilder: (context, index) => Divider(height: 1),
        itemCount: paraCount.toInt() + 1,
      ),
    );
  }
}
