import 'package:flutter/material.dart';
import 'package:islington_navigation_flutter/controller/database_helper.dart';
import 'package:islington_navigation_flutter/model/routine/schedule.dart';
import 'package:islington_navigation_flutter/view/routines/routine_list.dart';

class RoutineDetail extends StatefulWidget {
  final Routine routine;
  final title;

  RoutineDetail(this.routine, this.title);

  _RoutineDetailState createState() => _RoutineDetailState(routine);
}

class _RoutineDetailState extends State<RoutineDetail> {
  DatabaseHelper helper = DatabaseHelper();
  Routine routine;

  final formKey = GlobalKey<FormState>();

  var _dropDownSection = ["C1", "C2", "C3", "C4", "C5", "C6", "C7"];
  var _dropDownClassType = ["Lecture", "Lab", "Tutorial"];
  var _dropDownYear = ["Year 1", "Year 2", "Year 3"];
  var _dropDownSubject = ["Programming", "Database", "AI", "FYP"];
  var _dropDownDay = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri"];

  // TextEditingController classTypeController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  // TextEditingController subjectController = TextEditingController();
  TextEditingController teacherController = TextEditingController();
  // TextEditingController dayController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  // TextEditingController sectionController = TextEditingController();

  _RoutineDetailState(
    this.routine,
  );

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    // classTypeController.text = routine.classType;
    locationController.text = routine.location;
    // subjectController.text = routine.subject;
    teacherController.text = routine.teacher;
    // dayController.text = routine.day;
    timeController.text = routine.time;
    // sectionController.text = routine.section;

    //dropdown for section
    final sectionVariable = ListTile(
      title: DropdownButton(
          items: _dropDownSection.map((String dropDownStringItem) {
            return DropdownMenuItem<String>(
              value: dropDownStringItem,
              child: Text(dropDownStringItem),
            );
          }).toList(),
          style: textStyle,
          value: getSectionAsString(routine.section),
          onChanged: (valueSelectedByUser) {
            setState(() {
              debugPrint('User selected $valueSelectedByUser');
              updateSectionAsString(valueSelectedByUser);
            });
          }),
    );

    //dropdown for classType
    final classTimeVariable = ListTile(
      title: DropdownButton(
          items: _dropDownClassType.map((String dropDownStringItem) {
            return DropdownMenuItem<String>(
              value: dropDownStringItem,
              child: Text(dropDownStringItem),
            );
          }).toList(),
          style: textStyle,
          value: getClassTypeAsString(routine.classType),
          onChanged: (valueSelectedByUser) {
            setState(() {
              debugPrint('User selected $valueSelectedByUser');
              updateClassTypeAsString(valueSelectedByUser);
            });
          }),
    );

    //dropdown for subject
    final subjectVariable = ListTile(
      title: DropdownButton(
          items: _dropDownSubject.map((String dropDownStringItem) {
            return DropdownMenuItem<String>(
              value: dropDownStringItem,
              child: Text(dropDownStringItem),
            );
          }).toList(),
          style: textStyle,
          value: getSubjectAsString(routine.subject),
          onChanged: (valueSelectedByUser) {
            setState(() {
              debugPrint('User selected $valueSelectedByUser');
              updateSubjectAsString(valueSelectedByUser);
            });
          }),
    );

    //dropdown for Year
    final yearVariable = ListTile(
      title: DropdownButton(
          items: _dropDownYear.map((String dropDownStringItem) {
            return DropdownMenuItem<String>(
              value: dropDownStringItem,
              child: Text(dropDownStringItem),
            );
          }).toList(),
          style: textStyle,
          value: getYearAsString(routine.year),
          onChanged: (valueSelectedByUser) {
            setState(() {
              debugPrint('User selected $valueSelectedByUser');
              updateYearAsString(valueSelectedByUser);
            });
          }),
    );

    // dropdown for day
    final dayVariable = ListTile(
      title: DropdownButton(
          items: _dropDownDay.map((String dropDownStringItem) {
            return DropdownMenuItem<String>(
              value: dropDownStringItem,
              child: Text(dropDownStringItem),
            );
          }).toList(),
          style: textStyle,
          value: getDayAsString(routine.day),
          onChanged: (valueSelectedByUser) {
            setState(() {
              debugPrint('User selected $valueSelectedByUser');
              updateDayAsString(valueSelectedByUser);
            });
          }),
    );

