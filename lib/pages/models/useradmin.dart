class UserAdmin{
  //atributos privados (por el guion bajo)
  var _uid;
  var _name;
  var _emai;
  var _genre;
  var _bornDate;
  var _cellphone;
  var _urlPicture;


  UserAdmin(this._uid, this._name, this._emai, this._genre, this._bornDate,
      this._cellphone, this._urlPicture);


  get uid => _uid;

  set uid(value) {
    _uid = value;
  }

  get name => _name;

  set name(value) {
    _name = value;
  }

  get emai => _emai;

  set emai(value) {
    _emai = value;
  }

  get genre => _genre;

  set genre(value) {
    _genre = value;
  }

  get bornDate => _bornDate;

  set bornDate(value) {
    _bornDate = value;
  }

  get cellphone => _cellphone;

  set cellphone(value) {
    _cellphone = value;
  }

  get urlPicture => _urlPicture;

  set urlPicture(value) {
    _urlPicture = value;
  }
  Map<String, dynamic> toJson() =>{
    'uid': _uid,
    'name': _name,
    'email': _emai,
    'genre': _genre,
    'bornDate': _bornDate,
    'cellphone': _cellphone,
    'urlPicture': _urlPicture,
  };
  // nos permite convertir un Json en un objento
  UserAdmin.fromJson(Map<String, dynamic> json)
      : _uid = json[ 'uid'],
        _name = json[ 'name'],
        _emai = json[ 'email'],
        _genre = json[ 'genre'],
        _bornDate = json[ 'bornDate'],
        _cellphone = json[ 'cellphone'],
        _urlPicture = json[ 'urlPicture'];
}