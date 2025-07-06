import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailEventPage extends StatefulWidget {

  final QueryDocumentSnapshot event;

  const DetailEventPage( this.event, {super.key});

  @override
  State<DetailEventPage> createState() => _DetailEventPageState(event);
}

class _DetailEventPageState extends State<DetailEventPage> {
  final QueryDocumentSnapshot event;
  _DetailEventPageState(this.event);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(event['nameEvent']),),
      body: Stack(
        children: [
          Positioned.fill(//imagen de fondo
            child: Image.asset(
              'assets/images/F_D.png',
              fit: BoxFit.cover, //para ajustar la imagen
            ),
          ), //Fondo
          Padding(
              padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(event['urlImage']),
                      //  image: AssetImage('assets/images/Ina.png'),
                      
                        //fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(height: 8.0,),
                  Text("${event['nameEvent']}",style: TextStyle(fontSize: 30,color:Colors.white),),
                  SizedBox(height: 8.0,),
                  Text("Costo: \$ ${event['cost']}",style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic,color:Colors.white),),
                  SizedBox(height: 8.0,),
                  Text("Lugar: ${event['location']}",style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic,color:Colors.white),),
                  SizedBox(height: 8.0,),
                  Text("Fecha: ${_dateConverter(event['initialDate'])}",style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic,color:Colors.white),),
                  SizedBox(height: 8.0,),
                  Text("Hora de inicio: ${event['startTime']}",style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic,color:Colors.white),),
                  SizedBox(height: 8.0,),
                  Text("Hora de finalización: ${event['endTime']}",style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic,color:Colors.white),),
                  SizedBox(height: 8.0,),
                  Text("Descripcion:                                                      ",style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic,color:Colors.white),),
                  SizedBox(height: 8.0,),
                  Text(" ${event['description']}",style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic,color:Colors.white),textAlign: TextAlign.justify,),
                  SizedBox(height: 500.0,),

                ],

              ),
            ),
          )
        ],
      ),

    );
  }
  String _dateConverter(Timestamp date){
    DateTime dateTime = date.toDate();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String dateFormatted = formatter.format(dateTime);
    return dateFormatted;
  }
}
