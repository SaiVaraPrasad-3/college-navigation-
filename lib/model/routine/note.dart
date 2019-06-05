class Note {

	int _id;
  int _subjectId;
	String _title;
	String _description;
	String _date;
	int _priority;

	Note(this._subjectId, this._title, this._date, this._priority, [this._description]);

	Note.withId(this._subjectId, this._id, this._title, this._date, this._priority, [this._description]);

	int get id => _id;

  int get subjectId => _subjectId;

	String get title => _title;

	String get description => _description;

	int get priority => _priority;

	String get date => _date;

  set subjectId(int newSubjectId) {
    if(newSubjectId <= 255) {
      this._subjectId = newSubjectId;
    }
  }

	set title(String newTitle) {
		if (newTitle.length <= 255) {
			this._title = newTitle;
		}
	}

	set description(String newDescription) {
		if (newDescription.length <= 255) {
			this._description = newDescription;
		}
	}

	set priority(int newPriority) {
		if (newPriority >= 1 && newPriority <= 2) {
			this._priority = newPriority;
		}
	}

	set date(String newDate) {
		this._date = newDate;
	}

	// Convert a Note object into a Map object
	Map<String, dynamic> toMap() {

		var map = Map<String, dynamic>();
		if (id != null) {
			map['id'] = _id;
		}
    if (subjectId != null) {
      map['subject_id'] = _subjectId;
    }
		map['title'] = _title;
		map['description'] = _description;
		map['priority'] = _priority;
		map['date'] = _date;

		return map;
	}

	// Extract a Note object from a Map object
	Note.fromMapObject(Map<String, dynamic> map) {
		this._id = map['id'];
    this._subjectId = map['subject_id'];
		this._title = map['title'];
		this._description = map['description'];
		this._priority = map['priority'];
		this._date = map['date'];
	}
}