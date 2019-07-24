import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:qiqi_bike/widgets/mobcent_forum_faces.dart';

/// https://blog.csdn.net/ZuoYueLiang/article/details/94439967
/// https://github.com/flutter/flutter/issues/35994
/// https://medium.com/@suragch/my-first-disappointment-with-flutter-5f6967ba78bf
class EmojiTextWidget extends MultiChildRenderObjectWidget {
  final String text;

  EmojiTextWidget({Key key, this.text})
      : super(key: key, children: <Widget>[]) {
    final items = parseContent(text);

    print("EmojiTextWidget => ${items.length} ITEMS ...");
    children
        .add(Text(text, style: TextStyle(color: Colors.black, fontSize: 16)));

    children.addAll(items.map((item) {
      print("EmojiTextWidget => ITEM ${item} ...");
      if (item.startsWith("assets")) {
        return Image.asset(item, width: 20, height: 20);
      }
      return Text(
        item.trim(),
        softWrap: true,
        style: TextStyle(color: Colors.red, fontSize: 16),
      );
    }));
  }

  @override
  EmojiRenderObject createRenderObject(BuildContext context) {
    print("EmojiTextWidget::createRenderObject ...");
    return EmojiRenderObject(text: text);
  }

  @override
  void updateRenderObject(
      BuildContext context, EmojiRenderObject renderObject) {
    super.updateRenderObject(context, renderObject);
    print("EmojiTextWidget::updateRenderObject ...");
  }

  static List<String> parseContent(String contentString) {
    final size = 20.0;
    List<String> contentItems = List();
    contentString.splitMapJoin(RegExp(r"(\[.+?\])"), onMatch: (Match match) {
      final matchContent = match.group(0);
      String emojiContent;
      if (matchContent.startsWith("[mobcent_phiz=")) {
        emojiContent =
            matchContent.replaceAll("[mobcent_phiz=", "")?.replaceAll("]", "");
        contentItems.add(emojiContent);
      } else {
        emojiContent = MobcentForumFaces.findAsset(matchContent);
        if (emojiContent != null) {
          contentItems.add(emojiContent);
        }
      }
      if (emojiContent == null) {
        contentItems.add(matchContent);
      }
      return "";
    }, onNonMatch: (String nonMatch) {
      contentItems.add(nonMatch);
      return "";
    });
    return contentItems;
  }
}

class EmojiRenderObject extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, EmojiParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, EmojiParentData> {
  final String text;
  ui.Image _image1;
  ui.Image _image2;

  EmojiRenderObject({List<RenderBox> children, this.text}) {
    addAll(children);
    print(
        "EmojiRenderObject::EmojiRenderObject => CHILDREN : ${children?.length}...");

    getImage("assets/faces/mc_forum_face198.png").then((image) {
      print("image => ${image.toString()}");
      this._image1 = image;
    });
    getImage("assets/smile/qq/83.gif").then((image) {
      print("image => ${image.toString()}");
      this._image2 = image;
    });
  }

