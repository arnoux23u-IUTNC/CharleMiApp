import 'models/cart.dart';
import 'services/theme_manager.dart';
import 'ressources/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  //FirebaseMessaging.onBackgroundMessage(PushNotificationService.messageHandler);
  runApp(const CharlemiappLauncher());
}

class CharlemiappLauncher extends StatefulWidget {
  const CharlemiappLauncher({Key? key}) : super(key: key);

  @override
  CharlemiappInstance createState() => CharlemiappInstance();
}

class CharlemiappInstance extends State<CharlemiappLauncher> {
  static Cart cart = Cart();
  static DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.lightTheme = await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    cart.cache();
    return ChangeNotifierProvider(
      create: (_) {
        return themeChangeProvider;
      },
      child: Consumer<DarkThemeProvider>(
        builder: (BuildContext context, value, Widget? child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'CharleMi\'App',
            home: const Home(),
            theme: Styles.themeData(themeChangeProvider.lightTheme, context),
          );
        },
      ),
    );
  }
}
