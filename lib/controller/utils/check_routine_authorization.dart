import 'package:flutter/material.dart';
import 'package:islington_navigation_flutter/view/profile/profile_page.dart';
import 'package:islington_navigation_flutter/view/routines/routine_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckRoutineAuth extends StatefulWidget {
  @override
  _CheckRoutineAuthState createState() => _CheckRoutineAuthState();
}

class _CheckRoutineAuthState extends State<CheckRoutineAuth> {
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
      return RoutineList();
    } else {
      return ProfilePage();
    }
  }
}
