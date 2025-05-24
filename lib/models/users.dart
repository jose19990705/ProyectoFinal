class User {
  var _uid;
  var _name;
  var _email;
  var _typeCustomer;
  var _bornDate;
  var _urlPicture;


  User(this._uid, this._name, this._email, this._typeCustomer, this._bornDate,
      this._urlPicture);

  Map<String, dynamic> tojson()=>{
    'uid': _uid,
    'name': _name,
    'email': _email,
    'typeCustomer': _typeCustomer,
    'bornDate': _bornDate,
    'urlPicture': _urlPicture

  };

  User.fromJson(Map<String, dynamic> json)
      : _uid= json['uid'],
        _name= json['name'],
        _email= json['email'],
        _typeCustomer= json['typeCustomer'],
        _bornDate= json['bornDate'],
        _urlPicture=json['urlPicture'];

  get urlPicture => _urlPicture;

  set urlPicture(value) {
    _urlPicture = value;
  }

  get bornDate => _bornDate;

  set bornDate(value) {
    _bornDate = value;
  }

  get typeCustomer => _typeCustomer;

  set typeCustomer(value) {
    _typeCustomer = value;
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