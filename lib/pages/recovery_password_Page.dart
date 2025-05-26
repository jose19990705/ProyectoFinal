import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laboratorio_3/pages/repository/firebase_api.dart';

class RecoveryPasswordPage extends StatefulWidget {
  const RecoveryPasswordPage({super.key});

  @override
  State<RecoveryPasswordPage> createState() => _RecoveryPasswordPageState();
}

class _RecoveryPasswordPageState extends State<RecoveryPasswordPage> {
  final _email = TextEditingController();

  final FirebaseApi _firebaseApi = FirebaseApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage("assets/images/MEDEX.png"),
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                    labelText: "Correo electronico",
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                    onPressed: (){
                      if(_email.text.isEmpty){
                        _showMsg("Debe digitar un correo electronico");
                      }else{
                        _firebaseApi.recoveryPassword(_email.text);
                        _showMsg("Revise su correo electronico");
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Recuperar contraseña")
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMsg(String msg){
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
