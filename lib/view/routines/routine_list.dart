import 'dart:async';

import 'package:flutter/material.dart';
import 'package:islington_navigation_flutter/controller/database_helper.dart';
import 'package:islington_navigation_flutter/model/routine/schedule.dart';
import 'package:islington_navigation_flutter/view/notes/note_list.dart';
import 'package:islington_navigation_flutter/view/routines/routine_details.dart';

import 'package:sqflite/sqflite.dart';

class RoutineList extends StatefulWidget {
  _RoutineListState createState() => _RoutineListState();
}

class _RoutineListState extends State<RoutineList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Routine> routineList;
  int count = 0;
  bool displayNote = false;
  bool displayDetails = false;

  @override
  Widget build(BuildContext context) {
    if (routineList == null) {
      routineList = List<Routine>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Routine"),
      ),
      body: getRoutineListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB clicked');
          navigateToDetail(
              Routine('Lecture', 'Application Development', 1, '', '', 'Sun',
                  '', 'C1', 'Year 1'),
              'Add Routine');
        },
        // this._classtype, this._subject, this._subjectId, this._location, this._teacher, this._day, this._time, this._section, this._year
        tooltip: 'Add Routine',
        child: Icon(Icons.add),
      ),
    );
  }

  void navigateToDetail(Routine routine, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return RoutineDetail(routine, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  // void display(index) {}

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Routine>> routineListFuture = databaseHelper.getRoutineList();
      routineListFuture.then((routineList) {
        setState(() {
          this.routineList = routineList;
          this.count = routineList.length;
        });
      });
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void _delete(BuildContext context, Routine routine) async {
    int result = await databaseHelper.deleteRoutine(routine.id);
    if (result != 0) {
      _showSnackBar(context, 'Routine Deleted Successfully');
      updateListView();
    }
  }

  void _deleteNote(BuildContext context, Routine routine) async {
    int result = await databaseHelper.deleteAllNote(routine.subjectId);
    if (result != 0) {
      _showSnackBar(context, 'Routine Deleted Successfully');
      updateListView();
    }
  }

  ListView getRoutineListView() {
    print("inside getRoutineListView");
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          elevation: 2.0,
          child: Dismissible(
              key: Key(routineList[index].toString()),
              onDismissed: (direction) {
                _deleteNote(context, routineList[index]);
                _delete(context, routineList[index]);
              },
              background: Container(
                color: Colors.red,
                child: Center(
                    child: Text(
                  "Delete",
                  style: TextStyle(color: Colors.black),
                )),
              ),
              child: RoutineListTile(this.routineList[index])),
        );
      },
    );
  }
}

class RoutineListTile extends StatefulWidget {
  Routine routineList;
  RoutineListTile(this.routineList);
  _RoutineListTileState createState() => _RoutineListTileState();
}

class _RoutineListTileState extends State<RoutineListTile> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  int count = 0;
  bool displayNote = false;
  bool displayDetails = false;
  List<Routine> routineList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          child: ListTile(
            leading: CircleAvatar(
              child: Text(this.widget.routineList.day.toString()),
            ),
            title: Text(this.widget.routineList.classType.toString()),
            subtitle: Text(this.widget.routineList.subject.toString()),
            trailing: Text(this.widget.routineList.time.toString()),
            onLongPress: () {
              navigateToDetail(this.widget.routineList, 'Edit routine');
            },
            onTap: () {
              setState(() {
                displayDetails = displayDetails ? false : true;
              });
            },
          ),
          onDoubleTap: () {
            setState(() {
              displayNote = displayNote ? false : true;
            });
          },
        ),
        displayNote
            ? Container(
                child: FlatButton(
                  child: Text("Note"),
                  onPressed: () {
                    Navigator.of(context).push(
                      new MaterialPageRoute(builder: (c) {
                        return new NoteList(this.widget.routineList.subjectId);
                      }),
                    );
                  },
                ),
              )
            : SizedBox(),
        displayDetails
            ? Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(Icons.location_city),
                          Text(
                            this.widget.routineList.location.toString(),
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Icon(Icons.person_pin_circle),
                          Text(
                            this.widget.routineList.teacher.toString(),
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Icon(Icons.calendar_view_day),
                          Text(
                            this.widget.routineList.year.toString(),
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Icon(Icons.child_friendly),
                          Text(
                            this.widget.routineList.section.toString(),
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            : SizedBox(),
      ],
    );
  }

  void navigateToDetail(Routine routine, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return RoutineDetail(routine, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  // void display(index) {}

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Routine>> routineListFuture = databaseHelper.getRoutineList();
      routineListFuture.then((routineList) {
        setState(() {
          this.routineList = routineList;
          this.count = routineList.length;
        });
      });
    });
  }
}
