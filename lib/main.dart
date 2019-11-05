import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:islington_navigation_flutter/controller/dynamic_theme.dart';
import 'package:islington_navigation_flutter/controller/utils/backdrop.dart';
import 'package:islington_navigation_flutter/controller/utils/check_authorization.dart';
import 'package:islington_navigation_flutter/controller/utils/check_routine_authorization.dart';
import 'package:islington_navigation_flutter/model/introscreen.dart';
import 'package:islington_navigation_flutter/view/credentials/login_page.dart';
import 'package:islington_navigation_flutter/view/credentials/register_page.dart';
import 'package:islington_navigation_flutter/view/drawer%20page/drawer.dart';
import 'package:islington_navigation_flutter/view/map_screen.dart';
import 'package:islington_navigation_flutter/view/overview/blocks/overview.dart';
import 'package:islington_navigation_flutter/view/overview/overview_home.dart';
import 'package:islington_navigation_flutter/view/profile/profile_page.dart';
import 'package:islington_navigation_flutter/view/routines/routine_list.dart';
import 'package:islington_navigation_flutter/view/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:fancy_on_boarding/fancy_on_boarding.dart';

void main() async {
  Brightness brightness;
  bool intro;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  brightness =
      (prefs.getBool("isDark") ?? false) ? Brightness.dark : Brightness.light;
  intro = (prefs.getBool("isIntroEnabled") ?? false) ? true : false;
  runApp(new NavigationApp(
    brightness: brightness,
    intro: intro,
  ));
}

class NavigationApp extends StatelessWidget {
  Brightness brightness;
  bool intro;
  NavigationApp({this.brightness, this.intro});

  Widget build(BuildContext context) {
    return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => new ThemeData(
              primarySwatch: Colors.red,
              platform: TargetPlatform.iOS,
              brightness: brightness,
            ),
        themedWidgetBuilder: (context, theme) {
          return new MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Virtual Navigation',
            theme: theme,
            home: intro ? OnBoardingScreen() : BackDropPage(),
            routes: <String, WidgetBuilder>{
              '/backdrop': (BuildContext context) => BackDropPage(),
              // '/mainpage': (BuildContext context) => MainPage(),
              '/mainpage': (BuildContext context) => BackDropPage(),
              '/overview': (BuildContext context) => OverviewHome(),
              '/routine': (BuildContext context) => RoutineList(),
              '/checkAuth': (BuildContext context) => CheckAuth(),
              '/profile': (BuildContext context) => ProfilePage(),
              '/login': (BuildContext context) => LoginPage(),
              '/register': (BuildContext context) => RegisterPage(),
              '/setting': (BuildContext context) => SettingsPage(),
              '/mapscreen': (BuildContext context) => MapScreen(),
              '/block-page': (BuildContext context) => CollegeOverview(),
              '/routineMain': (BuildContext context) => RoutineList(),
            },
          );
        });
  }
}

class OnBoardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FancyOnBoarding(
        pageList: onBoardingList,
        mainPageRoute: '/mainpage',
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => new _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime currentBackPressTime = DateTime.now();

  int selectedPos = 0;
  String title;
  double bottomNavBarHeight = 60;

  static bool isLoggedIn = false;
  String savedUserid = '';

  List<TabItem> tabItems = List.of([
    new TabItem(Icons.home, "Overview", Colors.blue),
    new TabItem(Icons.map, "Map", Colors.orange),
    new TabItem(Icons.list, "Routine", Colors.red),
  ]);

  CircularBottomNavigationController _navigationController;

  @override
  void initState() {
    super.initState();
    _getSaveduserid();
    _navigationController = new CircularBottomNavigationController(selectedPos);
    if (selectedPos == 0) {
      setState(() {
        title = "Overview";
      });
    } else if (selectedPos == 1) {
      setState(() {
        title = "Find Classes";
      });
    } else if (selectedPos == 2) {
      setState(() {
        title = "Routine";
      });
    } else {
      setState(() {
        title = "Overview";
      });
    }
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

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(value),
    ));
  }

  @override
  Future<bool> onWillPop() {
    return showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              title: const Text('Close the application'),
              actions: <Widget>[
                FlatButton(
                  child: const Text('YES'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
                FlatButton(
                  child: const Text('NO'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        drawer: Drawer(
          child: DrawerPage(),
        ),
        endDrawer: Drawer(
          child: CheckAuth(),
        ),
        body: Stack(
          children: <Widget>[
            Padding(
              child: bodyContainer(),
              padding: EdgeInsets.only(bottom: bottomNavBarHeight),
            ),
            Align(alignment: Alignment.bottomCenter, child: bottomNav())
          ],
        ),
      ),
    );
  }

  Widget bodyContainer() {
    if (selectedPos == 0) {
      return OverviewHome();
    } else if (selectedPos == 1) {
      return MapScreen();
    } else if (selectedPos == 2) {
      return CheckRoutineAuth();
    } else {
      return OverviewHome();
    }
  }

  Widget bottomNav() {
    return CircularBottomNavigation(
      tabItems,
      controller: _navigationController,
      barHeight: bottomNavBarHeight,
      barBackgroundColor: Colors.white,
      animationDuration: Duration(milliseconds: 300),
      selectedCallback: (int selectedPos) {
        setState(() {
          this.selectedPos = selectedPos;
          print(_navigationController.value);
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _navigationController.dispose();
  }
}