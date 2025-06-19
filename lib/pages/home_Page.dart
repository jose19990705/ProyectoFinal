import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:laboratorio_3/pages/arks_Page.dart';
import 'package:laboratorio_3/pages/detail_event_page.dart';
import 'package:laboratorio_3/pages/events_Page.dart';
import 'package:laboratorio_3/pages/new_event_page.dart';
import 'package:laboratorio_3/pages/restaurant_Page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SearchController _searchController = SearchController();
  List<QueryDocumentSnapshot> _searchResults = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              'assets/images/Fondo_home.png',
              fit: BoxFit.cover,
            ),
          ),

          // Lista horizontal de eventos
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Column(
              children: [
                SearchAnchor.bar(
                  barHintText: "Buscar eventos o lugares...",
                  searchController: _searchController,
                  suggestionsBuilder: (context, controller){
                    return _searchResults.map((event){
                      return ListTile(
                        title: Text(event['nameEvent']),
                        subtitle: Text(event['location']),
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailEventPage(event),
                              ),
                          );
                        },
                      );
                    }).toList();
                  },
                  onTap: () async {
                    await _performSearch(_searchController.text);
                  },
                  onChanged: (query) async {
                    await _performSearch(query);
                  },
                ),
                SizedBox(height: 10),
                Text("Opciones                                                 ",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 16,),
                  ),
                SizedBox(
                  height: 150,
                  child: Row(
                    children: [
                      Expanded(
                          child: TextButton(
                              onPressed: (){
                                _events();
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    radius: 40, // Tamaño del círculo
                                    backgroundImage: AssetImage('assets/images/Parques.jpg'),
                                  ),
                                  SizedBox(height: 2),
                                  Text('Parques',style: TextStyle(color: Colors.white),),
                                ],
                              ),
                          ),
                      ), //Parques
                      SizedBox(width: 5),
                      Expanded(
                        child: TextButton(
                          onPressed: (){
                            _restaurants();
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 40, // Tamaño del círculo
                                backgroundImage: AssetImage('assets/images/Rest.jpg'),
                              ),
                              SizedBox(height: 2),
                              Text('Restaurantes',style: TextStyle(color: Colors.white),),
                            ],
                          ),
                        ),
                      ), // Restaurantes
                      SizedBox(width: 5),
                      Expanded(
                        child: TextButton(
                          onPressed: (){
                            _events();
                          },

                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 40, // Tamaño del círculo
                                backgroundImage: AssetImage('assets/images/Concierto.jpg'),
                              ),
                              SizedBox(height: 2),
                              Text('Eventos', style: TextStyle(color: Colors.white),),
                            ],
                          ),
                        ),
                      ), // Eventos
                    ],
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: (){
                    _events();
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Eventos       >                                            ',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 16,),),
                    ],
                  ),
                ),
                SizedBox(
                  height: 280,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection("Events").snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text("No hay eventos"));
                      }

                      final events = snapshot.data!.docs;

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          final event = events[index];
                          return buildCard(event);
                        },
                      );
                    },
                  ),
                ),//Lista de Eventos enHorizontal

              ],
            ),

          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addButtonClicked,
        child: const Icon(Icons.add_card),
      ),// Boton de añador
    );
  }
  Widget buildCard(QueryDocumentSnapshot event){
    return InkWell(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  DetailEventPage(event)),
        );
      }, //para un click y que se abran los detalles del evento
      onLongPress: null, //para un click sostenido
      child: Card(
        elevation: 4.0,
        color: Colors.black26,
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
       child: Container(
         width: 220,
         padding: const EdgeInsets.all(8),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Container(
               height: 140,
               width: double.infinity,
               decoration: BoxDecoration(
                 image: const DecorationImage(
                   image: AssetImage('assets/images/Ina.png'),
                   fit: BoxFit.cover,
                 ),
                 borderRadius: BorderRadius.circular(10),
               ),
             ),
             const SizedBox(height: 8,),
             // Nombre del evento
             Text(
               event['nameEvent'] ?? '',
               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
             ),
             // Categoría
             Text(
               event['category'] ?? '',
               style: const TextStyle(fontSize: 14, color: Colors.white70),
             ),
             // Precio (nuevo dato)
             if (event.data().toString().contains('cost'))
               Text(
                 "\$${event['cost']}",
                 style: const TextStyle(fontSize: 14, color: Colors.white),
               ),
             // Ubicación (nuevo dato)
             if (event.data().toString().contains('location'))
               Text(
                 event['location'],
                 style: const TextStyle(fontSize: 13, color: Colors.white60),
               ),
           ],
         ),
       ),
       // child: Column(
          //children:[
           // ListTile(
              //title: Text(event['nameEvent']),
              //titleTextStyle: TextStyle(color: Colors.white),
              //subtitle: Text(event['category']),
              //subtitleTextStyle: TextStyle(color: Colors.white),

            //),

            //Container(
              //height: 100.0,
              //width: 200.0,

              //child: Ink.image(
                //image: AssetImage('assets/images/Ina.png'),
              //),
            //),
            //SizedBox(height: 8.0,)
          //],
        //),
      ),


    );
  }
  void _addButtonClicked(){
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const NewEventPage())
    );
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }

    final firestore = FirebaseFirestore.instance;

    final nameQuery = await firestore
        .collection('Events')
        .where('nameEvent', isGreaterThanOrEqualTo: query)
        .where('nameEvent', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    final locationQuery = await firestore
        .collection('Events')
        .where('location', isGreaterThanOrEqualTo: query)
        .where('location', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    final allResults = [
      ...nameQuery.docs,
      ...locationQuery.docs,
    ];

    final uniqueEvents = {
      for (var doc in allResults) doc.id: doc,
    };

    setState(() {
      _searchResults = uniqueEvents.values.toList();
    });
  }
  void _events(){
    Navigator.push(
      context,
      MaterialPageRoute(
        //builder: (context) => const SignInPage(),
        builder: (context) => const EventsPage(),
      ),
    );

  }
  void _parks(){
    Navigator.push(
      context,
      MaterialPageRoute(
        //builder: (context) => const SignInPage(),
        builder: (context) => const ArksPage(),
      ),
    );

  }
  void _restaurants(){
    Navigator.push(
      context,
      MaterialPageRoute(
        //builder: (context) => const SignInPage(),
        builder: (context) => const RestaurantPage(),
      ),
    );

  }
}
