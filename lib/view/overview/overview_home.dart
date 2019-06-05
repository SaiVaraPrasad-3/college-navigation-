import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:islington_navigation_flutter/view/overview/blocks/overview.dart';
import 'package:islington_navigation_flutter/view/overview/structures/structures.dart';

class OverviewHome extends StatefulWidget {
  static String tag = "overview";

  @override
  _OverviewHomeState createState() => _OverviewHomeState();
}

class _OverviewHomeState extends State<OverviewHome> {
  final Map<int, Widget> children = const <int, Widget>{
    0: Text('Blocks'),
    1: Text('Structures'),
  };

  final Map<int, Widget> icons = <int, Widget>{
    0: CollegeOverview(),
    1: StructureCategory(),
  };

  int sharedValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTextStyle(
        style: CupertinoTheme.of(context).textTheme.textStyle,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              SizedBox(
                width: 500.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 32.0,
                    horizontal: 16.0,
                  ),
                  child: CupertinoSegmentedControl<int>(
                    children: children,
                    onValueChanged: (int newValue) {
                      setState(() {
                        sharedValue = newValue;
                      });
                    },
                    groupValue: sharedValue,
                  ),
                ),
              ),
              Expanded(
                child: icons[sharedValue],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
