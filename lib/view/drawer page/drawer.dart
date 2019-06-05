import 'package:flutter/material.dart';
import 'package:islington_navigation_flutter/view/settings_page.dart';

class DrawerPage extends StatefulWidget {
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.20,
            width: MediaQuery.of(context).size.width,
            color: Colors.teal,
            child: Center(
                child: Text(
              "Islington Navigation",
              style: TextStyle(color: Colors.white, fontSize: 50.0),
            )),
          ),
          // FlatButton(
          //   child: Text("Routine"),
          //   onPressed: () {
          //     Navigator.of(context).push(
          //       new MaterialPageRoute(
          //         builder: (c) {
          //           return new RoutineList();
          //         },
          //       ),
          //     );
          //   },
          // ),

          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: FlatButton(
              child: Text(
                "Settings",
                style: TextStyle(color: Colors.red, fontSize: 30.0),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  new MaterialPageRoute(
                    builder: (c) {
                      return new SettingsPage();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
