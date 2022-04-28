import 'order_data.dart';
import 'transaction_data.dart';
import '../ressources/assets/const.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AppUser {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String uid;
  String? avatarId;
  String? firstName, lastName, phone, carteEtudiant;

  bool? isAdmin, estBoursier;

  AppUser({required this.uid, this.lastName, this.firstName, this.phone, this.carteEtudiant, this.isAdmin, this.estBoursier});

  Future<bool> init() async {
    var snapshot = await firestore.collection('users').doc(uid).get();
    if (snapshot.exists) {
      avatarId = snapshot.data()!['avatar_id'];
      firstName = snapshot.data()!['firstname'] ?? '';
      lastName = snapshot.data()!['lastname'] ?? '';
      phone = snapshot.data()!['phone'] ?? '';
      isAdmin = snapshot.data()!['id_admin'] ?? false;
      carteEtudiant = snapshot.data()!['carte_etudiant'] ?? '';
      estBoursier = snapshot.data()!['boursier'] ?? false;
      await firestore.collection('users').doc(uid).update({
        'token_fcm': await FirebaseMessaging.instance.getToken(),
      });
      return true;
    }
    return false;
  }

  Future<bool> store(String lastName, String firstName, String phone, String carteEtudiant, [double balance = 0]) async {
    var user = await firestore.collection('users').doc(uid).get();
    if (!user.exists) {
      await firestore.collection('users').doc(uid).set({
        'avatar_id': avatarId,
        'firstname': firstName,
        'lastname': lastName,
        'phone': phone,
        'is_admin': false,
        'boursier': false,
        'carte_etudiant': carteEtudiant,
        'balance': balance,
        'token_fcm': await FirebaseMessaging.instance.getToken(),
      });
      return true;
    }
    return false;
  }

  Future<String> getBalance() async {
    var response = await http.get(Uri.parse(urlAPI + '/balance'), headers: {'x-auth-token': uid});
    return response.statusCode == 200 ? NumberFormat("0.00", "fr_FR").format(jsonDecode(response.body)["balance"]) : '--';
  }

  void updateBalance(double amount) {
    firestore.collection('users').doc(uid).update({'balance': amount});
  }

  void delete() async {
    await firestore.collection('users').doc(uid).collection('transactions').get().then((snapshot) async {
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    });
    await firestore.collection('users').doc(uid).delete();
  }

  Future<List<TransactionData>> getTransactions() async {
    var response = await http.get(Uri.parse(urlAPI + '/transactions-history/?limit=5'), headers: {'x-auth-token': uid});
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)["history"] == "No recent orders") {
        return List<TransactionData>.empty();
      } else {
        return List<TransactionData>.from(jsonDecode(response.body)["history"].map((e) => TransactionData.fromJson(e)));
      }
    }
    return List<TransactionData>.empty();
  }

  Future<List<OrderData>> getOrders() async {
    var response = await http.get(Uri.parse(urlAPI + '/orders'), headers: {'x-auth-token': uid});
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)["orders"] == null) {
        return List<OrderData>.empty();
      } else {
        return List<OrderData>.from(jsonDecode(response.body)["orders"].map((e) => OrderData.fromJson(e)));
      }
    }
    return List<OrderData>.empty();
  }
}
