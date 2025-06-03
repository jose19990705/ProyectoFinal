class Event {
  var _uid;
  var _organizer;
  var _nameEvent;
  var _category;
  var _startTime;
  var _endTime;
  var _cost;
  var _urlImage;
  var _location;
  var _description;
  var _link;
  var _ages;
  var _initialDate;
  var _finalDate;
  var _picture;

  Event(this._uid, this._organizer, this._nameEvent, this._category,
      this._startTime, this._endTime, this._cost, this._urlImage,
      this._location, this._description, this._link, this._ages,
      this._initialDate, this._finalDate, this._picture);


  get picture => _picture;

  set picture(value) {
    _picture = value;
  }

  get finalDate => _finalDate;

  set finalDate(value) {
    _finalDate = value;
  }

  get initialDate => _initialDate;

  set initialDate(value) {
    _initialDate = value;
  }

  get ages => _ages;

  set ages(value) {
    _ages = value;
  }

  get link => _link;

  set link(value) {
    _link = value;
  }

  get description => _description;

  set description(value) {
    _description = value;
  }

  get location => _location;

  set location(value) {
    _location = value;
  }

  get urlImage => _urlImage;

  set urlImage(value) {
    _urlImage = value;
  }

  get cost => _cost;

  set cost(value) {
    _cost = value;
  }

  get endTime => _endTime;

  set endTime(value) {
    _endTime = value;
  }

  get startTime => _startTime;

  set startTime(value) {
    _startTime = value;
  }

  get category => _category;

  set category(value) {
    _category = value;
  }

  get nameEvent => _nameEvent;

  set nameEvent(value) {
    _nameEvent = value;
  }

  get organizer => _organizer;

  set organizer(value) {
    _organizer = value;
  }

  get uid => _uid;

  set uid(value) {
    _uid = value;
  }
  Map<String, dynamic> toJson() =>{
    'uid': _uid,
    'organizer': _organizer,
    'nameEvent': _nameEvent,
    'category': _category,
    'startTime': _startTime,
    'endTime': _endTime,
    'cost': _cost,
    'urlImage': _urlImage,
    'location': _location,
    'description': _description,
    'link': _link,
    'ages': _ages,
    'initialDate': _initialDate,
    'finalDate': _finalDate,
    'picture': _picture,

  };
  // nos permite convertir un Json en un objento
  Event.fromJson(Map<String, dynamic> json)
      : _uid = json[ 'uid'],
        _organizer = json[ 'organizer'],
        _nameEvent = json[ 'nameEvent'],
        _category = json[ 'category'],
        _startTime = json[ 'startTime'],
        _endTime = json[ 'endTime'],
        _cost = json[ 'cost'],
        _urlImage = json[ 'urlImage'],
        _location = json[ 'location'],
        _description = json[ 'description'],
        _link = json[ 'link'],
        _ages = json[ 'ages'],
        _initialDate = json[ 'initialDate'],
        _finalDate = json[ 'finalDate'],
        _picture = json[ 'picture'];

}


