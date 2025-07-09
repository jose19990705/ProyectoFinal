import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laboratorio_3/pages/repository/firebase_api.dart';
import 'package:laboratorio_3/pages/sign_in_Page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  late Future<List<Map<String, dynamic>>> _lowRatedRestaurantsFuture; //los restaurantes con baja caliicacion
  late Future<List<Map<String, dynamic>>> _inappropriateEventsFuture; // descripcion con palabras indebidas
  late Future<DocumentSnapshot<Map<String, dynamic>>> _adminProfileFuture;
  final List<String> badWords = ['hp', 'marica', 'puta', 'estupido']; // palabras inapropiadas para castigar
  @override
  void initState() {
    super.initState();
    _lowRatedRestaurantsFuture = _getLowRatedRestaurants();
    _inappropriateEventsFuture = _getInappropriateEvents();
    _adminProfileFuture = _getAdminProfile();
  }

  Future<List<Map<String, dynamic>>> _getLowRatedRestaurants() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Negociante')
        .orderBy('rating')
        .limit(10)
        .get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      data['docId'] = doc.id;
      return data;
    }).toList();
  }

  Future<List<Map<String, dynamic>>> _getInappropriateEvents() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('Events').get();
    return querySnapshot.docs
        .where((doc) {
      final data = doc.data();
      final text = (data['nameEvent'] ?? '') + (data['description'] ?? '');
      return badWords.any((word) => text.toLowerCase().contains(word));
    })
        .map((doc) => {
      ...doc.data(),
      'docId': doc.id,
      'uid': doc['uid'],
    })
        .toList();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _getAdminProfile() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance.collection('Administradores').doc(uid).get();
  }

  void _deleteUser(String uid) async {
    final userDoc = await FirebaseFirestore.instance.collection('Negociante').doc(uid).get();
    if (userDoc.exists) {
      await FirebaseFirestore.instance.collection('Negociante').doc(uid).delete();
    }

    setState(() {
      _inappropriateEventsFuture = _getInappropriateEvents();
    });
  }

  Widget _buildSectionCard(String title, List<Widget> children) {
    return Card(
      color: Colors.white.withOpacity(0.85),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 6),
            if (children.isEmpty)
              const Text("No hay datos disponibles", style: TextStyle(color: Colors.black87))
            else
              Column(children: children),
          ],
        ),
      ),
    );
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
            child: ListView(
              children: [
                const SizedBox(height: 50),
                FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: _adminProfileFuture,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final data = snapshot.data!.data()!;
                    return Column(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: data['urlPicture'] != null
                              ? NetworkImage(data['urlPicture'])
                              : const AssetImage('assets/images/F_ARD.png') as ImageProvider,
                        ),
                        const SizedBox(height: 20),
                        Text("Administrador: ${data['name'] ?? 'Sin nombre'}",
                            style: const TextStyle(color: Colors.white, fontSize: 20)),
                        Text("Teléfono: ${data['cellphone'] ?? 'N/A'}",
                            style: const TextStyle(color: Colors.white, fontSize: 18)),
                        const SizedBox(height: 20),
                      ],
                    );
                  },
                ),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _lowRatedRestaurantsFuture,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final restaurants = snapshot.data!;
                    return _buildSectionCard(
                      "Restaurantes peor calificados",
                      restaurants
                          .map((r) => ListTile(
                        title: Text(r['name'] ?? 'Sin nombre'),
                        subtitle: Text("Calificación: ${r['rating'] ?? 'N/A'}"),
                      ))
                          .toList(),
                    );
                  },
                ),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _inappropriateEventsFuture,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final events = snapshot.data!;
                    return _buildSectionCard(
                      "Eventos con palabras inadecuadas",
                      events
                          .map((event) => ListTile(
                        title: Text(event['nameEvent'] ?? 'Sin título'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Publicado por: ${event['organizer'] ?? 'Desconocido'}"),
                            Text(event['description'] ?? ''),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteUser(event['uid']),
                        ),
                      ))
                          .toList(),
                    );
                  },
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: _onSignOutButtonClicked,
                    child: const Text("Cerrar sesión"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onSignOutButtonClicked() {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInPage()),
    );
  }
}