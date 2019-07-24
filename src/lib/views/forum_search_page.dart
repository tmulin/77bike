import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qiqi_bike/common/data_helper.dart';
import 'package:qiqi_bike/widgets/topic_search_delegate.dart';

class ForumSearchPage extends StatefulWidget {
  @override
  _ForumSearchPageState createState() => _ForumSearchPageState();
}

class _ForumSearchPageState extends State<ForumSearchPage> {
  TextEditingController _textController;
  FocusNode _textFocusNode;
  int currentContent = 0;

  List<String> suggestions = <String>[
    "公路车",
    "451",
    "功率计",
    "爬坡",
    "牙盘",
    "变速",
    "轮组",
    "花鼓"
  ];

  String queryString;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _textFocusNode = FocusNode();

    _textController.addListener(() {
      if (!DataHelper.isIsNullOrWhiteSpaceString(_textController.text))
        this.queryString = _textController.text;
    });
    _textFocusNode.addListener(() {
      if (_textFocusNode.hasFocus && currentContent != 0) {
        setState(() {
          currentContent = 0;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _textFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: IndexedStack(
        index: currentContent,
        children: <Widget>[
          _buildSuggestionView(context),
          _buildSearchResultView(context),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: TextField(
          autofocus: true,
          cursorColor: Colors.black,
          controller: _textController,
          focusNode: _textFocusNode,
          style: TextStyle(fontSize: 18),
          textInputAction: TextInputAction.search,
          onSubmitted: (String _) {
            setState(() {
              currentContent = 1;
            });
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "请输入关键词",
            hintStyle: TextStyle(color: Colors.white),
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            filled: true,
            prefix: Icon(
              Icons.search,
              color: Colors.grey,
            ),
            suffix: GestureDetector(
              onTap: () {
                this.currentContent = 0;
                this._textController.clear();
                setState(() {});
              },
              child: Icon(
                Icons.cancel,
                color: Colors.grey.shade500,
              ),
            ),
            fillColor: Colors.white,
            enabledBorder:
                UnderlineInputBorder(borderRadius: BorderRadius.circular(5)),
            focusedBorder:
                UnderlineInputBorder(borderRadius: BorderRadius.circular(5)),
          ),
        ),
      ),
      actions: <Widget>[
        MaterialButton(
          minWidth: 0,
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            "取消",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          onPressed: () {
            Navigator.of(context).pop(null);
          },
        )
      ],
    );
  }

  Widget _buildSuggestionView(BuildContext context) {
    return ListView.separated(
      itemCount: suggestions.length,
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          _textFocusNode?.unfocus();
          setState(() {
            _textController.text = suggestions[index];
            this.queryString = suggestions[index];
            this.currentContent = 1;
          });
        },
        title: Text(suggestions[index]),
      ),
      separatorBuilder: (context, index) => Divider(height: 0),
    );
  }

  Widget _buildSearchResultView(BuildContext context) {
    if (DataHelper.isIsNullOrWhiteSpaceString(this.queryString))
      return Container(width: 1, height: 1);
    return SearchResultListView(this.queryString);
  }
}
