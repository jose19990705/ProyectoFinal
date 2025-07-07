import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:laboratorio_3/pages/rating_Manager.dart';
class RestaurantPage extends StatefulWidget {
  const RestaurantPage({super.key});

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  late Future<List<Map<String, dynamic>>> _recommendations;

  @override
  void initState() {
    super.initState();
    _recommendations = _loadRecommendedFoods();
  }

  Future<List<Map<String, dynamic>>> _loadRecommendedFoods() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return [];

    final turistaDoc = await FirebaseFirestore.instance.collection('Turistas').doc(uid).get();
    final gustos = List<String>.from(turistaDoc.data()?['foodTastes'] ?? []);

    if (gustos.isEmpty) return [];

    final comerciantesSnapshot = await FirebaseFirestore.instance.collection('Negociante').get();
    List<Map<String, dynamic>> resultados = [];

    for (var comerciante in comerciantesSnapshot.docs) {
      final comercianteData = comerciante.data();
      final comercianteName = comercianteData['name'] ?? 'Comerciante';
      final comercianteDesc = comercianteData['businessDescription'] ?? '';

      final foodSnapshot = await comerciante.reference.collection('Food').get();
      for (var foodDoc in foodSnapshot.docs) {
        final foodData = foodDoc.data();
        final categoria = foodData['categoria'];

        if (categoria != null && gustos.contains(categoria)) {
          resultados.add({
            'id': foodDoc.id,
            'nombre': foodData['nombre'],
            'descripcion': foodData['descripcion'],
            'precio': foodData['precio'],
            'categoria': foodData['categoria'],
            'rating': foodData['rating'] ?? 0.0,
            'comerciante': comercianteName,
            'descripcionNegocio': comercianteDesc,
            'comercianteId': comerciante.id,
          });
        }
      }
    }

    return resultados;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Comida que te puede gustar")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _recommendations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final datos = snapshot.data ?? [];

          if (datos.isEmpty) {
            return const Center(child: Text("No hay platos que coincidan con tus gustos."));
          }

          return ListView.builder(
            itemCount: datos.length,
            itemBuilder: (context, index) {
              final food = datos[index];
              return Card(
                margin: const EdgeInsets.all(12),
                color: Colors.orange.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(food['nombre'] ?? '',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text("Precio: ${food['precio'] ?? '---'}", style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Text(food['descripcion'] ?? '', style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Text("Rating actual: ${food['rating']?.toStringAsFixed(1) ?? '0'} ⭐"),
                      const SizedBox(height: 8),
                      const Text("¡Califica este plato!"),
                      RatingBar.builder(
                        initialRating: (food['rating'] ?? 0).toDouble(),
                        minRating: 1,
                        itemCount: 5,
                        allowHalfRating: false,
                        itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                        onRatingUpdate: (rating) async {
                          final ratingManager = RatingManager();
                          await ratingManager.rateFood(
                            comercianteId: food['comercianteId'],
                            foodDocId: food['id'],
                            userId: FirebaseAuth.instance.currentUser!.uid,
                            rating: rating,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("¡Gracias por calificar!")),
                          );
                          setState(() {
                            _recommendations = _loadRecommendedFoods();
                          });
                        },
                      ),
                      const Divider(height: 20),
                      Text("Negocio: ${food['comerciante']}",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      Text(food['descripcionNegocio'] ?? '', style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
