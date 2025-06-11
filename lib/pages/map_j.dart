import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

const MAPBOX_ACCESS_TOKEN = 'pk.eyJ1IjoianVudGFybyIsImEiOiJjbWJyNHN2N24wNmdwMmpwdjJiejNxczBhIn0.hrTjAk8pdNz084-S_EtOYw';
final myPosition = LatLng(6.268025143631159, -75.56881930626942);


class MapJ extends StatefulWidget {
  const MapJ({super.key});

  @override
  State<MapJ> createState() => _MapJState();
}

class _MapJState extends State<MapJ> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const  Text('Mapa'),
        backgroundColor: Colors.green,
      ),
      body: FlutterMap(
          options: MapOptions(
            center:  myPosition,
            minZoom: 5,
            maxZoom: 2000,
            zoom: 50,
          ),
        nonRotatedChildren: [TileLayer(
          urlTemplate: 'https://console.mapbox.com/studio/styles/juntaro/cmbrgrtj7001u01rx35znh8u2/edit/#2/38/-34',
          additionalOptions: {
            'accesToken': MAPBOX_ACCESS_TOKEN,
            'id': 'mapbox/streets-v12'
          },
        ),
          MarkerLayer(
            markers: [
              Marker(point: myPosition, builder: (context){
                return Container(
                  child: const Icon(
                      Icons.person_pin,
                    color: Colors.red,
                    size: 40,
                  ),
                );
              })
            ],
          ), //para colocar un punto en el mapa 
        ],

      ),

    );
  }
}
