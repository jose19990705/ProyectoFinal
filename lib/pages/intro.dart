import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laboratorio_3/pages/new_Food_Page.dart';
import 'package:laboratorio_3/pages/sign_in_Page.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();

}

class _IntroState extends State<Intro> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(

        children: [

          Positioned.fill(//imagen de fondo
            child: Image.asset(
              'assets/images/F_intro.png',
              fit: BoxFit.cover, //para ajustar la imagen
            ),
          ), //Fondo
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(
                          fontSize:30,
                          fontStyle: FontStyle.italic,
                          color: Colors.black
                      ),
                      backgroundColor: Color(0xFFFFD700), // Color oro
                      elevation: 20,
                    ),
                    onPressed: (){
                      _onRegisterButtonClicked();
                    },
                    child: const Text("Iniciar"),
                  ), // Boton para iniciar la app
                ],
              ),
            ),
          ),
        ],
      ),


    );
  }

  void _onRegisterButtonClicked(){
    Navigator.push(
      context,
      MaterialPageRoute(
        //builder: (context) => const SignInPage(),
        builder: (context) => const SignInPage(),
      ),
    );

  }
}
