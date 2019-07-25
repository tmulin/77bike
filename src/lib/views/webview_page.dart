import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String title;

  WebViewPage({this.title, @required this.url});

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  @override
  void initState() {
    super.initState();

    FlutterWebviewPlugin().onStateChanged.listen((state) {});
  }

  @override
  void dispose() {
    FlutterWebviewPlugin().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: AppBar(
        title: Text(widget.title ?? ""),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                FlutterWebviewPlugin().reload();
              })
        ],
      ),
      url: widget.url,
      scrollBar: true,
      withZoom: true,
    );
  }
}
