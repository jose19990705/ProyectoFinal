import 'package:cloud_firestore/cloud_firestore.dart';
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
              'assets/images/Med_Map.png',
              fit: BoxFit.cover, //para ajustar la imagen
            ),
          ), //Fondo
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("Events").snapshots(),
              builder: (context, snapshot) {
                if(!snapshot.hasData) return Text("loading...");

                return ListView.builder(
                    itemCount: snapshot.data?.docs.length,//cuantos son los datos que se van a procesar
                    itemBuilder: (context, index){
                      QueryDocumentSnapshot event =snapshot.data!.docs[index];
                      return buildCard(event);
                    },
                );
              }
          )

        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: _addButtonClicked,
        child: const Icon(Icons.add_card),
      ),
    );
  }
  InkWell buildCard(QueryDocumentSnapshot event){
    return InkWell(
      onTap: null, //para un click
      onLongPress: null, //para un click sostenido
      child: Card(
        elevation: 4.0,
        color: Colors.black26,
        child: Column(
          children:[
            ListTile(
              title: Text(event['nameEvent']),
              titleTextStyle: TextStyle(color: Colors.white),
              subtitle: Text(event['category']),
              subtitleTextStyle: TextStyle(color: Colors.white),

            ),

            Container(
              height: 200.0,
              width: 500.0,

              child: Ink.image(
                image: AssetImage('assets/images/Ina.png'),
              ),
            ),
            SizedBox(height: 8.0,)
          ],
        ),
      ),


    );
  }
  void _addButtonClicked(){
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const NewEventPage())
    );
  }
}
