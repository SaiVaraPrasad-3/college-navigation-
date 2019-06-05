import 'package:islington_navigation_flutter/model/routine/note.dart';
import 'package:islington_navigation_flutter/model/routine/schedule.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database

  String noteTable = 'note_table';
  String colId = 'id';
  String colSubjectId = 'subject_id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';

  String classTable = 'routine_table';
  String classId = 'id';
  String classType = 'class_type';
  String classSubject = 'subject';
  String classSubjectId = 'subject_id';
  String classLocation = 'location';
  String classTeacher = 'Teacher';
  String classDay = 'day';
  String classTime = 'time';
  String classSection = 'section';
  String classYear = 'year';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'routine.db';

    try {
      await directory.create(recursive: true);
    } catch (_) {}

    // Open/create the database at a given path
    // await _lock.synchronized(() async {
    //   // Check again once entering the synchronized block
    //   var routineDatabase =
    //       await openDatabase(path, version: 1, onCreate: _createDb);
    // });
    var routineDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return routineDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colSubjectId INTEGER, $colDescription TEXT, $colPriority INTEGER, $colDate TEXT)');

    await db.execute(
        'CREATE TABLE $classTable($classId INTEGER PRIMARY KEY AUTOINCREMENT, $classType TEXT, $classSubject TEXT, $classSubjectId INTEGER, $classLocation TEXT, $classTeacher TEXT, $classDay TEXT, $classTime TEXT, $classSection TEXT, $classYear TEXT)');
  }

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getNoteMapList(int subjectId) async {
    Database db = await this.database;

    var result = await db
    .rawQuery('SELECT * FROM $noteTable where $colSubjectId = $subjectId order by $colPriority ASC');
    // var result = await db.query(noteTable, orderBy: '$colDate ASC');
    return result;
  }

  Future<List<Map<String, dynamic>>> getRoutineMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.query(classTable);
    return result;
  }

  // Insert Operation: Insert a Note object to database
  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

  Future<int> insertRoutine(Routine routine) async {
    Database db = await this.database;
    var result = await db.insert(classTable, routine.toMap());
    return result;
  }

  // Update Operation: Update a Note object and save it to database
  Future<int> updateNote(Note note) async {
    var db = await this.database;
    var result = await db.update(noteTable, note.toMap(),
        where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  Future<int> updateRoutine(Routine routine) async {
    var db = await this.database;
    var result = await db.update(classTable, routine.toMap(),
        where: '$classId = ?', whereArgs: [routine.id]);
    return result;
  }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteNote(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
    return result;
  }

  Future<int> deleteAllNote(int subjectid) async{
    var db = await this.database;
    int result = await db.rawDelete("DELETE FROM $noteTable where $colSubjectId = $subjectid");
    return result;
  }

  Future<int> deleteRoutine(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $classTable WHERE $classId = $id');
    return result;
  }

  // Get number of Note objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $noteTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<int> getRoutineCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $classTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<Note>> getNoteList(int subjectId) async {
    var noteMapList = await getNoteMapList(subjectId); // Get 'Map List' from database
    int count =
        noteMapList.length; // Count the number of map entries in db table

    List<Note> noteList = List<Note>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      noteList.add(Note.fromMapObject(noteMapList[i]));
    }

    return noteList;
  }

  Future<List<Routine>> getRoutineList() async {
    var routineMapList =
        await getRoutineMapList(); // Get 'Map List' from database
    int count =
        routineMapList.length; // Count the number of map entries in db table

    List<Routine> routineList = List<Routine>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      routineList.add(Routine.fromMapObject(routineMapList[i]));
    }

    return routineList;
  }
}
