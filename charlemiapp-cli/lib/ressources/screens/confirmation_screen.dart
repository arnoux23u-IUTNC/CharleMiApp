import '../../main.dart';
import '../assets/const.dart';
import '../assets/colors.dart';
import '../../models/product.dart';
import '../navigation/appbar_back.dart';
import 'dart:io' show Platform;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({Key? key}) : super(key: key);

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

String _displayTotal() {
  double total = 0.0;
  CharlemiappInstance.cart.cartItems.forEach((key, value) {
    total += key.getPrice * int.parse(value);
  });
  return NumberFormat("0.00", "fr_FR").format(total);
}

List<Widget> _buildElements() {
  Map<Product, String> items = CharlemiappInstance.cart.cartItems;
  List<Widget> res = List.empty(growable: true);
  if (items.isNotEmpty) {
    for (Product element in items.keys) {
      int qte = int.parse(items[element] ?? "0");
      res.add(
        Container(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 165,
                  child: Text(
                    element.getName,
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  "x " "$qte",
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      );
    }
  } else {
    res.add(
      Container(
        padding: const EdgeInsets.only(left: 55, right: 55, top: 80),
        width: double.infinity,
        child: Center(
          child: Text(
            'Votre panier est vide',
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
  return res;
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  TimeOfDay? _selected;
  String _selectedStr = "Heure de retrait";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarBack(),
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
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 30),
                        height: 200,
                        child: Image.asset('assets/check-circle.png'),
                      ),
                      Column(
                        children: [
                          Text(
                            "Finalisez votre commande",
                            style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 20),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 55, right: 55, top: 30, bottom: 15),
                            width: double.infinity,
                            child: Column(
                              children: [
                                const Padding(padding: EdgeInsets.only(top: 20)),
                                TextFormField(
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  autofocus: false,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    filled: true,
                                    errorMaxLines: 2,
                                    fillColor: midDarkColor,
                                    contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                                    hintText: "Commentaire",
                                    hintStyle: GoogleFonts.poppins(
                                      color: greyedFont,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                const Padding(padding: EdgeInsets.only(top: 20)),
                                _buildTimePicker()
                              ],
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 20)),
                          Text(
                            "Total : " + _displayTotal() + " €",
                            style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 18),
                          ),
                          Column(
                            children: _buildElements(),
                          )
                        ],
                      ),
                    ],
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
                    onPressed: () {
                      if (_selected == null || _selectedStr == "Heure de retrait") {
                        Fluttertoast.showToast(
                          msg: "Heure de retrait invalide",
                          toastLength: Toast.LENGTH_SHORT,
                          timeInSecForIosWeb: 1,
                        );
                      } else {
                        /* TODO await placeOrder(Home.cart.cartItems)*/
                      }
                    },
                    child: Text(
                      'Commander',
                      style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    style: defaultButtonStyle,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTimePicker() {
    return ElevatedButton(
      onPressed: () async {
        var time = DateTime.now();
        //if (Platform.isAndroid) {
        _selected = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(hour: time.hour, minute: time.minute + 15),
        );
        if (_selected != null) {
          if (_selected!.hour < time.hour ||
              (_selected!.hour == time.hour && _selected!.minute < (time.minute + 15)) ||
              _selected!.hour > 15 ||
              _selected!.hour < 10) {
            Fluttertoast.showToast(
              msg: "> ${time.hour}:${time.minute + 15} | < 16h",
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 2,
            );
          } else {
            MaterialLocalizations localizations = MaterialLocalizations.of(context);
            String formattedTime = localizations.formatTimeOfDay(_selected!, alwaysUse24HourFormat: true);
            setState(() {
              _selectedStr = formattedTime;
            });
          }
        } else {
          setState(() {
            _selectedStr = "Heure de retrait";
          });
        }
        /*} else {
          //TODO IOS
        }*/
      },
      child: Text(
        _selectedStr,
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
      ),
      style: defaultButtonStyle,
    );
  }
}
