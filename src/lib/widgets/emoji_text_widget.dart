import 'dart:ui' as ui;
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'mobcent_forum_faces.dart';

/// https://blog.csdn.net/ZuoYueLiang/article/details/94439967
/// https://github.com/flutter/flutter/issues/35994
/// https://medium.com/@suragch/my-first-disappointment-with-flutter-5f6967ba78bf

class EmojiTextWidget extends MultiChildRenderObjectWidget {
  EmojiTextWidget(
      {Key key,
      @required this.text,
      this.debugLabel,
      this.textStyle = const TextStyle(color: Colors.black, fontSize: 18),
      this.emojiSize = 30})
      : super(key: key, children: _extractChildren(text));

  static List<Widget> _extractChildren(String text) {
    final List<Widget> result = <Widget>[];
    final items = EmojiTextWidget.parseContent(text);
    final List<RenderObject> emojis = List();

    items.forEach((item) {
      if (item.startsWith("assets")) {
        print("EmojiTextWidget::extractChildren => ${item}");
        result.add(Image.asset(
          item,
          fit: BoxFit.fill,
        ));
      } else if (item.startsWith("http://") && item.contains("smile/qq")) {
        result.add(CachedNetworkImage(
          imageUrl: item,
          fit: BoxFit.fill,
        ));
        // result.add(Image.network(item,fit: BoxFit.fill,));
      }
    });

    return result;
  }

  final String text;
  final String debugLabel;
  final double emojiSize;
  final TextStyle textStyle;

  @override
  EmojiTextRenderObject createRenderObject(BuildContext context) {
    // print("EmojiTextWidget::createRenderObject => ${debugLabel}");
    return EmojiTextRenderObject(
        text: text,
        textStyle: textStyle,
        emojiSize: emojiSize,
        debugLabel: debugLabel);
  }

  @override
  void updateRenderObject(
      BuildContext context, EmojiTextRenderObject renderObject) {
    // print("EmojiTextWidget::updateRenderObject => ${renderObject.debugLabel}");
    renderObject
      ..textStyle = this.textStyle.getTextStyle()
      ..emojiSize = emojiSize;
  }

  @override
  void didUnmountRenderObject(covariant EmojiTextRenderObject renderObject) {
    // print(
    //    "EmojiTextWidget::didUnmountRenderObject => ${renderObject.debugLabel}");
  }

  static List<String> parseContent(String contentString) {
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

class EmojiTextRenderObject extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, EmojiParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, EmojiParentData> {
  final String text;
  final String debugLabel;

  EmojiTextRenderObject(
      {List<RenderBox> children,
      @required this.text,
      TextStyle textStyle = const TextStyle(fontSize: 16),
      double emojiSize = 20,
      this.debugLabel})
      : assert(textStyle != null),
        assert(emojiSize != null),
        _textStyle = textStyle.getTextStyle(),
        _emojiSize = emojiSize {
    addAll(children);
  }

  ui.TextStyle _textStyle;

  ui.TextStyle get textStyle => _textStyle;

  set textStyle(ui.TextStyle value) {
    _textStyle = value;
    _paragraph = null;
    markNeedsLayout();
  }

  double _emojiSize = 20;

  double get emojiSize => _emojiSize;

  set emojiSize(double value) {
    _emojiSize = value;
    _paragraph = null;
    markNeedsLayout();
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

  Paragraph _paragraph;

  @override
  void performLayout() {
    if (_paragraph == null) {
      final textStyle = _textStyle;
      final paragraphStyle = ui.ParagraphStyle(
        textDirection: TextDirection.ltr,
      );
      final paragraphBuilder = ui.ParagraphBuilder(paragraphStyle)
        ..pushStyle(textStyle);

      final items = EmojiTextWidget.parseContent(text);

      items.forEach((item) {
        if (item.startsWith("assets")) {
          return paragraphBuilder.addPlaceholder(
              emojiSize, emojiSize, PlaceholderAlignment.middle);
        } else if (item.startsWith("http://") && item.contains("smile/qq")) {
          paragraphBuilder.addPlaceholder(
              emojiSize, emojiSize, PlaceholderAlignment.middle);
        } else {
          return paragraphBuilder.addText(item);
        }
      });
      _paragraph = paragraphBuilder.build();
    }

    final paragraphConstraints =
        ui.ParagraphConstraints(width: constraints.maxWidth);
    _paragraph.layout(paragraphConstraints);

    RenderBox child = firstChild;
    while (child != null) {
      child.layout(
          BoxConstraints(
            minWidth: emojiSize,
            minHeight: emojiSize,
            maxWidth: emojiSize, //constraints.maxWidth,
            maxHeight: emojiSize,
          ),
          parentUsesSize: true);
      child = childAfter(child);
    }

    /// 设置widiget的大小
    size = constraints
        .tighten(height: _paragraph.height, width: _paragraph.width)
        .smallest;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);

    context.canvas.drawParagraph(_paragraph, offset);

    final List<RenderBox> children = getChildrenAsList();
    final List<ui.TextBox> boxes = _paragraph.getBoxesForPlaceholders();
    for (var placeholderIndex = 0;
        placeholderIndex < boxes.length;
        placeholderIndex++) {
      var box = boxes[placeholderIndex];

      context.paintChild(
          children[placeholderIndex], box.toRect().topLeft + offset);
    }
  }
}

// TextParentData

class EmojiParentData extends ContainerBoxParentData<RenderBox> {
  String label;
  double width;
  double height;

  @override
  void detach() {
    super.detach();
  }

  Rect get content => Rect.fromLTWH(
        offset.dx,
        offset.dy,
        width,
        height,
      );
}
