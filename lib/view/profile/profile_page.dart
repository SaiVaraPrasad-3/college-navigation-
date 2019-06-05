import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:islington_navigation_flutter/view/credentials/login_page.dart';
import 'package:islington_navigation_flutter/view/profile/profile_after_login.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({this.userId});
  final String userId;

  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: widget.userId != null
            ? ProfileLoggedIn(
                userId: widget.userId,
              )
            : NotLoggedIn());
  }
}

class NotLoggedIn extends StatefulWidget {
  @override
  _NotLoggedInState createState() => _NotLoggedInState();
}

class _NotLoggedInState extends State<NotLoggedIn> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(
            CupertinoIcons.profile_circled,
            size: 160.0,
            color: Color(0xFF646464),
          ),
          CupertinoButton.filled(
              child: Text("Sign in"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (c) {
                  return LoginPage();
                }));
                // Navigator.of(context).pushReplacementNamed('/login');
              }),
        ],
      ),
    );
  }
}
