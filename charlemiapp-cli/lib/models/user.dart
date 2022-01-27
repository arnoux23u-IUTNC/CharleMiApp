import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String uid;
  String? avatarId;
  late String email, firstName, lastName, phone, username;
  bool? isAdmin;

  AppUser({required this.uid});

  init() async {
    var snapshot = await firestore.collection('users').doc(uid).get();
    print(snapshot.data());
    if (snapshot.exists) {
      avatarId = snapshot.data()!['avatar_id'];
      email = snapshot.data()!['email'] ?? '';
      firstName = snapshot.data()!['firstname'] ?? '';
      lastName = snapshot.data()!['lastname'] ?? '';
      phone = snapshot.data()!['phone'] ?? '';
      username = snapshot.data()!['username'] ?? '';
      isAdmin = snapshot.data()!['id_admin'] ?? false;
    }
  }
}
