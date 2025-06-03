import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laboratorio_3/models/tourist.dart';
import 'package:laboratorio_3/pages/repository/firebase_api_Register_Tourist_And_shopkeeper.dart';
import 'package:laboratorio_3/pages/sign_in_Page.dart';



class SignUpTouristPage extends StatefulWidget {
  const SignUpTouristPage({super.key});

  @override
  State<SignUpTouristPage> createState() => _SignUpTouristPageState();
}

class _SignUpTouristPageState extends State<SignUpTouristPage> {




  final List<String> _food = [
    'Comida Italiana',
    'Comida Mexicana',
    'Comida China',
    'Comida Colombiana',
  ];


  Map<String, bool> _comidasSeleccionadas = {};

  final List<String> _places = [
    'Discotecas',
    'Eco parques',
    'Museos',
    'Zonas culturales',
  ];
  Map<String, bool> _lugaresSeleccionados = {};

  @override
  void initState() {
    super.initState();
    for (var comida in _food) {
      _comidasSeleccionadas[comida] = false;
    }
    for (var lugar in _places){
      _lugaresSeleccionados[lugar]=false;
    }
  }



  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _RegPassword = TextEditingController();
  final _firebaseApiRegisterTurista= FirebaseApiRegisterTouristAndShopkeeper();

  //final FirebaseApiRegisterTur _firebaseApi = FirebaseApiRegisters();
  bool _isRegPasswordoscuro = true;
  bool _oscuro = true;

  String buttonMsg = "Fecha de nacimiento";

  DateTime _bornDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(//imagen de fondo
            child: Image.asset(
              'assets/images/R_T.png',
              fit: BoxFit.cover, //para ajustar la imagen
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(
                      image: AssetImage('assets/images/MEDEX.png'),
                      width: 500,
                      height: 250,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _name,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Nombre",
                        prefixIcon: Icon(Icons.person),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _email,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Correo electrónico",
                        prefixIcon: Icon(Icons.mail),
                      ),
                      keyboardType: TextInputType.name,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Debe ingresar un correo electrónico.";
                        } else {
                          if (!value!.isvalidEmail()) {
                            return "El correo electrónico no es válido.";
                          }
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _password,
                      obscureText: _oscuro,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _oscuro ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _oscuro = !_oscuro;
                            });
                          },
                        ),
                        labelText: "Password",
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _RegPassword,
                      obscureText: _isRegPasswordoscuro,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isRegPasswordoscuro
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isRegPasswordoscuro = !_isRegPasswordoscuro;
                            });
                          },
                        ),
                        labelText: " repita la contraseña",
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        const Text("Hablanos sobre ti!!"),
                        const SizedBox(height: 16,),
                        const Text("¿Qué comida es tu favorita?"),
                        const SizedBox(height: 16,),
                        Column(
                          children: _food.map((comida) {
                            return CheckboxListTile(
                              title: Text(comida),
                              value: _comidasSeleccionadas[comida],
                              onChanged: (bool? value) {
                                setState(() {
                                  _comidasSeleccionadas[comida] = value!;
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16,),
                        const Text("¿Qué tipos de lugares te gustan?"),
                        const SizedBox(height: 16,),

                        Column(
                          children: _places.map((lugar) {
                            return CheckboxListTile(
                              title: Text(lugar),
                              value: _lugaresSeleccionados[lugar],
                              onChanged: (bool? value) {
                                setState(() {
                                  _lugaresSeleccionados[lugar] = value!;
                                });
                              },
                            );
                          }).toList(),
                        ),

                      ],
                    ),

                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _showSelectedDate();
                      },
                      child: Text(buttonMsg),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _onRegisterButtonClicked();
                      },
                      child: const Text("Registrar"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )

    );
  }

  void _onRegisterButtonClicked() {
    bool atleastOneFood = _comidasSeleccionadas.containsValue(true);
    bool atleastonePlace = _lugaresSeleccionados.containsValue(true);

    if (_email.text.isEmpty ||
        _password.text.isEmpty ||
        _RegPassword.text.isEmpty) {
      showMesg("Todos los campos deben estar diligenciados");
    } else if (_password.text != _RegPassword.text) {
      showMesg("Las contraseñas deben ser iguales");
    } else if (_password.text.length < 6) {
      showMesg("La contraseña no puede tener menos de 6 caracteres");
    } else if (!atleastOneFood) {
      showMesg("Debes seleccionar al menos una comida favorita");
    } else if (!atleastonePlace) {
      showMesg("Debes seleccionar al menos un lugar favorito");
    } else {
      creatUserTurista(_email.text, _password.text,_comidasSeleccionadas,_lugaresSeleccionados);
    }
  }




  void creatUserTurista(String email, String password,Map<String, bool> favoriteFood
  ,Map<String, bool> favoritePlaces) async {
    var result = await _firebaseApiRegisterTurista.createUser(email, password);
    if (result == 'weak-password') {
      showMesg("La contraseña debe tener al menos 6 dígitos");
    } else if (result == 'email-already-in-use') {
      showMesg('Ya existe una cuenta asociada con este correo electronico');
    } else if (result == 'invalid-email') {
      showMesg('El correo electronico esta mal escrito');
    } else if (result == 'network-request-failed') {
      showMesg('Revise su conexión a internet');
    } else {
      List<String> _foodType = favoriteFood.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();

      List<String> _placesType = favoritePlaces.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();

      var _turista=Tourist(result, _name.text, _email.text, _bornDate,_foodType , _placesType, "Turista");

      creatUserInDB(_turista);
    }
  }

  Future<void> creatUserInDB(Tourist user) async {
    var result = await _firebaseApiRegisterTurista.creatTouristIDB(user);

    if (result == 'network-request-failed') {
      showMesg('Revise su conexión a internet');
    } else {
      showMesg("Usuario registrado exitosamente");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignInPage()));

    }
  }

  void showMesg(String Msg) {
    final Scaffold = ScaffoldMessenger.of(context);
    Scaffold.showSnackBar(
      SnackBar(
        content: Text(Msg),
        duration: Duration(seconds: 10),
        action: SnackBarAction(
          label: "Aceptar",
          onPressed: Scaffold.hideCurrentSnackBar,
        ),
      ),
    );
  }

  void _showSelectedDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1925, 1),
      lastDate: DateTime.now(),
      helpText: "Fecha de nacimiento",
    );

    if (pickedDate != null) {
      final now = DateTime.now();
      final age = now.year - pickedDate.year -
          ((now.month < pickedDate.month ||
              (now.month == pickedDate.month && now.day < pickedDate.day))
              ? 1
              : 0);

      if (age >= 18) {
        setState(() {
          _bornDate = pickedDate;
          buttonMsg = "Fecha de nacimiento: ${_dateConverter(pickedDate)}";
        });
      } else {
        showMesg("Debes ser mayor de edad para registrarte");
      }
    }
  }

  String _dateConverter(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String dateFormatted = formatter.format(date);
    return dateFormatted;
  }
}

extension on String {
  bool isvalidEmail() {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(this);
  }
}