    //text field for Location
    final locationVariable = Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: TextFormField(
        controller: locationController,
        style: textStyle,
        validator: (value) =>
            value.isEmpty ? "Must enter Classroom name" : null,
        onSaved: (value) {
          debugPrint('Something changed in location Text Field');
          updateLocation();
        },
        decoration: InputDecoration(
            labelText: 'Classroom',
            labelStyle: textStyle,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
      ),
    );

    //text field for teacher
    final teacherVariable = Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: TextFormField(
        controller: teacherController,
        style: textStyle,
        validator: (value) => value.isEmpty ? "Must enter lecturer name" : null,
        onSaved: (value) {
          debugPrint('Something changed in teacher Text Field');
          updateTeacher();
        },
        decoration: InputDecoration(
            labelText: 'Lecturer',
            labelStyle: textStyle,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
      ),
    );

    // text field for time
    final timeVariable = Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: TextFormField(
        controller: timeController,
        style: textStyle,
        validator: (value) =>
            value.isEmpty ? "Must enter time of your class" : null,
        onSaved: (value) {
          debugPrint('Something changed in time Text Field');
          updateTime();
        },
        decoration: InputDecoration(
            labelText: 'time',
            labelStyle: textStyle,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
      ),
    );

    // buttons
    final buttons = Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: RaisedButton(
              color: Theme.of(context).primaryColorDark,
              textColor: Theme.of(context).primaryColorLight,
              child: Text(
                'Save',
                textScaleFactor: 1.5,
              ),
              onPressed: () {
                setState(() {
                  debugPrint("Save button clicked");
                  validate();
                });
              },
            ),
          ),
          Container(
            width: 5.0,
          ),
          Expanded(
            child: RaisedButton(
              color: Theme.of(context).primaryColorDark,
              textColor: Theme.of(context).primaryColorLight,
              child: Text(
                'Delete',
                textScaleFactor: 1.5,
              ),
              onPressed: () {
                setState(() {
                  debugPrint("Delete button clicked");
                  _delete();
                });
              },
            ),
          ),
        ],
      ),
    );

    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                // Write some code to control things, when user press back button in AppBar
                moveToLastScreen();
              }),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: Form(
            key: formKey,
            child: ListView(
              children: <Widget>[
                sectionVariable,
                classTimeVariable,
                subjectVariable,
                yearVariable,
                locationVariable,
                teacherVariable,
                dayVariable,
                timeVariable,
                buttons,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  getClassTypeAsString(String value) {
    String classType;
    switch (value) {
      case "Lecture":
        classType = _dropDownClassType[0];
        break;
      case "lab":
        classType = _dropDownClassType[1];
        break;
      case "Tutorial":
        classType = _dropDownClassType[2];
        break;
    }
    return classType;
  }

  void updateClassTypeAsString(String value) {
    switch (value) {
      case 'Lecture':
        routine.classType = "Lecture";
        break;
      case 'Lab':
        routine.classType = "Lab";
        break;
      case 'Tutorial':
        routine.classType = "Tutorial";
        break;
    }
  }

  getYearAsString(String value) {
    String year;
    switch (value) {
      case 'Year 1':
        year = _dropDownYear[0];
        break;
      case 'Year 2':
        year = _dropDownYear[1];
        break;
      case 'Year 3':
        year = _dropDownYear[2];
        break;
    }
    return year;
  }

  void updateYearAsString(String value) {
    switch (value) {
      case 'Year 1':
        routine.year = 'Year 1';
        break;
      case 'Year 2':
        routine.year = 'Year 2';
        break;
      case 'Year 3':
        routine.year = 'Year 3';
        break;
    }
  }

  getSectionAsString(String value) {
    String section;
    switch (value) {
      case "C1":
        section = _dropDownSection[0];
        break;
      case "C2":
        section = _dropDownSection[1];
        break;
      case "C3":
        section = _dropDownSection[2];
        break;
      case "C4":
        section = _dropDownSection[3];
        break;
      case "C5":
        section = _dropDownSection[4];
        break;
      case "C6":
        section = _dropDownSection[5];
        break;
      case "C7":
        section = _dropDownSection[6];
        break;
    }
    return section;
  }

  void updateSectionAsString(String value) {
    switch (value) {
      case 'C1':
        routine.section = "C1";
        break;
      case 'C2':
        routine.section = "C2";
        break;
      case 'C3':
        routine.section = "C3";
        break;
      case 'C4':
        routine.section = "C4";
        break;
      case 'C5':
        routine.section = "C5";
        break;
      case 'C6':
        routine.section = "C6";
        break;
      case 'C7':
        routine.section = "C7";
        break;
    }
  }

  getSubjectAsString(String value) {
    String subject;
    switch (value) {
      case 'Programming':
        subject = _dropDownSubject[0];
        break;
      case 'Database':
        subject = _dropDownSubject[1];
        break;
      case 'AI':
        subject = _dropDownSubject[2];
        break;
      case 'FYP':
        subject = _dropDownSubject[3];
        break;
    }
    return subject;
  }

  void updateSubjectAsString(String value) {
    switch (value) {
      case 'Programming':
        routine.subject = 'Programming';
        break;
      case 'Database':
        routine.subject = 'Database';
        break;
      case 'AI':
        routine.subject = 'AI';
        break;
      case 'FYP class':
        routine.subject = 'FYP';
        break;
    }
  }

  getDayAsString(String value) {
    String day;
    switch (value) {
      case "Sun":
        day = _dropDownDay[0];
        break;
      case "Mon":
        day = _dropDownDay[1];
        break;
      case "Tue":
        day = _dropDownDay[2];
        break;
      case "Wed":
        day = _dropDownDay[3];
        break;
      case "Thu":
        day = _dropDownDay[4];
        break;
      case "Fri":
        day = _dropDownDay[5];
        break;
    }
    return day;
  }

  void updateDayAsString(String value) {
    switch (value) {
      case 'Sun':
        routine.day = "Sun";
        break;
      case 'Mon':
        routine.day = "Mon";
        break;
      case 'Tue':
        routine.day = "Tue";
        break;
      case 'Wed':
        routine.day = "Wed";
        break;
      case 'Thu':
        routine.day = "Thu";
        break;
      case 'Fri':
        routine.day = "Fri";
        break;
    }
  }

  void updateSection() {
    // routine.section = sectionController.text;
  }

  void updateClassType() {
    // routine.classType = classTypeController.text;
  }

  void updateSubject() {
    // routine.subject = subjectController.text;
  }

  void updateLocation() {
    routine.location = locationController.text;
  }

  void updateTeacher() {
    routine.teacher = teacherController.text;
  }

  void updateDay() {
    // routine.day = dayController.text;
  }

  void updateTime() {
    routine.time = timeController.text;
  }

  void validate() {
    final addRoutineForm = formKey.currentState;

    if (addRoutineForm.validate()) {
      addRoutineForm.save();
      _save();
    }
  }

  void _save() async {
    Navigator.of(context).pop();

    if (routine.subject == "Programming") {
      setState(() {
        routine.subjectId = 1;
      });
    } else if (routine.subject == "Database") {
      setState(() {
        routine.subjectId = 2;
      });
    } else if (routine.subject == "AI") {
      setState(() {
        routine.subjectId = 3;
      });
    } else if (routine.subject == "FYP") {
      setState(() {
        routine.subjectId = 4;
      });
    }

    int result;
    if (routine.id != null) {
      //update operation
      result = await helper.updateRoutine(routine);
    } else {
      result = await helper.insertRoutine(routine);
    }

    if (result != 0) {
      //success
      _showAlertDialog('Status', 'Routine added');
    } else {
      // Failure
      _showAlertDialog('Status', 'Routine failed to add');
    }

    // Navigator.pop(context);
    // Navigator.of(context).pushReplacementNamed('/routineMain');
  }

  void _delete() async {
    moveToLastScreen();

    int result = await helper.deleteRoutine(routine.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Routine deleted!!!');
    } else {
      _showAlertDialog('Status', 'Routine failed to delete');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
