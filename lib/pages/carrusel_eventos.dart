import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'detail_event_page.dart';

class CarruselEventos extends StatefulWidget {
  const CarruselEventos({Key? key}) : super(key: key);

  @override
  _CarruselEventosState createState() => _CarruselEventosState();
}

class _CarruselEventosState extends State<CarruselEventos> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Events').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final events = snapshot.data!.docs;

          // Iniciar temporizador solo cuando los datos están listos
          _timer ??= Timer.periodic(const Duration(seconds: 4), (Timer timer) {
            if (_pageController.hasClients && mounted) {
              final nextPage = (_currentPage + 1) % events.length;
              _pageController.animateToPage(
                nextPage,
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
              );
              setState(() {
                _currentPage = nextPage;
              });
            }
          });

          return PageView.builder(
            controller: _pageController,
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: NetworkImage(event['urlImage']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                        ),
                        child: Text(
                          event['nameEvent'] ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                        ),
                      ),
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