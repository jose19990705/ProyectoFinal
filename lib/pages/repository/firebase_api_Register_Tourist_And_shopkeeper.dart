import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:laboratorio_3/models/shopkeeper.dart';
import '../../models/tourist.dart' as TouristApp;
import '../../models/shopkeeper.dart' as ShopkeeperApp;

class FirebaseApiRegisterTouristAndShopkeeper {
  Future<String?> createUser(String emailAddress, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      return credential.user?.uid;
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthExcepcion ${e.code}");
      return e.code;
    } on FirebaseException catch (e) {
      print("FirebaseExcepcion ${e.code}");
      return e.code;
    }
  }


  Future<String?> signInUser(String emailAddress, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      return credential.user?.uid;
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthExcepcion ${e.code}");
      return e.code;
    } on FirebaseException catch (e) {
      print("FirebaseExcepcion ${e.code}");
      return e.code;
    }
  }


  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void recoveryPassword(String emailAddress) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: emailAddress);
  }

  Future<bool> validateSession() async {
    return await FirebaseAuth.instance.currentUser == null;
  }

  Future<String> creatTouristIDB(TouristApp.Tourist user) async {
    try {
      var db = FirebaseFirestore.instance;
      final document = await db.collection('Turistas').doc(user.uid).set(
          user.tojson());
      return user.uid;
    } on FirebaseException catch (e) {
      print("FirebaseExcepcion ${e.code}");
      return e.code;
    }
  }

  Future<String> creatShopkeeperIDB(ShopkeeperApp.Shopkeeper user) async {
    try {
      var db = FirebaseFirestore.instance;
      final document = await db.collection('Negociante').doc(user.uid).set(
          user.tojson());
      return user.uid;
    } on FirebaseException catch (e) {
      print("FirebaseExcepcion ${e.code}");
      return e.code;
    }
  }





}

