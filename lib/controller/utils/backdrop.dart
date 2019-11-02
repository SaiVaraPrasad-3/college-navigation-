import 'package:flutter/material.dart';
import 'package:flutter_backdrop/flutter_backdrop.dart';
import 'package:islington_navigation_flutter/controller/utils/check_routine_authorization.dart';
import 'package:islington_navigation_flutter/view/credentials/login_home.dart';
import 'package:islington_navigation_flutter/view/credentials/login_page.dart';
import 'package:islington_navigation_flutter/view/map_screen.dart';
import 'package:islington_navigation_flutter/view/overview/overview_home.dart';
import 'package:islington_navigation_flutter/view/settings_page.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool _toggleFrontLayer = false;

class BackDropPage extends StatefulWidget {
  @override
  _BackDropPageState createState() => _BackDropPageState();
}

/// Implementation of Backdrop Widget starts here.

class _BackDropPageState extends State<BackDropPage> {
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: FrontPanelModel(FrontPanels.homePanel),
      child: ScopedModelDescendant<FrontPanelModel>(
        builder: (context, _, model) => Backdrop(
          appBarAnimatedLeadingMenuIcon: AnimatedIcons.close_menu,
          appBarTitle: Text('Navigation'),
          backLayer: BackPanel(),
          toggleFrontLayer: _toggleFrontLayer,
          frontLayer: model.activePanel,
          // frontHeader: model.panelTitle(context),
          frontHeaderHeight: 10.0,
          titleVisibleOnPanelClosed: true,
          shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          )),
        ),
      ),
    );
  }
}

/// Creation of Model Class to be used for changing frontLayer
/// as well as on clicking of any option on backLayer

enum FrontPanels {
  homePanel,
  mapPanel,
  routinePanel,
  profilePanel,
  settingsPanel,
  panelFour
}

class FrontPanelModel extends Model {
  FrontPanels _activePanel;

  FrontPanelModel(this._activePanel);

  FrontPanels get activePanelType => _activePanel;

  Widget panelTitle(BuildContext context) {
    return Container(
      child: Center(
        child: _activePanel == FrontPanels.homePanel
            ? Text('Home')
            : _activePanel == FrontPanels.mapPanel
                ? Text('Map')
                : _activePanel == FrontPanels.routinePanel
                    ? Text("Routine")
                    : _activePanel == FrontPanels.profilePanel
                        ? Text('Profile')
                        : _activePanel == FrontPanels.settingsPanel
                            ? Text('Settings')
                            : Text('Panel Four'),
      ),
    );
  }

  Widget get activePanel => _activePanel == FrontPanels.homePanel
      ? OverviewHome()
      : _activePanel == FrontPanels.mapPanel
          ? MapScreen()
          : _activePanel == FrontPanels.routinePanel
              ? CheckRoutineAuth()
              : _activePanel == FrontPanels.profilePanel
                  ? LoginHome()
                  : _activePanel == FrontPanels.settingsPanel
                      ? SettingsPage()
                      : PanelFour();

  void activate(FrontPanels panel) {
    _activePanel = panel;
    notifyListeners();
  }
}

class PanelFour extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          'Panel Four',
          style: TextStyle(fontSize: 42.0),
        ),
      ),
    );
  }
}

class BackPanel extends StatefulWidget {
  @override
  _BackPanelState createState() => _BackPanelState();
}

class _BackPanelState extends State<BackPanel> {
  bool isDark = false;

  void getBrightness() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isDark = (preferences.getBool("isDark") ?? false) ? true : false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBrightness();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Theme.of(context).primaryColor,
      child: Container(
        margin: EdgeInsets.only(top: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ScopedModelDescendant<FrontPanelModel>(
                rebuildOnChange: false,
                builder: (context, _, model) {
                  return ListTile(
                    title: Text("College Overview",
                        style: TextStyle(color: Colors.white, fontSize: 20.0)),
                    leading: Icon(
                      Icons.dashboard,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    onTap: () {
                      model.activate(FrontPanels.homePanel);
                      _toggleFrontLayer = true;
                    },
                  );
                },
              ),
              ScopedModelDescendant<FrontPanelModel>(
                rebuildOnChange: false,
                builder: (context, _, model) {
                  return ListTile(
                    title: Text("Map Screen",
                        style: TextStyle(color: Colors.white, fontSize: 20.0)),
                    leading: Icon(
                      Icons.map,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    onTap: () {
                      model.activate(FrontPanels.mapPanel);
                      _toggleFrontLayer = true;
                    },
                  );
                },
              ),
              ScopedModelDescendant<FrontPanelModel>(
                rebuildOnChange: false,
                builder: (context, _, model) {
                  return ListTile(
                    title: Text("Routine",
                        style: TextStyle(color: Colors.white, fontSize: 20.0)),
                    leading: Icon(
                      Icons.map,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    onTap: () {
                      model.activate(FrontPanels.routinePanel);
                      _toggleFrontLayer = true;
                    },
                  );
                },
              ),
              ScopedModelDescendant<FrontPanelModel>(
                rebuildOnChange: false,
                builder: (context, _, model) {
                  return ListTile(
                    title: Text("Profile",
                        style: TextStyle(color: Colors.white, fontSize: 20.0)),
                    leading: Icon(
                      Icons.person,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    onTap: () {
                      model.activate(FrontPanels.profilePanel);
                      _toggleFrontLayer = true;
                    },
                  );
                },
              ),
              ScopedModelDescendant<FrontPanelModel>(
                rebuildOnChange: false,
                builder: (context, _, model) {
                  return ListTile(
                    title: Text("Settings",
                        style: TextStyle(color: Colors.white, fontSize: 20.0)),
                    leading: Icon(
                      Icons.settings,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    onTap: () {
                      model.activate(FrontPanels.settingsPanel);
                      _toggleFrontLayer = true;
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
