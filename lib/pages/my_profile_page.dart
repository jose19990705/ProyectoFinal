import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laboratorio_3/pages/repository/firebase_api.dart';
import 'package:laboratorio_3/pages/sign_in_Page.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(//imagen de fondo
            child: Image.asset(
              'assets/images/C_porfile.jpg',
              fit: BoxFit.cover, //para ajustar la imagen
            ),
          ), //Fondo
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("MyProfile",style: TextStyle(color: Colors.white),),
                ElevatedButton(
                  onPressed: _onSignOutButtonClicked,
                  child: const Text("Cerrar sesión"),
                )
              ],
            ),
          ),
        ],
      ),

    );
  }
  void _onSignOutButtonClicked(){
    FirebaseApi _firebaseApi =FirebaseApi();
    _firebaseApi.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInPage()),
    );
  }
}
