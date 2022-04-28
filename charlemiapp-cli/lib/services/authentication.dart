import '../models/user.dart';
import '../ressources/screens/home.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return user!.emailVerified ? _toAppUser(user, null) : "notverified";
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return e.toString().contains('user-disabled') ? "disabled" : null;
    }
  }

  Future<bool> userExists(String data) async {
    final carteEtu = await _db.collection('users').where('carte_etudiant', isEqualTo: data).get();
    final phone = await _db.collection('users').where('phone', isEqualTo: data).get();
    return carteEtu.docs.isNotEmpty || phone.docs.isNotEmpty;
  }

  Future register(String email, String password, String lastName, String firstName, String phone, String carteEtu) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      await user?.sendEmailVerification();
      return _toAppUser(user!, <String>[lastName, firstName, phone, carteEtu]);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }

  Future<AppUser?> _toAppUser(User? user, List? params) async {
    AppUser _user = params == null
        ? AppUser(uid: user!.uid)
        : AppUser(uid: user!.uid, lastName: params[0], firstName: params[1], phone: params[2], carteEtudiant: params[3]);
    var exists = await _user.init();
    if (exists) {
      return _user;
    } else if (params != null) {
      await _user.store(params[0], params[1], params[2], params[3]);
      return _user;
    }
    return null;
  }

  static String? validateEmail(String? value) {
    String pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty || !regex.hasMatch(value)) {
      return 'Adresse email invalide';
    } else {
      return null;
    }
  }

  static String? validatePassword(String password, String? passwordConfirm) {
    if (password.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    } else if (passwordConfirm != null && password != passwordConfirm) {
      return 'Les mots de passe ne correspondent pas';
    } else {
      return null;
    }
  }

  static String? validateNumTel(String? value) {
    String pattern = r"^[0-9]{10}$";
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty || !regex.hasMatch(value)) {
      return 'Numéro de téléphone invalide';
    } else {
      return null;
    }
  }

  static String? validateCarteEtu(String? value) {
    String pattern = r"^[0-9]{8}$";
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty || !regex.hasMatch(value)) {
      return 'Numéro de carte étudiant invalide';
    } else {
      return null;
    }
  }

  Future<bool> deleteAccount() async {
    try {
      Home.user!.delete();
      await _auth.currentUser?.delete();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return false;
    }
  }

  Future resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      if (e.toString().contains('user-not-found')) {
        return "notfound";
      } else if (e.toString().contains('invalid-email')) {
        return "email";
      }
      return null;
    }
  }

  static Future<AppUser?> delegate(User? data) async {
    return AuthenticationService()._toAppUser(data, null);
  }
}
