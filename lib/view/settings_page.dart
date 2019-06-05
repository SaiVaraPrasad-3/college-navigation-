import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:islington_navigation_flutter/controller/dynamic_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool darkTheme = false;
  bool intro = true;
  bool isLoggedIn = false;
  String savedUserid = '';

  _getBrightness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      darkTheme = (prefs.getBool("isDark") ?? false) ? true : false;
    });
  }

  _getIntroPageOption() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      bool checkNull = preferences.getBool("isIntroEnabled");
      checkNull == null ? intro = true : intro = checkNull;
    });
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

  _userLogout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("userid");
    print("User successfully logged out");
    Navigator.of(context).pushReplacementNamed('/mainpage');
  }

  @override
  void initState() {
    super.initState();
    _getBrightness();
    _getSaveduserid();
    _getIntroPageOption();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              color: darkTheme ? Colors.grey : Colors.white,
              child: ListTile(
                title: Text(
                  "Dark Mode",
                ),
                trailing: CupertinoSwitch(
                  activeColor: Colors.black87,
                  value: darkTheme,
                  onChanged: (bool value) {
                    DynamicTheme.of(context).setBrightness(
                        darkTheme ? Brightness.light : Brightness.dark);
                    setState(() {
                      darkTheme = !darkTheme;
                    });
                  },
                ),
              ),
            ),
            Container(
              color: darkTheme ? Colors.grey : Colors.white,
              child: ListTile(
                title: Text(
                  "Intro Screen",
                ),
                trailing: CupertinoSwitch(
                  activeColor: Colors.black87,
                  value: intro,
                  onChanged: (bool value) async {
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    preferences.setBool(
                        'isIntroEnabled', intro ? false : true);
                    setState(() {
                      intro = !intro;
                    });
                  },
                ),
              ),
            ),
            isLoggedIn
                ? FlatButton(
                    child: Text("Logout"),
                    onPressed: () {
                      _userLogout();
                    },
                  )
                : SizedBox()
          ],
        ));
  }
}
