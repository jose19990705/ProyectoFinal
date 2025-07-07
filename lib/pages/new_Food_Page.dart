import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laboratorio_3/pages/home_Page.dart';
import 'package:laboratorio_3/pages/my_profile_shopkeeper_page.dart';
import 'package:laboratorio_3/pages/repository/firebase_api_Register_Tourist_And_shopkeeper.dart';

import '../models/food.dart';
import 'home_Navigation_Bar_Page.dart';

class NewFoodPage extends StatefulWidget {
  const NewFoodPage({super.key});

  @override
  State<NewFoodPage> createState() => _NewFoodPageState();
}

class _NewFoodPageState extends State<NewFoodPage> {
  final FirebaseApiRegisterTouristAndShopkeeper _firebaseApi =
  FirebaseApiRegisterTouristAndShopkeeper();
  final _nombre = TextEditingController();
  final _precio = TextEditingController();
  final _descripcion = TextEditingController();

  String _categoriaSeleccionada = 'Comida China';
  File? image;

  final List<String> _categorias = [
    'Comida Italiana',
    'Comida Mexicana',
    'Comida China',
    'Comida Colombiana',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nuevo Plato")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(color: Colors.white),
                height: 170,
                child: Stack(
                  children: [
                    image != null
                        ? Image.file(image!,
                        width: 150, height: 150, fit: BoxFit.cover)
                        : Image.asset("assets/images/logo.jpg",
                        width: 150, height: 150),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: pickImageFromCamera,
                        icon: const Icon(Icons.camera_alt),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nombre,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Nombre del plato",
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _precio,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Precio",
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _categoriaSeleccionada,
                items: _categorias.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _categoriaSeleccionada = value!;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Categoría",
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descripcion,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Descripción",
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _guardarPlato,
                child: const Text("Guardar Plato"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _guardarPlato() async {
    String picture = "";

    if (image != null) {
      final file = File(image!.path);
      final bytes = file.readAsBytesSync();
      picture = base64Encode(bytes);
    }

    final food = Food(
      null, // el ID lo generará Firestore
      _nombre.text,
      _precio.text,
      _categoriaSeleccionada,
      _descripcion.text,
      picture,
      0,
    );

    final result = await _firebaseApi.createFoodIDB(food);

    if (result == 'network-request-failed') {
      _mostrarMensaje("Error de red. Verifique su conexión.");
    } else {
      _mostrarMensaje("Plato guardado correctamente");
    Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => MyProfileShopkeeperPage()),
      );
    }
  }

  void _mostrarMensaje(String mensaje) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(mensaje),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: "Aceptar",
          onPressed: scaffold.hideCurrentSnackBar,
        ),
      ),
    );
  }

  Future pickImageFromCamera() async {
    try {
      final picked =
      await ImagePicker().pickImage(source: ImageSource.camera);
      if (picked == null) return;
      setState(() {
        image = File(picked.path);
      });
    } on PlatformException catch (e) {
      print("Error al seleccionar imagen: $e");
    }
  }
}
