import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laboratorio_3/pages/admin_reegister.dart';
import 'package:laboratorio_3/pages/recovery_password_Page.dart';
import 'package:laboratorio_3/pages/repository/firebase_api.dart' show FirebaseApi;
import 'package:laboratorio_3/pages/sign_up_Page.dart';
import 'package:laboratorio_3/pages/sign_up_Shopkeeper_Page.dart';
import 'package:laboratorio_3/pages/sign_up_Tourist_Page.dart';

import 'home_Navigation_Bar_Page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isPasswordObscure = true;
  final _email = TextEditingController();
  final _password = TextEditingController();
  var _usertype = null;

  final FirebaseApi _firebaseApi = FirebaseApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack(
        children: [
          Positioned.fill(//imagen de fondo
            child: Image.asset(
              'assets/images/F_SI.png',
              fit: BoxFit.cover, //para ajustar la imagen
            ),
          ), //Fondo
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 250),
                    const Image(
                      image: AssetImage("assets/images/MEDEX.png"),
                      width: 300,
                      height: 300,
                    ), // Logo
                    DropdownMenu(
                      label: const Text('Seeleccione una opción'),
                      helperText: 'Seleccione el tipo de cuenta con la que desea ingresar',
                      width: 500,
                      enableSearch: false,
                      onSelected: (login){
                        if(login != null){
                          setState(() {
                            _usertype = login;
                          });
                        }
                      },
                        dropdownMenuEntries: <DropdownMenuEntry<String>>[
                          DropdownMenuEntry(value: 'Turista', label: 'Turista'),
                          DropdownMenuEntry(value: 'Empresa', label: 'Empresa'),
                          DropdownMenuEntry(value: 'Administrador', label: 'Administrador'),
                        ],
                      textStyle: const TextStyle(color: Colors.white),
                      inputDecorationTheme: const InputDecorationTheme(
                        labelStyle: TextStyle(color: Colors.white),
                        helperStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        )
                      ),
                    ), // Selección de tipo de cuenta
                    const SizedBox(height: 20),
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: _email,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email, color: Colors.white,),
                        labelText: "Correo electronico",
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white,width: 2.0)
                        )

                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),// Correo electronico
                    const SizedBox(height: 20),
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: _password,
                      obscureText: _isPasswordObscure,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock, color: Colors.white),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordObscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordObscure = !_isPasswordObscure;
                            });
                          },
                        ),
                        labelText: "Contraseña",
                          labelStyle: const TextStyle(color: Colors.white),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)
                          ),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white,width: 2.0)
                          )
                      ),
                      keyboardType: TextInputType.visiblePassword,
                    ),// Contraseña
                    const SizedBox(height: 32),
                    ElevatedButton(
                        onPressed: _onSignInButtonClicked,
                        child: const Text("Iniciar sesión")
                    ), // Inicio de sesion
                    const SizedBox(height: 20),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      onPressed: (){
                        switch(_usertype){
                          case 'Turista':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpTouristPage(),
                              ),
                            );
                          case 'Empresa':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpShopkeeperPage(),
                              ),
                            );
                          case 'Administrador':
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AdminReegister(),
                              ),
                            );
                        }
                      },
                      child: const Text("Registrarse"),
                    ), // Registrarse
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.blue
                        ),
                      ),
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RecoveryPasswordPage(),
                          ),
                        );
                      },
                      child: const Text("Olvidaste tu contraseña"),
                    ),// Recuperacion de contraseña

                  ],
                ),
              ),
            ),
          ),
        ],
      ),

    );
  }
  void _onSignInButtonClicked() async{
    if(_email.text.isEmpty || _password.text.isEmpty ){// si todos los campos estan vacios
      showMsg("Debe digitar todos los campos");
    }else{
      var result = await _firebaseApi.singInUser(_email.text, _password.text);
      if (result == 'invalid_credentiall') {
        showMsg("Correo electronico o contraseña icorrecta");
      } else if (result == 'invalid-email') {
        showMsg("El correo electronico esta mal escrito");
      }else if (result == 'network-request-failed') {
        showMsg("Revise su conexion a internet");
      } else{
        showMsg("Bienvenido");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeNavigationBarPage()));
      }
    }
  }
  void showMsg(String msg){
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
        SnackBar(
          content: Text(msg),
          duration: Duration(seconds: 10),
          action: SnackBarAction(
              label: "Aceptar",
              onPressed: scaffold.hideCurrentSnackBar
          ),
        )
    );
  } // Funcion para que aparezca un texto con un boton que diga aceptar
}

