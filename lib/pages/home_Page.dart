import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laboratorio_3/pages/new_event_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Stack(
        children: [
          Positioned.fill(//imagen de fondo
            child: Image.asset(
              'assets/images/C_p.png',
              fit: BoxFit.cover, //para ajustar la imagen
            ),
          ), //Fondo
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: _addButtonClicked,
        child: const Icon(Icons.add_card),
      ),
    );
  }
  void _addButtonClicked(){
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const NewEventPage())
    );
  }
}
