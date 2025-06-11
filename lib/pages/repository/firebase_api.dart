import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../models/event.dart';
import '../models/useradmin.dart' as UserApp;

class FirebaseApi{

  Future<String?> createUser(String emailAddress, String password) async{
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,

      );
      return credential.user?.uid;
    } on FirebaseAuthException catch (e) { // error por coponente de autenticacion
      print ("FirebaseAuthExeption ${e.code}");// mensaje de error para los desarrolladores
      return e.code;
    } on FirebaseException catch (e) {
      print ("FirebaseExeption ${e.code}");// mensaje de error para los desarrolladores
      return e.code;
    }
  } // si hay un error se eejecuta el try catch para cuando haya un bloqueo
  Future<String?> singInUser(String emailAddress, String password) async{
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      return credential.user?.uid;
    } on FirebaseAuthException catch (e) { // error por coponente de autenticacion
      print ("FirebaseAuthExeption ${e.code}");// mensaje de error para los desarrolladores
      return e.code;
    } on FirebaseException catch (e) {
      print ("FirebaseExeption ${e.code}");// mensaje de error para los desarrolladores
      return e.code;
    }
  }
  void signOut() async{
    await FirebaseAuth.instance.signOut();
  } // para cerrar sesion
  void recoveryPassword (String emailAddress) async{
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailAddress);

  } // para recuperar la contraseña

  Future <bool> validateSession() async{
    return await FirebaseAuth.instance.currentUser == null;
  }// para validar que hay alguien logeado

  Future<String> createUserInDB(UserApp.UserAdmin user) async{
    try {
      var db = FirebaseFirestore.instance; // en la isntancia se coloca la informacion
      final document = await db.collection('Administradores').doc(user.uid).set(user.toJson());

      return user.uid;
    } on FirebaseException catch (e, stack) {
      print ("FirebaseExeption ${e.code}");// mensaje de error para los desarrolladores
      print ("Stack: $stack");
      return e.code;
    }

  }
  Future<String> createEventInDB(Event event) async{
    try {
      final db =FirebaseFirestore.instance;
      final uid = FirebaseAuth.instance.currentUser?.uid;
      final document = await FirebaseFirestore.instance
      .collection("Negociante")
      .doc(uid)
      .collection("MyEvents")
      .doc();

      event.uid = document.id;


      await db
        .collection("Negociante")
        .doc(uid)
        .collection("MyEvents")
        .doc(event.uid)
        .set(event.toJson());

      await db
          .collection("Events")
          .doc(event.uid)
          .set(event.toJson());
      return document.id;

    } on FirebaseException catch (e, stack) {
      print ("FirebaseExeption ${e.code}");// mensaje de error para los desarrolladores
      print ("Stack: $stack");
      return e.code;
    }

  }
}