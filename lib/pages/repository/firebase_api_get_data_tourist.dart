import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseApiGetDataTourist {
  Future<DocumentSnapshot<Map<String, dynamic>>> getCurrentTouristData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      throw Exception("Usuario no autenticado");
    }
    return await FirebaseFirestore.instance.collection('Turistas').doc(uid).get();
  }
}
