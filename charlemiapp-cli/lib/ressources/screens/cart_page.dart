import 'package:charlemiapp_cli/models/cart.dart';
import 'package:flutter/material.dart';
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
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _buildElements(),
              )),
            ),
          ),
        )),
        Container(
            padding: const EdgeInsets.only(left: 55, right: 55, top: 30, bottom: 15),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async => {},
              child: Text(
                'Valider',
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
              ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(buttonBlueColor),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(17)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
            ))
      ]),
    );
  }

  List<Widget> _buildElements() {
    CartItemsBloc cart = CartItemsBloc();
    List<Product> items = cart.cartList;
    List<Widget> res = List.empty(growable: true);

    for (Product element in items) {
      res.add(Container(
        padding: const EdgeInsets.only(left: 55, right: 55, top: 20),
        width: double.infinity,
        child: Container(
          decoration:  const BoxDecoration(
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
          child: Text(
            element.getName,
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
      ));
    }
    return res;
  }
}
