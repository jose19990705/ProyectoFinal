import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:laboratorio_3/pages/home_Page.dart';
import 'package:laboratorio_3/pages/map_j.dart';
import 'package:laboratorio_3/pages/notifications_page.dart';
import 'package:laboratorio_3/pages/my_profile_shopkeeper_page.dart';
import 'package:laboratorio_3/pages/my_profile_tourist_page.dart';

class HomeNavigationBarPage extends StatefulWidget {
  const HomeNavigationBarPage({super.key});

  @override
  State<HomeNavigationBarPage> createState() => _HomeNavigationBarPageState();
}

class _HomeNavigationBarPageState extends State<HomeNavigationBarPage> {
  int _selectedIndex = 0;
  late Future<String> _userTypeFuture;

  @override
  void initState() {
    super.initState();
    _userTypeFuture = _getUserType();
  }

  Future<String> _getUserType() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    //En este bloque, se verifica si es un turista o un comerciante.
    final touristDoc =
        await FirebaseFirestore.instance.collection('Turistas').doc(uid).get();
    if (touristDoc.exists) {
      return 'Turista';
    }

    return 'Negociante';
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _userTypeFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        bool isTurista=false;

        if((snapshot.data!)=='Turista'){
          isTurista=true;
        }

        final List<Widget> _widgetOptions = [
          const HomePage(),
          const MapJ(),
          const NotificationsPage(),
          isTurista
              ? const MyProfileTouristPage()
              : const MyProfileShopkeeperPage(),
        ];

        return Scaffold(
          appBar: AppBar(title: const Text("MEDEX")),
          body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, color: Colors.black),
                label: " ",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map, color: Colors.black),
                label: " ",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications_active, color: Colors.black),
                label: " ",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person, color: Colors.black),
                label: " ",
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        );
      },
    );
  }
}