  static int label = 0;

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! EmojiParentData) {
      child.parentData = EmojiParentData()
        ..label = "EmojiParentData@${label++}";
      print("EmojiRenderObject::setupParentData => ${DateTime.now()}");
    }
  }

  @override
  void performLayout() {
    if (childCount == 0) {
      size = constraints.smallest;
      return;
    }
    print("RenderBox::performLayout => ${childCount}");
    print("RenderBox::performLayout::constraints => ${constraints}");

    double width = 0;
    double height = 0;
    int index = 0;
    RenderBox child = firstChild;
    while (child != null) {
      final EmojiParentData childParentData = child.parentData;

      child.layout(BoxConstraints(maxWidth: constraints.maxWidth),
          parentUsesSize: true);

      WidgetSpan widgetSpan;
      var childSize = child.size;

      childParentData.offset = Offset(0, height);
      childParentData.width = childSize.width;
      childParentData.height = childSize.height;

      height += childSize.height;
      width = childSize.width;

      print(
          "${child.runtimeType.toString()}@RenderBox::performLayout::child[${index++}] ${childParentData.label} => SIZE ${childSize} , OFFSET ${childParentData.offset}");

      //TextPainter()

      child = childParentData.nextSibling;
    }

    size = constraints
        .tighten(
          height: height,
          width: width,
        )
        .smallest;
    print("RenderBox::performLayout::done => ${size}");
  }

  static Future<ui.Image> getImage(String asset) async {
    ByteData data = await rootBundle.load(asset);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    FrameInfo fi = await codec.getNextFrame();
    return fi.image;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    print("RenderBox::paint => ${offset}");

    /// demo begin
    if (false) {
      final textStyle = ui.TextStyle(
        color: Colors.black,
        fontSize: 16,
      );
      final paragraphStyle = ui.ParagraphStyle(
        textDirection: TextDirection.ltr,
      );
      final paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
        ..pushStyle(textStyle)
        ..addText(text);
      final constraints = ui.ParagraphConstraints(
          width: (firstChild.parentData as EmojiParentData).width);
      final paragraph = paragraphBuilder.build();
      paragraph.layout(constraints);
      final painter = new Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.stroke;
      final painter2 = new Paint()..color = Colors.pink;
      int index = 0;
      paragraph.getBoxesForRange(0, this.text.length - 1).forEach((box) {
        /// 获取字符位置
        var pos = paragraph.getPositionForOffset(box.toRect().centerLeft);
        print(
            "EmojiTextWidget::Paragraph => BOX = ${box} || POS => ${pos.toString()}...");

        context.canvas.drawRect(box.toRect().shift(offset), painter);
        context.canvas.drawLine(box.toRect().shift(offset).topLeft,
            box.toRect().shift(offset).bottomLeft, painter2);
      });
//    context.canvas.drawColor(Colors.deepPurple, BlendMode.dstATop);
//    context.canvas.drawParagraph(paragraph, offset.translate(0, 150));
    }

    /// demo end
    if (true) {
      final textStyle = ui.TextStyle(
        color: Colors.black,
        fontSize: 16,
      );
      final paragraphStyle = ui.ParagraphStyle(
        textDirection: TextDirection.ltr,
      );
      final paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
        ..pushStyle(textStyle);

      final children = getChildrenAsList();
      final items = EmojiTextWidget.parseContent(text);
      final List<RenderObject> emojis = List();

      // paragraphBuilder.pushStyle(ui.TextStyle(color: Colors.red, fontSize: 20));

      items.forEach((item) {
        if (item.startsWith("assets")) {
          // emojis.add(WidgetSpan(child: Image.asset(item)));
          return paragraphBuilder.addPlaceholder(
              20, 20, PlaceholderAlignment.top);
        }
        return paragraphBuilder.addText(item);
      });

      final constraints = ui.ParagraphConstraints(
          width: (firstChild.parentData as EmojiParentData).width);
      final paragraph = paragraphBuilder.build();

      paragraph.layout(constraints);
      final painter = new Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.fill;
      final painter2 = new Paint()..color = Colors.yellow;
      int index = 0;
      paragraph.getBoxesForRange(0, this.text.length - 1).forEach((box) {
        /// 获取字符位置
        var pos = paragraph.getPositionForOffset(box.toRect().centerLeft);
        print(
            "EmojiTextWidget::Paragraph => BOX = ${box} || POS => ${pos.toString()}...");

        context.canvas.drawRect(box.toRect().shift(offset), painter);
        context.canvas.drawLine(box.toRect().shift(offset).topLeft,
            box.toRect().shift(offset).bottomLeft, painter2..strokeWidth = 2);
      });

      context.canvas.drawColor(Colors.deepPurple, BlendMode.dstATop);

      /// 输出文本内容
      context.canvas.drawParagraph(paragraph, offset.translate(0, 150));

      for (var i = 0; i < paragraph.getBoxesForPlaceholders().length; i++) {
        var box = paragraph.getBoxesForPlaceholders()[i];
        print("EmojiTextWidget::PlaceHolder[${i}] => ${box}");
        //context.paintChild(emojis[i], box.toRect().topLeft + offset);
//        context.canvas.drawRRect(
//            RRect.fromRectAndRadius(
//                box.toRect().translate(offset.dx, offset.dy + 150),
//                Radius.circular(8)),
//            new Paint()..color = Colors.pink);
        context.canvas.drawRect(
            box.toRect().translate(offset.dx, offset.dy + 150),
            new Paint()..color = Colors.pink);

        final image = _image2;

        if (image != null) {
          final sourceRect = Rect.fromLTRB(
              0, 0, image.width.toDouble(), image.height.toDouble());
          final targetRect = box.toRect().translate(offset.dx, offset.dy + 150);

          print(
              "EmojiTextWidget::PlaceHolder[${i}] => IMAGE ${image.width} x ${image.height} @ ${targetRect}");

          context.canvas
              .drawImageRect(image, sourceRect, targetRect, new Paint());
        }
      }
    }

    int index = 0;
    final children = getChildrenAsList();

    for (index = 0; index < childCount; index++) {
      final child = children[index];

      print(
          "[$index] => ${child.runtimeType.toString()} |  ${child.parentData.runtimeType.toString()}");

      final EmojiParentData childParentData = child.parentData;

      print(
          "RenderBox::paint::child[${index}] ${childParentData.label} => ${childParentData.offset}");

      context.paintChild(child, childParentData.offset + offset);
      break;
    }
  }

  @override
  void debugPaint(PaintingContext context, Offset offset) {
    super.debugPaint(context, offset);
  }

  @override
  void paintLow(Canvas canvas, Size size) {
    final textStyle = ui.TextStyle(
      color: Colors.black,
      fontSize: 16,
    );
    final paragraphStyle = ui.ParagraphStyle(
      textDirection: TextDirection.ltr,
    );
    final paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle)
      ..addText('Hello, world.');
    final constraints = ui.ParagraphConstraints(width: 300);
    final paragraph = paragraphBuilder.build();
    paragraph.layout(constraints);

    final offset = Offset(50, 100);
    canvas.drawParagraph(paragraph, offset);
  }

  @override
  void paintHigh(Canvas canvas, Size size) {
    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: 30,
    );
    final textSpan = TextSpan(
      text: 'Hello, world.',
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    final offset = Offset(50, 100);
    textPainter.paint(canvas, offset);
  }
}

// TextParentData

class EmojiParentData extends ContainerBoxParentData<RenderBox> {
  String label;
  double width;
  double height;

  Rect get content => Rect.fromLTWH(
        offset.dx,
        offset.dy,
        width,
        height,
      );
}
