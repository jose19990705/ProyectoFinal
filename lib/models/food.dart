class Food {
  var _id;
  var _nombre;
  var _precio;
  var _categoria;
  var _descripcion;
  var _ratingFood;
  var _imagenBase64;
  var _urlImage;


  Food(this._id,this._nombre, this._precio, this._categoria, this._descripcion,
this._imagenBase64, this._ratingFood, this._urlImage);

get urlImage => _urlImage;

set urlImage(value) {
  _urlImage = value;
}


  Map<String, dynamic> toJson() => {
    'id': _id,
    'nombre': _nombre,
    'precio': _precio,
    'categoria': _categoria,
    'descripcion': _descripcion,
    'imagen': _imagenBase64,
    'urlImage': _urlImage,
    'ratingFood': _ratingFood,
  };

  get id => _id;

  set id(value) {
    _id = value;
  }

  get imagenBase64 => _imagenBase64;

  set imagenBase64(value) {
    _imagenBase64 = value;
  }



  get descripcion => _descripcion;

  set descripcion(value) {
    _descripcion = value;
  }

  get categoria => _categoria;

  set categoria(value) {
    _categoria = value;
  }

  get precio => _precio;

  set precio(value) {
    _precio = value;
  }

  get nombre => _nombre;

  set nombre(value) {
    _nombre = value;
  }

  get ratingFood => _ratingFood;

  set ratingFood(value) {
    _ratingFood = value;
  }


}
