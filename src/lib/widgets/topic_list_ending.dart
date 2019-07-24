import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopicListEnding extends StatelessWidget {
  final VoidCallback onTap;
  final bool hasMore;
  final bool isLoading;

  const TopicListEnding(this.hasMore, this.isLoading, this.onTap);

  @override
  Widget build(BuildContext context) {
    if (hasMore) {
      return Container(
        padding: EdgeInsets.only(top: 16, bottom: 16),
        child: CupertinoButton(
            child: Text(isLoading ? "正在加载..." : "加载更多 ..."),
            onPressed: isLoading ? null : this.onTap ?? () {}),
      );
    } else {
      return Container(
        padding: EdgeInsets.only(top: 16, bottom: 16),
        child: Center(
            child: Text(
          "已经到最后了!",
          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18),
        )),
      );
    }
  }
}
