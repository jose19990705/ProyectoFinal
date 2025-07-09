import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseApiGetDataShopkeeper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot<Map<String, dynamic>>> getCurrentShopkeeperData() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw Exception("Usuario no autenticado.");
    }

    return await _firestore.collection('Negociante').doc(uid).get();
  }

  Future<List<Map<String, dynamic>>> getFoodsFromShopkeeper() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw Exception("Usuario no autenticado.");
    }

    final snapshot = await _firestore
        .collection('Negociante')
        .doc(uid)
        .collection('Food')
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
