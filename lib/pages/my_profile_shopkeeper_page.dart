//Este archivo, es la página de los negociantes. 

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:laboratorio_3/pages/repository/firebase_api.dart';
import 'package:laboratorio_3/pages/repository/firebase_api_get_data_shoopkeeper.dart';
import 'package:laboratorio_3/pages/sign_in_Page.dart';

class MyProfileShopkeeperPage extends StatefulWidget {
  const MyProfileShopkeeperPage({super.key});

  @override
  State<MyProfileShopkeeperPage> createState() => _MyProfileShopkeeperPageState();
}

class _MyProfileShopkeeperPageState extends State<MyProfileShopkeeperPage> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> _profileFuture;
  late Future<List<Map<String, dynamic>>> _foodListFuture;

  @override
  @override
  void initState() {
    super.initState();
    final service = FirebaseApiGetDataShopkeeper();
    _profileFuture = service.getCurrentShopkeeperData();
    _foodListFuture = service.getFoodsFromShopkeeper();
  }


  Future<List<Map<String, dynamic>>> _getFoods(String uid) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Negociante')
        .doc(uid)
        .collection('Food')
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/C_porfile.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: _profileFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  // Documento no encontrado: solo mostrar botón de cerrar sesión
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("No se encontraron los datos del perfil", style: TextStyle(color: Colors.white, fontSize: 18)),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: _onSignOutButtonClicked,
                          child: const Text("Cerrar sesión"),
                        ),
                      ),
                    ],
                  );
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text('No se encontraron datos del usuario.', style: TextStyle(color: Colors.white)));
                }

                final data = snapshot.data!.data()!;

                final name = data['name'] ?? 'No name';
                final description = data['businessDescription'] ?? 'No description';
                final service = data['productsService'] ?? 'No service';

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    Text("Nombre: $name", style: const TextStyle(color: Colors.white, fontSize: 20)),
                    Text("Descripción: $description", style: const TextStyle(color: Colors.white, fontSize: 18)),
                    Text("Servicio: $service", style: const TextStyle(color: Colors.white, fontSize: 18)),
                    const SizedBox(height: 20),
                    const Text("Platos:", style: TextStyle(color: Colors.white, fontSize: 22)),
                    Expanded(
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: _foodListFuture,
                        builder: (context, foodSnapshot) {
                          if (!foodSnapshot.hasData) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          final foods = foodSnapshot.data!;
                          if (foods.isEmpty) {
                            return const Text("No hay platos registrados", style: TextStyle(color: Colors.white));
                          }

                          return ListView.builder(
                            itemCount: foods.length,
                            itemBuilder: (context, index) {
                              final food = foods[index];
                              return Card(
                                color: Colors.white70,
                                child: ListTile(
                                  title: Text(food['nombre'] ?? 'Sin nombre'),
                                  subtitle: Text("Precio: ${food['precio'] ?? '---'}\nDescripción: ${food['descripcion'] ?? ''}"),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: _onSignOutButtonClicked,
                        child: const Text("Cerrar sesión"),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onSignOutButtonClicked() {
    FirebaseApi _firebaseApi = FirebaseApi();
    _firebaseApi.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInPage()),
    );
  }
}

