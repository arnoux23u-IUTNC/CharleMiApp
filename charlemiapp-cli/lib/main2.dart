import 'package:cart/cart/pages/checkout.dart';
import 'package:cart/cart/pages/shop_items.dart';
import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<int, Color> color = {
      50: Color.fromRGBO(32, 36, 52, .1),
      100: Color.fromRGBO(32, 36, 52, .2),
      200: Color.fromRGBO(32, 36, 52, .3),
      300: Color.fromRGBO(32, 36, 52, .4),
      400: Color.fromRGBO(32, 36, 52, .5),
      500: Color.fromRGBO(32, 36, 52, .6),
      600: Color.fromRGBO(32, 36, 52, .7),
      700: Color.fromRGBO(32, 36, 52, .8),
      800: Color.fromRGBO(32, 36, 52, .9),
      900: Color.fromRGBO(32, 36, 52, 1),
    };
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF202434, color),
      ),
      initialRoute: '/',
      routes: {
        '/': (BuildContext context) => ShopItems(),
        '/checkout': (BuildContext context) => Checkout()
      },
    );
  }
}