// rating_manager.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class RatingManager {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> rateFood({
    required String comercianteId,
    required String foodDocId,
    required String userId,
    required double rating,
  }) async {
    final foodRef = _firestore
        .collection('Negociante')
        .doc(comercianteId)
        .collection('Food')
        .doc(foodDocId);

    final ratingRef = foodRef.collection('ratingFood').doc(userId);
    final ratingSnap = await ratingRef.get();

    if (ratingSnap.exists) return; // evitar múltiples votos del mismo usuario

    final foodSnap = await foodRef.get();
    if (!foodSnap.exists) return;

    final data = foodSnap.data()!;
    final currentRating = (data['rating'] ?? 0).toDouble();
    final totalRatings = (data['totalRatings'] ?? 0).toInt();

    final updatedTotalRatings = totalRatings + 1;
    final updatedRating = ((currentRating * totalRatings) + rating) / updatedTotalRatings;

    await foodRef.update({
      'rating': updatedRating,
      'totalRatings': updatedTotalRatings,
    });

    await ratingRef.set({
      'userId': userId,
      'rating': rating,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await _updateComercianteRating(comercianteId);
  }

  Future<void> _updateComercianteRating(String comercianteId) async {
    final foodSnapshot = await _firestore
        .collection('Negociante')
        .doc(comercianteId)
        .collection('Food')
        .get();

    double sum = 0;
    int count = 0;

    for (final doc in foodSnapshot.docs) {
      final data = doc.data();
      final r = (data['rating'] ?? 0).toDouble();
      final t = (data['totalRatings'] ?? 0).toInt();
      if (t > 0) {
        sum += r;
        count++;
      }
    }

    final newComercianteRating = count > 0 ? sum / count : 0;

    await _firestore.collection('Negociante').doc(comercianteId).update({
      'rating': newComercianteRating,
    });
  }
}
