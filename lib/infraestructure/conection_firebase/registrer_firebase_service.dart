import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error al iniciar sesión con Firebase: $e");
      return null;
    }
  }

  Future<bool> registerUser(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      print("Error al registrar usuario en Firebase: $e");
      return false;
    }
  }

  Future<void> addUserData(String email, String password) async {
    try {
      await _firestore.collection('Users').doc().set({
        "Correo": email,
        "Contraseña": password,
      });
    } catch (e) {
      print("Error al agregar datos de usuario en Firestore: $e");
    }
  }
}
