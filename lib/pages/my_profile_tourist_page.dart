import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:laboratorio_3/pages/repository/firebase_api_get_data_tourist.dart';
import 'package:laboratorio_3/pages/sign_in_Page.dart';

class MyProfileTouristPage extends StatefulWidget {
  const MyProfileTouristPage({super.key});

  @override
  State<MyProfileTouristPage> createState() => _MyProfileTouristPageState();
}

class _MyProfileTouristPageState extends State<MyProfileTouristPage> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = FirebaseApiGetDataTourist().getCurrentTouristData();
  }

  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return 'Sin fecha';
    final date = timestamp.toDate();
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Widget _buildInfoCard(String title, List<String> items) {
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
            if (items.isEmpty)
              const Text("Sin datos registrados", style: TextStyle(color: Colors.black87))
            else
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: items
                    .map((item) => Chip(
                  label: Text(item),
                  backgroundColor: Colors.blue.shade100,
                  labelStyle: const TextStyle(color: Colors.black),
                ))
                    .toList(),
              )
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
            child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: _profileFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("No se encontraron los datos del perfil",
                          style: TextStyle(color: Colors.white, fontSize: 18)),
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
                  return Center(
                      child: Text('Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.white)));
                }

                final data = snapshot.data!.data()!;
                final name = data['name'] ?? 'Sin nombre';
                final bornDate = _formatDate(data['bornDate']);
                final foodTastes = List<String>.from(data['foodTastes'] ?? []);
                final placeTastes = List<String>.from(data['placeTates'] ?? []);

                return ListView(
                  children: [
                    const SizedBox(height: 50),
                    const Center(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage('assets/images/default_profile.jpg'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text("Nombre: $name",
                        style: const TextStyle(color: Colors.white, fontSize: 20)),
                    Text("Fecha de nacimiento: $bornDate",
                        style: const TextStyle(color: Colors.white, fontSize: 18)),
                    const SizedBox(height: 20),
                    _buildInfoCard("Gustos de comida", foodTastes),
                    _buildInfoCard("Lugares favoritos", placeTastes),
                    const SizedBox(height: 30),
                    Center(
                      child: ElevatedButton(
                        onPressed: _onSignOutButtonClicked,
                        child: const Text("Cerrar sesión"),
                      ),
                    ),
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
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInPage()),
    );
  }
}
