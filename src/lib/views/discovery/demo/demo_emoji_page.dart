import 'package:flutter/material.dart';

class DemoEmojiPage extends StatefulWidget {
  @override
  _DemoEmojiPageState createState() => _DemoEmojiPageState();
}

class _DemoEmojiPageState extends State<DemoEmojiPage> {
  double padding = 8.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Emoji")),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: ListView.separated(
          itemCount: 1000,
          cacheExtent: 0,
          itemBuilder: (context, index) {
            final imageCache = PaintingBinding.instance.imageCache;
    print(
        "imageCache SIZE => ${imageCache.currentSize} | MEMORY ${(imageCache.currentSizeBytes / 1024.0 / 1024.0).toStringAsFixed(2)}M");


            if (index == 0) {
              return Slider(
                  value: padding,
                  min: 0,
                  max: 100,
                  divisions: 100,
                  onChanged: (value) {
                    setState(() {
                      padding = value;
                    });
                  });
            }

            final textSpan = TextSpan(
              children: <InlineSpan>[
                TextSpan(
                    text:
                        """


经常看到有人说碟刹重，我真的不知道碟刹重在哪里"""),
                WidgetSpan(child: Icon(Icons.local_florist, color: Colors.red)),
                WidgetSpan(child: Image.asset("assets/smile/qq/83.gif")),
                WidgetSpan(child: Image.asset("assets/smile/qq/83.gif")),
                WidgetSpan(child: Image.asset("assets/smile/qq/83.gif")),
                WidgetSpan(child: Image.asset("assets/smile/qq/39.gif")),
                WidgetSpan(child: Image.asset("assets/smile/qq/39.gif")),
                WidgetSpan(child: Image.asset("assets/smile/qq/39.gif")),
                TextSpan(
                    text: """
造价约5000整

这对轮组是群里白云帮扛把子的
为了让我暂停训练给他编轮组，骑游假装抽筋让我拉爆，演的真好！[ 此帖被光光在2019-06-16 10:34重新编辑 ]"""),
                WidgetSpan(
                    child: Image.asset("assets/faces/mc_forum_qq_34.png")),
                // WidgetSpan(
                //     child: Image.network("http://bbs.77bike.com/images/post/smile/qq/12.gif"))
              ],
            );
            return Text.rich(textSpan);
          },
          separatorBuilder: (context, index) => Divider(height: 0),
        ),
      ),
    );
  }
}
