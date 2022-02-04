import 'models/user.dart';
import 'ressources/screens/home.dart';
import 'services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return /*StreamProvider<AppUser?>.value(value: AuthenticationService().user, catchError: (_, __) => null, initialData: null, child:*/ const MaterialApp(debugShowCheckedModeBanner: false, title: '', home: Home())/*)*/;
  }
}
