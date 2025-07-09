
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:laboratorio_3/pages/repository/firebase_api.dart';

import '../models/event.dart';



class NewEventPage extends StatefulWidget {
  const NewEventPage({super.key});

  @override
  State<NewEventPage> createState() => _NewEventPageState();
}

class _NewEventPageState extends State<NewEventPage> {

  final FirebaseApi _firebaseApi = FirebaseApi();

  final _id = TextEditingController();
  final _organizador = TextEditingController();
  final _evento = TextEditingController();
  var _categoria = null;
  final _horainicial = TextEditingController();
  final _horafinal = TextEditingController();
  final _costo = TextEditingController();
  final _urlimage = TextEditingController();
  final _ubicacion = TextEditingController();
  final TextEditingController _descripcion = TextEditingController();
  final _enlaceweb = TextEditingController();
  final _edades = TextEditingController();
  String buttonMsginit = "Fecha de inicio";
  DateTime _initialDate = DateTime.now();
  String buttonMsgfinal = "Fecha de terminación";
  DateTime _finalDate = DateTime.now();

  File? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nuevo Evento")),
      body: Stack(
        children: [
          Positioned.fill(//imagen de fondo
            child: Image.asset(
              'assets/images/R_Ev.png',
              fit: BoxFit.cover, //para ajustar la imagen
            ),
          ), //Fondo
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: const BoxDecoration(color: Colors.transparent),
                        height: 170,
                        child: Stack(
                          children: [
                            image != null
                                ? Image.file(image!, width: 300, height: 200,)
                            : const Image(image: AssetImage("assets/images/MEDEX.png"), width: 200, height: 200,),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: IconButton(
                                  alignment: Alignment.bottomLeft,
                                  onPressed: () async{
                                    pickImage();
                                  },
                                  icon: const Icon(Icons.camera_alt, color: Colors.white,)
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16,), // espacio entre widgets
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: _organizador,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Organizador",
                            prefixIcon: Icon(Icons.person,color: Colors.white,),
                            labelStyle: const TextStyle(color: Colors.white),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white,width: 2.0)
                            )

                        ),
                        keyboardType: TextInputType.name,
                      ), // organizador
                      SizedBox(height: 16,), // espacio entre widgets
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: _evento,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Evento",
                            prefixIcon: Icon(Icons.star,color: Colors.white,),
                            labelStyle: const TextStyle(color: Colors.white),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white,width: 2.0)
                            )

                        ),
                        keyboardType: TextInputType.name,
                      ),// Evento
                      SizedBox(height: 16,), // espacio entre widgets
                      DropdownMenu(
                        label: const Text('Seeleccione una categoria'),
                        helperText: 'Seleccione el tipo de categoria a la que pertenece el evento',
                        width: 500,
                        enableSearch: false,
                        onSelected: (login){
                          if(login != null){
                            setState(() {
                              _categoria = login;
                            });
                          }
                        },
                        dropdownMenuEntries: <DropdownMenuEntry<String>>[
                          DropdownMenuEntry(value: 'Culturales', label: 'Culturales'),
                          DropdownMenuEntry(value: 'Deportivo', label: 'Deportivo'),
                          DropdownMenuEntry(value: 'Educativos', label: 'Educativos'),
                          DropdownMenuEntry(value: 'Corporativos', label: 'Corporativos'),
                          DropdownMenuEntry(value: 'Comunitarios', label: 'Comunitarios'),
                          DropdownMenuEntry(value: 'Educativos', label: 'Educativos'),
                          DropdownMenuEntry(value: 'Religiosos', label: 'Religiosos'),
                          DropdownMenuEntry(value: 'Políticos', label: 'Políticos'),
                          DropdownMenuEntry(value: 'Entretenimiento', label: 'Entretenimiento'),
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
                      ), // Selección de categoria
                      SizedBox(height: 16,), // espacio entre widgets
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: _horainicial,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Hora inicial",
                            prefixIcon: Icon(Icons.watch_later_outlined,color: Colors.white,),
                            labelStyle: const TextStyle(color: Colors.white),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white,width: 2.0)
                            )

                        ),
                        keyboardType: TextInputType.number,
                      ),// Hora de inicio
                      SizedBox(height: 16,), // espacio entre widgets
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: _horafinal,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Hora final",
                            prefixIcon: Icon(Icons.watch_later_outlined,color: Colors.white,),
                            labelStyle: const TextStyle(color: Colors.white),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white,width: 2.0)
                            )

                        ),
                        keyboardType: TextInputType.number,
                      ), // Hora final
                      SizedBox(height: 16,), // espacio entre widgets
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: _costo,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Costo relativo",
                            prefixIcon: Icon(Icons.money,color: Colors.white,),
                            labelStyle: const TextStyle(color: Colors.white),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white,width: 2.0)
                            )

                        ), //
                        keyboardType: TextInputType.number,
                      ), //Costo
                      SizedBox(height: 16,), // espacio entre widgets
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: _urlimage,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "URL de la imagen del evento",
                            prefixIcon: Icon(Icons.image,color: Colors.white,),
                            labelStyle: const TextStyle(color: Colors.white),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white,width: 2.0)
                            )

                        ),
                        keyboardType: TextInputType.text,
                      ), // URL de la imagen
                      SizedBox(height: 16,), // espacio entre widgets
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: _ubicacion,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Ubicación del evento",
                            prefixIcon: Icon(Icons.map,color: Colors.white,),
                            labelStyle: const TextStyle(color: Colors.white),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white,width: 2.0)
                            )

                        ),
                        keyboardType: TextInputType.text,
                      ), // Ubicacion
                      SizedBox(height: 16,),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: _edades,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Mínima edad permitida",
                            prefixIcon: Icon(Icons.person,color: Colors.white,),
                            labelStyle: const TextStyle(color: Colors.white),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white,width: 2.0)
                            )

                        ), //
                        keyboardType: TextInputType.number,
                      ), //Edades
                      SizedBox(height: 16,), // Espacio entre widgets
                      const Text("Descripción del evento",style: TextStyle(color: Colors.white),),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _descripcion,
                        maxLines: 5,
                        style: TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Descripción del evento',
                          hintStyle: const TextStyle(color: Colors.white70), // hint blanco semiopaco
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white), // borde blanco cuando no está enfocado
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 2), // borde blanco más grueso al enfocar
                          ),
                        ),
                      ), // Descripción
                      SizedBox(height: 16,), // espacio entre widgets
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: _enlaceweb,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Enlace de la página Web",
                            prefixIcon: Icon(Icons.web,color: Colors.white,),
                            labelStyle: const TextStyle(color: Colors.white),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)
                            ),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white,width: 2.0)
                            )

                        ),
                        keyboardType: TextInputType.url,
                      ), //Pagina web
                      SizedBox(height: 16,), // espacio entre widgets
                      ElevatedButton(
                        onPressed: () {
                          _showSelectedDate();
                        },
                        child: Text(buttonMsginit),
                      ),//fecha inicial
                      SizedBox(height: 16,), // espacio entre widgets
                      ElevatedButton(
                        onPressed: () {
                          _showSelectedDatefinal();
                        },
                        child: Text(buttonMsgfinal),
                      ),//fecha final
                      SizedBox(height: 16,),
                      ElevatedButton(
                          onPressed: _saveEvent,
                          child: const Text("Guardar Evento")
                      ), //registro
                    ],
                  ),
                ),
              ),
          ),

        ],
      ),


    );
  }
  void _saveEvent() async{

    var event = Event( "", _organizador.text, _evento.text, _categoria, _horainicial.text, _horafinal.text, _costo.text, _urlimage.text, _ubicacion.text, _descripcion.text, _enlaceweb.text, _edades.text, _initialDate, _finalDate, " ");
    var result = await _firebaseApi.createEventInDB(event);
    if(result == 'network-request-failed'){
      showMsg('Revise su conexion a internet');
    }else {
      showMsg("Evento guardado");
      //Navigator.pushReplacement(
          //context, MaterialPageRoute(builder: (context) => SignInPage())); //para que se devuelva al dominio
      Navigator.pop(context);
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
  }
  void _showSelectedDate()async{
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate:DateTime.now() , // es la fecha que se mostrara primero
      firstDate: DateTime(1925, 1), // es la primera fecha que se mostrara en el calendario (año, mes)
      lastDate: DateTime(3000, 1),
      helpText: "Fecha del evento",
    ); // en esa linea se queda esperando y se configura el calendario
    if (newDate != null){
      setState(() {
        _initialDate= newDate;
        buttonMsginit = "Fecha inicial del evento: ${_dateConverter(newDate)}";

      });//indica y guarda el valor de la fecha de nacimiento

    }
  }
  void _showSelectedDatefinal()async{
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate:DateTime.now() , // es la fecha que se mostrara primero
      firstDate: DateTime(1925, 1), // es la primera fecha que se mostrara en el calendario (año, mes)
      lastDate: DateTime(3000, 1),
      helpText: "Fecha de terminación del evento",
    ); // en esa linea se queda esperando y se configura el calendario
    if (newDate != null){
      setState(() {
        _finalDate= newDate;
        buttonMsgfinal = "Fecha final del evento: ${_dateConverter(newDate)}";

      });//indica y guarda el valor de la fecha de nacimiento

    }
  }
  String _dateConverter(DateTime date){
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String dateFormatted = formatter.format(date);
    return dateFormatted;
  }
  Future pickImage() async{
    try{
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image== null) return;
      final imageTemp= File(image.path);
      setState(() {
        this.image = imageTemp;
      });

    } on PlatformException catch(e){
      print('Failed to pick image: $e');
    }
  }
}
