class Tourist {
  var _uid;
  var _name;
  var _email;
  var _bornDate;
  var _foodTastes;
  var _placeTates;


  Tourist(this._uid, this._name, this._email, this._bornDate, this._foodTastes,
      this._placeTates);

  Map<String, dynamic> tojson()=>{
    'uid': _uid,
    'name': _name,
    'email': _email,
    'bornDate': _bornDate,
    'foodTastes': _foodTastes,
    'placeTates':_placeTates,


  };




  Tourist.fromJson(Map<String, dynamic> json)
      : _uid= json['uid'],
        _name= json['name'],
        _email= json['email'],
        _bornDate= json['bornDate'],
        _foodTastes=json['foodTastes'],
        _placeTates= json['placeTates'];

  get uid => _uid;

  set uid(value) {
    _uid = value;
  }
  get name => _name;

  set name(value) {
    _name = value;
  }

  get email => _email;

  set email(value) {
    _email = value;
  }

  get bornDate => _bornDate;

  set bornDate(value) {
    _bornDate = value;
  }

  get foodTastes => _foodTastes;

  set foodTastes(value) {
    _foodTastes = value;
  }

  get placeTates => _placeTates;

  set placeTates(value) {
    _placeTates = value;
  }

}