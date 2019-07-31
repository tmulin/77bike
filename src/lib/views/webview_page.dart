import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String title;
  final bool fixTitle;

  WebViewPage({this.title, @required this.url, this.fixTitle = false});

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  String _title;

  Future<void> getDocumentTitle() async {
    String script = 'window.document.title';
    var title = await FlutterWebviewPlugin().evalJavascript(script);
    if (title != null && title.length > 0) {
      setState(() {
        _title = title;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    FlutterWebviewPlugin().onStateChanged.listen((state) {
      print("STATE => ${state.type}");
      if (state.type == WebViewState.finishLoad) {
        /// 加载完成,获取标题
        getDocumentTitle();
      }
    });
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
        title: Text(widget.fixTitle
            ? widget.title
            : _title ?? widget.title ?? widget.url),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.open_in_new),
            onPressed: () async {
              if (await canLaunch(widget.url)) {
                await launch(widget.url);
              }
            },
          )
        ],
      ),
      url: widget.url,
      scrollBar: true,
      withZoom: true,
    );
  }
}
