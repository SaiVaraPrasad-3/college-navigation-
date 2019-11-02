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
  String colorName;

//list of colors
  static const List<_NamedColor> listOfColors = <_NamedColor>[
    _NamedColor(Color(0xFFFFFFFF), '0xFFFFFFFF', "White"),
    _NamedColor(Color(0xFF008000), '0xFF008000', "Green"),
    _NamedColor(Color(0xFFD7C23A), '0xFFD7C23A', "Yellow"),
    _NamedColor(Color(0xFF9B1A1A), '0xFF9B1A1A', "Red"),
    _NamedColor(Color(0xFFADD8E6), '0xFFADD8E6', "Light Blue"),
    _NamedColor(Color(0xFF3B3EA6), '0xFF3B3EA6', "Dark Blue"),
    _NamedColor(Color(0xFFFFC0CB), '0xFFFFC0CB', "Pink"),
  ];

  Color _appColor = listOfColors.first.color;

  // to handle the action when color changes
  void _onColorChanged(_NamedColor value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      //storing hex value from color list in shared preference
      preferences.setString("primaryColor", value.colorIntValue);
      print(value.name + " " + value.colorIntValue);
      DynamicTheme.of(context)
          .setThemeData(ThemeData(primaryColor: value.color));
      colorName = value.name;
    });
  }

  // method to get the brightness of app
  _getBrightness() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      darkTheme = (prefs.getBool("isDark") ?? false) ? true : false;
    });
  }

  // Future<void> signOut() async {
  //   return _firebaseAuth.signOut();
  // }

  // method to check if intro page is enabled or not
  _getIntroPageOption() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      bool checkNull = preferences.getBool("isIntroEnabled");
      checkNull == null ? intro = true : intro = checkNull;
    });
  }

  // method to check if signed in or not
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

  // method to logout user
  _userLogout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("userid");
    print("User successfully logged out");
    Navigator.of(context).pushReplacementNamed('/mainpage');
  }

  // widget to change the brightness
  Widget changeBrightness() {
    return Container(
      color: darkTheme ? Colors.grey : Colors.white,
      child: ListTile(
        title: Text(
          "Dark Mode",
        ),
        trailing: CupertinoSwitch(
          activeColor: Colors.black87,
          value: darkTheme,
          onChanged: (bool value) {
            DynamicTheme.of(context)
                .setBrightness(darkTheme ? Brightness.light : Brightness.dark);
            setState(() {
              darkTheme = !darkTheme;
            });
          },
        ),
      ),
    );
  }

  Widget changeIntroScreen() {
    return Container(
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
            preferences.setBool('isIntroEnabled', intro ? false : true);
            setState(() {
              intro = !intro;
            });
          },
        ),
      ),
    );
  }

  // widget to change color of app
  Widget changeColor() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.10,
      child: Scrollbar(
          child: Padding(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _ColorsItem(listOfColors, _appColor, _onColorChanged)),
      )),
    );
  }

  //widget to logout user
  Widget logout() {
    return FlatButton(
      child: Text("Logout"),
      onPressed: () {
        _userLogout();
      },
    );
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
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              changeBrightness(),
              darkTheme
                  ? SizedBox(
                      height: 0.5,
                    )
                  : changeColor(),
              changeIntroScreen(),
              isLoggedIn ? logout() : SizedBox()
            ],
          ),
        ));
  }
}

class _NamedColor {
  const _NamedColor(this.color, this.colorIntValue, this.name);

  final Color color;
  final String colorIntValue;
  final String name;
}

class _ColorsItem extends StatelessWidget {
  const _ColorsItem(this.colors, this.selectedColor, this.onChanged);

  final List<_NamedColor> colors;
  final Color selectedColor;
  final ValueChanged<_NamedColor> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: colors.map<Widget>((_NamedColor namedColor) {
        return RawMaterialButton(
          onPressed: () {
            onChanged(namedColor);
          },
          constraints: const BoxConstraints.tightFor(
            width: 32.0,
            height: 32.0,
          ),
          fillColor: namedColor.color,
          shape: CircleBorder(
            side: BorderSide(
              color: namedColor.color == selectedColor
                  ? Colors.black
                  : const Color(0xFFD5D7DA),
              width: 2.0,
            ),
          ),
          child: Semantics(
            value: namedColor.name,
            selected: namedColor.color == selectedColor,
          ),
        );
      }).toList(),
    );
  }
}
