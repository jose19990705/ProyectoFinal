class UserAdmin{
  //atributos privados (por el guion bajo)
  var _uid;
  var _name;
  var _emai;
  var _genre;
  var _bornDate;
  var _urlPicture;

  UserAdmin(this._uid, this._name, this._emai, this._genre, this._bornDate,
      this._urlPicture);

  get urlPicture => _urlPicture;

  set urlPicture(value) {
    _urlPicture = value;
  }

  get bornDate => _bornDate;

  set bornDate(value) {
    _bornDate = value;
  }

  get genre => _genre;

  set genre(value) {
    _genre = value;
  }

  get emai => _emai;

  set emai(value) {
    _emai = value;
  }

  get name => _name;

  set name(value) {
    _name = value;
  }

  get uid => _uid;

  set uid(value) {
    _uid = value;
  }

  Map<String, dynamic> toJson() =>{
    'uid': _uid,
    'name': _name,
    'email': _emai,
    'genre': _genre,
    'bornDate': _bornDate,
    'urlPicture': _urlPicture,
  };
  // nos permite convertir un Json en un objento
  UserAdmin.fromJson(Map<String, dynamic> json)
      : _uid = json[ 'uid'],
        _name = json[ 'name'],
        _emai = json[ 'email'],
        _genre = json[ 'genre'],
        _bornDate = json[ 'bornDate'],
        _urlPicture = json[ 'urlPicture'];

}