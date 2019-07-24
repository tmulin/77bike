import 'package:flutter/material.dart';
import 'package:qiqi_bike/views/forum_search_page.dart';

import '../core/application.dart';
import '../views/user_login_page.dart';

class ForumSearchButton extends StatelessWidget {
  const ForumSearchButton();

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: 0,
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Icon(
        Icons.search,
        color: Colors.white,
        size: 28,
      ),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          if ((ApplicationCore.session.uid ?? 0) == 0) {
            /// 登录
            return UserLoginPage();
          }
          return ForumSearchPage();
        }));
      },
    );
  }
}
