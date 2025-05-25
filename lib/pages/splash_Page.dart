import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laboratorio_3/pages/intro.dart';
import 'package:laboratorio_3/pages/repository/firebase_api.dart';
import 'package:laboratorio_3/pages/sign_in_Page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final FirebaseApi _firebaseApi = FirebaseApi();
  @override
  void initState() {
    _closeSplash();
    super.initState();
  }
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Stack(
        children: [
          Positioned.fill(//imagen de fondo
            child: Image.asset(
              'assets/images/Med_Map.png',
              fit: BoxFit.cover, //para ajustar la imagen
            ),
          ),
          Center(
            child: Image(
              image: AssetImage("assets/images/S.png"),
              width: 300,
              height: 300,
            ),
          ),
        ],
      ),
    );
  }
  Future<void> _closeSplash() async{
    Future.delayed(const Duration(seconds: 2),() async{
      var result = _firebaseApi.validateSesion();
      if(await result) { // si se cumple es porque no hay nadie logeado
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Intro()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Intro()));
      }
    });
  }
}
