import 'package:flutter/material.dart';
import 'package:islington_navigation_flutter/view/profile/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckAuth extends StatefulWidget {
  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  bool isLoggedIn = false;
  String savedUserid = '';

  @override
  void initState() {
    super.initState();
    print("inside check auth init state");
    _getSaveduserid();
  }

  _getSaveduserid() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      savedUserid = preferences.getString("userid");
      print("saved user id is: " + savedUserid.toString());
      if (savedUserid != null) {
        isLoggedIn = true;
      } else {
        isLoggedIn = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn) {
      return ProfilePage(
        userId: savedUserid,
      );
    } else {
      return ProfilePage();
    }
  }
}
