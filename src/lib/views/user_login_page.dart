import 'package:flutter/material.dart';
import 'package:qiqi_bike/api/mobcent_client.dart';
import 'package:qiqi_bike/core/application.dart';
import 'package:qiqi_bike/views/user_register_page.dart';

class UserLoginPage extends StatefulWidget {
  @override
  _UserLoginPageState createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  final _formKey = new GlobalKey<FormState>();
  final _loginController = new TextEditingController();
  final _passwordController = new TextEditingController();

  // final _loginOnChange = new BehaviorSubject<String>();
  final FocusNode _loginFocusNode = new FocusNode();
  final FocusNode _passwordFocusNode = new FocusNode();

  @override
  void initState() {
    super.initState();

    _loginController.text = "";
  }

  void _handleUserLogin(BuildContext context) async {
    var _form = _formKey.currentState;

    if (!_form.validate()) {
      return;
    }
    _form.save();

    var loginResponse = await MobcentClient.instance.userLogin(
        username: _loginController.value.text,
        password: _passwordController.value.text);

    if (loginResponse.noError) {
      ApplicationCore.session.update(
          uid: loginResponse.uid,
          token: loginResponse.token,
          userName: loginResponse.userName,
          secret: loginResponse.secret,
          avatar: loginResponse.avatar);
      await Navigator.of(context).maybePop();
    } else {
      _showNotifyDialog(context, loginResponse.head.errInfo);
    }
  }

  Future _showNotifyDialog(BuildContext context, String message) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("登录失败"),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("确定"),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).viewInsets.bottom;

    final account = new TextFormField(
      controller: _loginController,
      focusNode: _loginFocusNode,
      validator: (value) {
        if (value == null || value.trim().length == 0) {
          return "请输入用户名";
        }
      },
      onFieldSubmitted: (value) {
        // _loginFocusNode.unfocus();
        _passwordController.selection = TextSelection(
            baseOffset: 0, extentOffset: _passwordController.text.length);
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      },
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autofocus: false,
      style: TextStyle(letterSpacing: 2, color: Colors.white),
      decoration: new InputDecoration(
          hintText: '账号',
          hintStyle: TextStyle(color: Colors.white, letterSpacing: 2),
          prefixIcon: SizedBox(
              width: 50, child: Icon(Icons.person, color: Colors.white)),
          contentPadding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          filled: true,
          fillColor: Theme.of(context).backgroundColor,
          border: new OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
              borderSide: BorderSide.none)),
    );

    final password = new TextFormField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      validator: (value) {
        if (value == null || value.trim().length == 0) {
          return "请输入登录密码";
        }
      },
      onFieldSubmitted: (value) {
        this._handleUserLogin(context);
      },
      autofocus: false,
      obscureText: true,
      style: TextStyle(letterSpacing: 4, color: Colors.white),
      textInputAction: TextInputAction.done,
      decoration: new InputDecoration(
        hintText: '密码',
        hintStyle: TextStyle(color: Colors.white, letterSpacing: 2),
        prefixIcon:
            SizedBox(width: 50, child: Icon(Icons.lock, color: Colors.white)),
        contentPadding: new EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        filled: true,
        fillColor: Theme.of(context).backgroundColor,
        border: new OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
            borderSide: BorderSide.none),
      ),
    );

    final loginButton = Builder(
      builder: (context) => FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        onPressed: () => _handleUserLogin(context),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: new Text(
            '登录',
            style: new TextStyle(
                color: Color.fromARGB(0xff, 24, 163, 210),
                fontSize: 22,
                letterSpacing: 8),
          ),
        ),
      ),
    );

    final registerButton = FlatButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      onPressed: () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => UserRegisterPage())),
      color: Color(0xffffffff),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: new Text(
          '注册',
          style: new TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 22,
              letterSpacing: 8),
        ),
      ),
    );

    final forgetLabel = Container(
          height: 16,
        ) ??
        new FlatButton(
          onPressed: () {},
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          child: new Text(
            '忘记密码?',
            style: new TextStyle(color: Colors.white),
          ),
        );

    return Scaffold(
        appBar: AppBar(
          title: Text("登录"),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: Image.asset("assets/images/login_bg.jpg").image,
                fit: BoxFit.fill),
          ),
          child: Center(
            child: Form(
              key: _formKey,
              child: SizedBox(
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Flexible(flex: 6, child: Container()),
                    account,
                    SizedBox(height: 12),
                    password,
                    Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: forgetLabel),
                    loginButton,
                    Flexible(
                        flex: 2,
                        child: Container(
                          height: 32,
                        )),
                    if (height < 250) registerButton,
                    Flexible(flex: 2, child: Container()),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
