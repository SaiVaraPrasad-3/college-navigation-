class Routine{

  int _id;
  String _classtype;
  String _subject;
  int _subjectId;
  String _location;
  String _teacher;
	String _day;
	String _time;  
  String _section;
  String _year;

  Routine(this._classtype, this._subject, this._subjectId, this._location, this._teacher, this._day, this._time, this._section, this._year);
  
  Routine.withId(this._id, this._classtype, this._subject, this._subjectId, this._location, this._teacher, this._day, this._time, this._section, this._year);

  int get id => _id;
  String get classType => _classtype;
  String get subject => _subject;
  int get subjectId => _subjectId;
  String get location => _location;
  String get teacher => _teacher;
  String get day => _day;
  String get time => _time;
  String get section => _section;
  String get year => _year;

  set classType(String newclassType) {
    this._classtype = newclassType;
  }
  
  set subject(String newSubject) {
    this._subject = newSubject;
  }

  set subjectId(int newSubjectId) {
    this._subjectId = newSubjectId;
  }

  set location(String newLocation) {
    this._location = newLocation;
  }

  set teacher(String newTeacher) {
    this._teacher = newTeacher;
  }
  
  set day(String newDay) {
    this._day = newDay;
  }
  
  set time(String newTime) {
    this._time = newTime;
  }
  
  set section(String newSection) {
    this._section = newSection;
  }
  
  set year(String newYear) {
    this._year = newYear;
  }

  // Convert a Routine object into a Map object
	Map<String, dynamic> toMap() {

		var map = Map<String, dynamic>();
		if (id != null) {
			map['id'] = _id;
		}
		map['class_type'] = _classtype;
		map['subject'] = _subject;
    map['subject_id'] = _subjectId;
		map['location'] = _location;
		map['teacher'] = _teacher;
		map['day'] = day;
		map['time'] = _time;
		map['section'] = _section;
    map['year'] = _year;

		return map;
	}

	// Extract a Routine object from a Map object
	Routine.fromMapObject(Map<String, dynamic> map) {
		this._id = map['id'];
		this._classtype = map['class_type'];
		this._subject = map['subject'];
    this._subjectId = map['subject_id'];
		this._location = map['location'];
		this._teacher = map['teacher'];
		this._day = map['day'];
		this._time = map['time'];
		this._section = map['section'];
    this._year = map['year'];
	}
}