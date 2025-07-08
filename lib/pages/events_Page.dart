import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'detail_event_page.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  String _formatFecha(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return DateFormat('dd MMM yyyy – hh:mm a', 'es_CO').format(date);
  }
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

          // Contenido
          Positioned.fill(
            child: Column(
              children: [
                AppBar(
                  title: const Text('Todos los eventos'),
                  titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
                  backgroundColor: Colors.black87,
                  elevation: 8,
                  centerTitle: true,
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Events')
                        .orderBy('initialDate', descending: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(child: Text('Error cargando eventos'));
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No hay eventos disponibles'));
                      }

                      final events = snapshot.data!.docs;

                      return ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          final event = events[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailEventPage(event),
                                ),
                              );
                            },
                            child: Card(
                              color: Colors.black.withOpacity(0.6), // Transparencia
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
                                    ),
                                    child: Image.network(
                                      event['urlImage'] ?? '',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image, size: 100),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            event['nameEvent'] ?? '',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "Fecha: ${_formatFecha(event['initialDate'])}",
                                            style: const TextStyle(
                                                fontSize: 14, color: Colors.white70),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "Precio: \$${event['cost'] ?? '---'}",
                                            style: const TextStyle(
                                                fontSize: 14, color: Colors.white70),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const Icon(Icons.chevron_right, color: Colors.white),
                                  const SizedBox(width: 8),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
