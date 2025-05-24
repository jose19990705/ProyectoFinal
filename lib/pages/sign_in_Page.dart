import 'package:flutter/material.dart';
import 'package:laboratorio_3/pages/repository/firebase_api_Registers.dart';
import 'package:laboratorio_3/pages/sign_up_Page.dart';
class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _oscuro = true;
  final FirebaseApiRegisters _firebaseApi = FirebaseApiRegisters();

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
                Image.asset('assets/images/logo.jpg', width: 150, height: 150),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                    labelText: "correo electrónico",
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
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
                    labelText: "Contraseña",
                  ),
                  keyboardType: TextInputType.visiblePassword,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _onsignInButtonClicked,
                  child: const Text("Iniciar sesión"),
                ),
                const SizedBox(height: 16),

                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpPage(),
                      ),
                    );
                  },
                  child: const Text('Registrarse'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.blue,
                    ),
                  ),
                  onPressed: null,
                      //() {
                   // Navigator.push(
                   //   context,
                   //   MaterialPageRoute(
                   //     builder: (context) => const RecoveryPasswordPage(),
                   //   ),
                  //  );
                //  },
                  child: const Text('¿olvidaste tu contraseña?'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onsignInButtonClicked() async {
    if (_email.text.isEmpty || _password.text.isEmpty) {
      showMesg("Todos los campos deben estar diligenciados");
    } else {
      var result = await _firebaseApi.signInUser(_email.text, _password.text);
      if (result == 'invalid-credential') {
        showMesg("Correo electronico o contraseña incorrecta");
      } else if (result == 'invalid-email') {
        showMesg('El correo electronico esta mal escrito');
      } else if (result == 'network-request-failed') {
        showMesg('Revise su conexión a internet');
      } else {
        showMesg("Bienvenido");
      //  Navigator.pushReplacement(
      //    context,
      //    MaterialPageRoute(builder: (context) => HomeNavigationBarPage()),
      //  );
      }
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
}
