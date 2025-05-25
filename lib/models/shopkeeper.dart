class Shopkeeper{
  var _uid;
  var _name;
  var _email;
  var _bornDate;
  var _businessDescription;
  var _productsService;


  Shopkeeper(this._uid, this._name, this._email, this._bornDate,
      this._businessDescription, this._productsService);

  Map<String, dynamic> tojson()=>{
    'uid': _uid,
    'name': _name,
    'email': _email,
    'bornDate': _bornDate,
    'businessDescription': _businessDescription,
    'productsService': _productsService,



  };

  get productsService => _productsService;

  set productsService(value) {
    _productsService = value;
  }

  get businessDescription => _businessDescription;

  set businessDescription(value) {
    _businessDescription = value;
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