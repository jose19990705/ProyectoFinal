import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';


const MAPBOX_ACCESS_TOKEN = 'pk.eyJ1IjoianVudGFybyIsImEiOiJjbWJ3cTk0b3cxNDFtMmlwd2F6eTVvN3MwIn0.qD7oU5bDtfwyUznaUWqDTA';
final myPosition = LatLng(6.268025143631159, -75.56881930626942);


class MapJ extends StatefulWidget {
  const MapJ({super.key});


  @override
  State<MapJ> createState() => _MapJState();
}

class _MapJState extends State<MapJ> {
  List<Marker> eventMarkers = [];
  @override

  void initState() {
    super.initState();
    _loadEventLocations();
  }

  Future<void> _loadEventLocations() async {
    final snapshot = await FirebaseFirestore.instance.collection('Events').get();

    List<Marker> markers = [];
    for (var doc in snapshot.docs) {
      final locationName = doc['location'];
      final name = doc['nameEvent'] ?? 'Evento';

      final url = 'https://api.mapbox.com/geocoding/v5/mapbox.places/${Uri.encodeComponent(locationName)}.json?access_token=$MAPBOX_ACCESS_TOKEN';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['features'].isNotEmpty) {
          final coords = data['features'][0]['center'];
          final lng = coords[0];
          final lat = coords[1];

          markers.add(
            Marker(
              point: LatLng(lat, lng),
              width: 70,
              height: 70,
              builder: (context) => Column(
                children: [
                  //const Icon(Icons.location_on, color: Colors.red, size: 40),
                  Image.asset('assets/images/evindicator.png'),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    color: Colors.black.withOpacity(0.7),
                    child: Text(
                      name,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
          );
        }
      }
    }

    setState(() {
      eventMarkers = markers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Mapa'),
        backgroundColor: Colors.green,
      ),
      body: FlutterMap(
        options: MapOptions(
          center: myPosition,
          minZoom: 5,
          maxZoom: 18,
          zoom: 13,
        ),
        nonRotatedChildren: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
            userAgentPackageName: 'com.josea.laboratorio_3',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: myPosition,
                height: 80,
                width: 70,
                builder: (context) {
                  return Image.asset('assets/images/Indi.png');
                },
              ),
              ...eventMarkers,
            ],
          ),
        ],
      ),
    );
  }
}
