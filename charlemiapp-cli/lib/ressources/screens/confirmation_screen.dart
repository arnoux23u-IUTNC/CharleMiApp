import '../../main.dart';
import '../assets/colors.dart';
import '../../models/product.dart';
import '../../ressources/screens/home.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../navigation/appbar_back.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({Key? key}) : super(key: key);

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBack(),
      backgroundColor: darkColor,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              color: darkColor,
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [],
                  ),
                ),
              ),
            ),
          ),
          Container(
              padding: const EdgeInsets.only(left: 55, right: 55, top: 30, bottom: 15),
              width: double.infinity,
              child: Column(
                children: [
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => {
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
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
