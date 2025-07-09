
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});


  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  String _formatFecha(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return DateFormat('dd MMM yyyy – hh:mm a', 'es_CO').format(date);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notificaciones"),
        titleTextStyle: TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/Fondo_home.png',
              fit: BoxFit.cover,
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Events')
                .orderBy('initialDate', descending: true)
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
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return Card(
                    color: Colors.black87.withOpacity(0.6),
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: ClipOval(
                        child: Image.network(
                          event['urlImage'] ?? '',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, size: 60, ),
                        ),
                      ), //imagen en ovalo
                      title: Text(
                        event['nameEvent'] ?? '',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ), //Nombre del evento
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Costo: \$${event['cost'] ?? '---'}",
                            style: const TextStyle(fontSize: 14, color: Colors.white54),
                          ),// COsto
                          const SizedBox(height: 4),
                          Text(
                            _formatFecha(event['initialDate']),
                            style: const TextStyle(fontSize: 13, color: Colors.grey),
                          ),//Fecha inicial
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}