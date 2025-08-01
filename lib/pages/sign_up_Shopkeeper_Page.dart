import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:laboratorio_3/pages/repository/firebase_api_Register_Tourist_And_shopkeeper.dart';
import 'package:laboratorio_3/pages/sign_in_Page.dart';
import 'package:laboratorio_3/models/shopkeeper.dart';


class SignUpShopkeeperPage extends StatefulWidget {
  const SignUpShopkeeperPage({super.key});

  @override
  State<SignUpShopkeeperPage> createState() => _SignUpShopkeeperPageState();
}

class _SignUpShopkeeperPageState extends State<SignUpShopkeeperPage> {


  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _servicesController = TextEditingController();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _RegPassword = TextEditingController();
  final _firebaseApiRegisterTurista = FirebaseApiRegisterTouristAndShopkeeper();

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
              'assets/images/R_E.png',
              fit: BoxFit.cover, //para ajustar la imagen
            ),
          ), //Fondo
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
                    const SizedBox(height: 1),
                    TextField(
                      controller: _name,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Nombre",
                        prefixIcon: Icon(Icons.person,color: Colors.white,),
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white,width: 2.0)
                        )

                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: _email,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Correo electrónico",
                        prefixIcon: Icon(Icons.mail,color: Colors.white,),
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white,width: 2.0)
                        )

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
                      style: const TextStyle(color: Colors.white),
                      controller: _password,
                      obscureText: _oscuro,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock,color: Colors.white,),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _oscuro ? Icons.visibility_off : Icons.visibility,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _oscuro = !_oscuro;
                            });
                          },
                        ),
                        labelText: "Password",
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white,width: 2.0)
                        )

                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: _RegPassword,
                      obscureText: _isRegPasswordoscuro,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock,color: Colors.white,),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isRegPasswordoscuro
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isRegPasswordoscuro = !_isRegPasswordoscuro;
                            });
                          },
                        ),
                        labelText: " repita la contraseña",
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white,width: 2.0)
                        )
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    Column(
                      children: [
                        const SizedBox(height: 16),
                        const Text(
                            "¿Cuéntanos una breve descripción de tu negocio?",
                            style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _descriptionController,
                          maxLines: 3,
                          style: TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Ej. Restaurante especializado en comida italiana...',
                            hintStyle: const TextStyle(color: Colors.white70), // hint blanco semiopaco
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white), // borde blanco cuando no está enfocado
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white, width: 2), // borde blanco más grueso al enfocar
                            ),

                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text("¿Qué servicios ofrece?",style: TextStyle(color: Colors.white),),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _servicesController,
                          maxLines: 2,
                          style: TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Ej. Domicilios, Eventos, temáticas',
                            hintStyle: const TextStyle(color: Colors.white70), // hint blanco semiopaco
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white), // borde blanco cuando no está enfocado
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white, width: 2), // borde blanco más grueso al enfocar
                            ),
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
        ],
      ),

    );
  }

  void _onRegisterButtonClicked() {
    if (_email.text.isEmpty ||
        _password.text.isEmpty ||
        _RegPassword.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _servicesController.text.isEmpty) {
      showMesg("Todos los campos deben estar diligenciados");
    } else if (_password.text != _RegPassword.text) {
      showMesg("Las contraseñas deben ser iguales");
    } else if (_password.text.length < 6) {
      showMesg("La contraseña no puede tener menos de 6 caracteres");
    } else {
      creatUserNegociante(_email.text, _password.text, _descriptionController.text,
          _servicesController.text);
    }
  }


  void creatUserNegociante(String email, String password, String descrption,
      String Services) async {
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
      var _shokeeper = Shopkeeper(result, _name.text, _email.text, _bornDate,
          _descriptionController.text, _servicesController.text, "Empresa",0);

      creatUserInDB(_shokeeper);
    }
  }

  Future<void> creatUserInDB(Shopkeeper user) async {
    var result = await _firebaseApiRegisterTurista.creatShopkeeperIDB(user);

    if (result == 'network-request-failed') {
      showMesg('Revise su conexión a internet');
    } else {
      showMesg("Usuario registrado exitosamente");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SignInPage()));
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
