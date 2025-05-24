import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laboratorio_3/pages/repository/firebase_api_Registers.dart';
import 'package:laboratorio_3/pages/sign_in_Page.dart';
import '../models/users.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

enum type_reg {tourist,business}
//enum ProductsService {}
String? _selectedComida;
String? _selectedLugar;
final TextEditingController _serviciosController = TextEditingController();

final List<String> comidas = ['Comida china', 'Comida italiana', 'Comida colombiana'];
final List<String> lugares = ['Discotecas', 'Eco parques', 'Museos'];

class _SignUpPageState extends State<SignUpPage> {
  type_reg? _typeReg = type_reg.tourist;

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _RegPassword = TextEditingController();

  final FirebaseApiRegisters _firebaseApi = FirebaseApiRegisters();
  bool _isRegPasswordoscuro = true;
  bool _oscuro = true;

  String buttonMsg = "Fecha de nacimiento";

  DateTime _bornDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage('assets/images/logo.jpg'),
                  width: 150,
                  height: 150,
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
                const Text("Seleccione tipo de registro"),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile(
                        title: const Text("Turista"),
                        value: type_reg.tourist,
                        groupValue: _typeReg,
                        onChanged: (type_reg? value) {
                          setState(() {
                            _typeReg = value;
                          });
                        },
                      ),
                    ),

                    Expanded(
                      child: RadioListTile(
                        title: const Text("Negocio"),
                        value: type_reg.business,
                        groupValue: _typeReg,
                        onChanged: (type_reg? value) {
                          setState(() {
                            _typeReg = value;
                          });
                        },
                      ),
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
    );
  }

  void _onRegisterButtonClicked() {
    if (_email.text.isEmpty ||
        _password.text.isEmpty ||
        _RegPassword.text.isEmpty) {
      showMesg("Todos los campos deben estar diligenciados");
    } else if (_password.text != _RegPassword.text) {
      showMesg("Las contraseñas deben ser iguales");
    } else if (_password.text.length < 6) {
      showMesg("La contraseña no puede tener menos de 6 caracteres");
    } else {
      creatUser(_email.text, _password.text);
    }
  }

  void creatUser(String email, String password) async {
    var result = await _firebaseApi.createUser(email, password);
    if (result == 'weak-password') {
      showMesg("La contraseña debe tener al menos 6 dígitos");
    } else if (result == 'email-already-in-use') {
      showMesg('Ya existe una cuenta asociada con este correo electronico');
    } else if (result == 'invalid-email') {
      showMesg('El correo electronico esta mal escrito');
    } else if (result == 'network-request-failed') {
      showMesg('Revise su conexión a internet');
    } else {
      var genre= (_typeReg==type_reg.tourist)? "Turista":"Negocio";
      var _user = User(result, _name.text, _email.text, genre, _bornDate, "");

      creatUserInDB(_user);
    }
  }

  Future<void> creatUserInDB(User user) async {
    var result = await _firebaseApi.creatUserIDB(user);

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
    final DateTime? newdate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1925, 1),
      lastDate: DateTime.now(),
      helpText: "Fecha de nacimiento",
    );
    if (newdate != null) {
      setState(() {
        _bornDate = newdate;
        buttonMsg = "Fecha de nacimiento: ${_dateConverter(newdate)}";
      });
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
