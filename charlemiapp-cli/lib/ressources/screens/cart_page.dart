import 'package:charlemiapp_cli/models/cart.dart';
import 'package:charlemiapp_cli/ressources/screens/home.dart';
import 'package:charlemiapp_cli/services/orderManager.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/product.dart';
import '../assets/colors.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: darkColor,
      child: Column(children: <Widget>[
        Expanded(
            child: Container(
          height: MediaQuery.of(context).size.height,
          color: darkColor,
          child: SingleChildScrollView(
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildElements(),
            )),
          ),
        )),
        Container(
            padding: const EdgeInsets.only(left: 55, right: 55, top: 30, bottom: 15),
            width: double.infinity,
            child: Home.user != null
                ? (Home.cart.cartItems.isNotEmpty
                    ? ElevatedButton(
                        onPressed: () async => {
                          /* TODO await placeOrder(Home.cart.cartItems)*/
                        },
                        child: Text(
                          'Commander',
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(buttonBlueColor),
                            padding: MaterialStateProperty.all(const EdgeInsets.all(17)),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
                      )
                    : ElevatedButton(
                        onPressed: null,
                        child: Text(
                          'Panier vide',
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(const EdgeInsets.all(17)),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))))
                : ElevatedButton(
                    onPressed: null,
                    child: Text(
                      'Vous n\'êtes pas connecté',
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(const EdgeInsets.all(17)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))))
      ]),
    );
  }

  List<Widget> _buildElements() {
    Map<Product, int> items = Home.cart.cartItems;
    List<Widget> res = List.empty(growable: true);
    if (items.isNotEmpty) {
      for (Product element in items.keys) {
        int qte = items[element] ?? 0;
        res.add(Container(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          width: double.infinity,
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: midDarkColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(3, 3),
                  blurRadius: 1,
                  spreadRadius: 0,
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Text(
                    element.getName,
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      child: Text(
                        "+",
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
                      ),
                      onPressed: () {
                        setState(() {
                          if (!Home.cart.addToCart(element)) {
                            Fluttertoast.showToast(
                              msg: "Impossible d'ajouter plus",
                              toastLength: Toast.LENGTH_SHORT,
                              timeInSecForIosWeb: 1,
                            );
                          }
                        });
                      },
                    ),
                    Text(
                      "$qte",
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
                    ),
                    TextButton(
                      child: Text(
                        "-",
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
                      ),
                      onPressed: () {
                        setState(() {
                          Home.cart.removeFromCart(element);
                        });
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ));
      }
    } else {
      res.add(Container(
          padding: const EdgeInsets.only(left: 55, right: 55, top: 80),
          width: double.infinity,
          child: Center(
              child: Text(
            'Votre panier est vide',
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
          ))));
    }
    return res;
  }
}
