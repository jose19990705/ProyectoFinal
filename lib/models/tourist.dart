class Tourist {
  var _uid;
  var _name;
  var _email;
  var _bornDate;
  var _foodTastes;
  var _placeTates;
  var _usertypet;


  Tourist(this._uid, this._name, this._email, this._bornDate, this._foodTastes,
      this._placeTates, this._usertypet);

  Map<String, dynamic> tojson()=>{
    'uid': _uid,
    'name': _name,
    'email': _email,
    'bornDate': _bornDate,
    'foodTastes': _foodTastes,
    'placeTates':_placeTates,
    'usertypet':_usertypet,


  };




  Tourist.fromJson(Map<String, dynamic> json)
      : _uid= json['uid'],
        _name= json['name'],
        _email= json['email'],
        _bornDate= json['bornDate'],
        _foodTastes=json['foodTastes'],
        _placeTates= json['placeTates'],
        _usertypet= json['usertypet'];

  get usertypet => _usertypet;

  set usertypet(value) {
    _usertypet = value;
  }

  get placeTates => _placeTates;

  set placeTates(value) {
    _placeTates = value;
  }

  get foodTastes => _foodTastes;

  set foodTastes(value) {
    _foodTastes = value;
  }

  get bornDate => _bornDate;

  set bornDate(value) {
    _bornDate = value;
  }

  get email => _email;

  set email(value) {
    _email = value;
  }

  get name => _name;

  set name(value) {
    _name = value;
  }

  get uid => _uid;

  set uid(value) {
    _uid = value;
  }


}