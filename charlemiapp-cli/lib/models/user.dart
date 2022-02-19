import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AppUser {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String uid;
  String? avatarId;
  String? firstName, lastName, phone, carteEtudiant;

  bool? isAdmin;

  AppUser({required this.uid, this.lastName, this.firstName, this.phone, this.carteEtudiant});

  Future<bool> init() async {
    var snapshot = await firestore.collection('users').doc(uid).get();
    if (snapshot.exists) {
      avatarId = snapshot.data()!['avatar_id'];
      firstName = snapshot.data()!['firstname'] ?? '';
      lastName = snapshot.data()!['lastname'] ?? '';
      phone = snapshot.data()!['phone'] ?? '';
      isAdmin = snapshot.data()!['id_admin'] ?? false;
      carteEtudiant = snapshot.data()!['carte_etudiant'] ?? '';
      return true;
    }
    return false;
  }

  Future<bool> store(String lastName, String firstName, String phone , String carteEtudiant, String? avatarId, bool? isAdmin, [double balance = 0]) async {
    var user = await firestore.collection('users').doc(uid).get();
    if (!user.exists) {
      await firestore.collection('users').doc(uid).set({
        'avatar_id': avatarId,
        'firstname': firstName,
        'lastname': lastName,
        'phone': phone,
        'is_admin': isAdmin ?? false,
        'carte_etudiant': carteEtudiant,
        'balance': balance,
      });
      return true;
    }
    return false;
  }

  Future<String> getBalance() async{
    var response = await http.get(Uri.parse('https://europe-west1-charlemi-app.cloudfunctions.net/api/balance'), headers: {
      'x-auth-token': uid
    });
    return response.statusCode == 200 ? NumberFormat("0.00", "fr_FR").format(jsonDecode(response.body)["balance"]) : '--';
  }

  updateBalance(double amount) {
    firestore.collection('users').doc(uid).update({
      'balance': amount
    });
  }

  delete() async {
    await firestore.collection('users').doc(uid).delete();
  }

}
