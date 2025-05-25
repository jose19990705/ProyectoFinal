import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laboratorio_3/pages/admin_r_confirmado.dart';
import 'package:laboratorio_3/pages/repository/firebase_api.dart';

import 'home_Navigation_Bar_Page.dart';

class AdminReegister extends StatefulWidget {
  const AdminReegister({super.key});

  @override
  State<AdminReegister> createState() => _AdminReegisterState();
}

class _AdminReegisterState extends State<AdminReegister> {
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
              'assets/images/F_AR.png',
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
                    const SizedBox(height: 550),
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
                        child: const Text("Acceder")
                    ), // acceso del administrador
                    const SizedBox(height: 20),

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
            context, MaterialPageRoute(builder: (context) => AdminRConfirmado()));
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