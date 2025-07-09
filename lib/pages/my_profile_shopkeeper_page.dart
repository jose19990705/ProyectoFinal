// Este archivo es la página del perfil de los negociantes.

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:laboratorio_3/pages/repository/firebase_api.dart';
import 'package:laboratorio_3/pages/repository/firebase_api_get_data_shoopkeeper.dart';
import 'package:laboratorio_3/pages/sign_in_Page.dart';
import 'package:laboratorio_3/pages/new_Food_Page.dart';

class MyProfileShopkeeperPage extends StatefulWidget {
  const MyProfileShopkeeperPage({super.key});

  @override
  State<MyProfileShopkeeperPage> createState() => _MyProfileShopkeeperPageState();
}

class _MyProfileShopkeeperPageState extends State<MyProfileShopkeeperPage> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> _profileFuture;
  late Future<List<Map<String, dynamic>>> _foodListFuture;

  @override
  void initState() {
    super.initState();
    final service = FirebaseApiGetDataShopkeeper();
    _profileFuture = service.getCurrentShopkeeperData();
    _foodListFuture = service.getFoodsFromShopkeeper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/Fondo_home.png',
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

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(
                    child: Text(
                      "No se encontraron los datos del perfil",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  );
                }

                final data = snapshot.data!.data()!;
                final name = data['name'] ?? 'Sin nombre';
                final description = data['businessDescription'] ?? 'Sin descripción';
                final service = data['productsService'] ?? 'Sin servicio';
                final rating = (data['rating'] ?? 0).toDouble();

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 50),
                      Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('assets/images/JCH.png'),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          "Nombre: $name",
                          style: const TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      Center(
                        child: Text(
                          "Descripción: $description",
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                      Center(
                        child: Text(
                          "Servicio: $service",
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                      Center(
                        child: Text(
                          "Rating general: ${rating.toStringAsFixed(1)} ⭐",
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Platos:",
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: _foodListFuture,
                        builder: (context, foodSnapshot) {
                          if (foodSnapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          if (foodSnapshot.hasError) {
                            return const Text(
                              "Error al cargar los platos",
                              style: TextStyle(color: Colors.white),
                            );
                          }

                          final foods = foodSnapshot.data ?? [];

                          if (foods.isEmpty) {
                            return const Text(
                              "No hay platos registrados",
                              style: TextStyle(color: Colors.white),
                            );
                          }

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: foods.length,
                            itemBuilder: (context, index) {
                              final food = foods[index];
                              final foodRating = (food['rating'] ?? 0).toDouble();

                              return Card(
                                color: Colors.white70,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      margin: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          food['imagenUrl'] ?? food['urlImage'] ?? '',
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return const Icon(Icons.broken_image, size: 50);
                                          },
                                          loadingBuilder: (context, child, progress) {
                                            if (progress == null) return child;
                                            return const Center(child: CircularProgressIndicator());
                                          },
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              food['nombre'] ?? 'Sin nombre',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text("Precio: ${food['precio'] ?? '---'}"),
                                            Text("Descripción: ${food['descripcion'] ?? ''}"),
                                            Text("Rating: ${foodRating.toStringAsFixed(1)} ⭐"),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: _onTasteButtonClicked,
                          child: const Text('Agregar plato'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: ElevatedButton(
                          onPressed: _onSignOutButtonClicked,
                          child: const Text("Cerrar sesión"),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onSignOutButtonClicked() {
    FirebaseApi().signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInPage()),
    );
  }

  void _onTasteButtonClicked() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewFoodPage()),
    );
  }
}
