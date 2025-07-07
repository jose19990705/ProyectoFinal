import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laboratorio_3/pages/home_Page.dart';
import 'package:laboratorio_3/pages/intro.dart';
import 'package:laboratorio_3/pages/map_j.dart';
import 'package:laboratorio_3/pages/my_profile_page.dart';
import 'package:laboratorio_3/pages/my_profile_shopkeeper_page.dart';
import 'package:laboratorio_3/pages/my_profile_tourist_page.dart';
import 'package:laboratorio_3/pages/new_Food_Page.dart';
import 'package:laboratorio_3/pages/restaurant_Page.dart';

import 'map_page.dart';
import 'notifications_page.dart';

class HomeNavigationBarPage extends StatefulWidget {
  const HomeNavigationBarPage({super.key});

  @override
  State<HomeNavigationBarPage> createState() => _HomeNavigationBarPageState();
}

class _HomeNavigationBarPageState extends State<HomeNavigationBarPage> {
  int _selectedIndex = 0; //es el numero de paginas se va de 0 a 3
  static const List<Widget> _widgetOptions =[
    HomePage(),
    //MapPage(),
    MapJ(),
    NotificationsPage(),
    //NewFoodPage(),
    //MyProfilePage(),
    MyProfileShopkeeperPage(),

  ]; // arreglo de widgets, se colocan las paginas
  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });// cambia el estado
  }// al hacer click en la barra
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MEDEX"),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),//carga la pagina segun la eleccion
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black,),
            label: " ",

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map,color: Colors.black,),
            label: " ",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active,color: Colors.black,),
            label: " ",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,color: Colors.black,),
            label: " ",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
