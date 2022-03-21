import '../../main.dart';
import '../assets/colors.dart';
import '../../models/product.dart';
import '../../ressources/assets/const.dart';
import '../../ressources/screens/home.dart';
import '../../ressources/screens/confirmation_screen.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _buildElements(),
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 55, right: 55, top: 30, bottom: 15),
          width: double.infinity,
          child: Home.user != null
              ? (CharlemiappInstance.cart.cartItems.isNotEmpty
                  ? Column(
                      children: [
                        Text(
                          "Total : " + _displayTotal() + " €",
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 20),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 10)),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const ConfirmationScreen())),
                            },
                            child: Text(
                              'Commander',
                              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                            style: btnDefaultStyle(),
                          ),
                        )
                      ],
                    )
                  : ElevatedButton(
                      onPressed: null,
                      child: Text(
                        'Panier vide',
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(const EdgeInsets.all(17)),
                          backgroundColor: MaterialStateProperty.all(CharlemiappInstance.themeChangeProvider.darkTheme ? const Color(0xFF0F111C) : Colors.grey),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))))
              : Column(
                  children: [
                    Text(
                      "Total : " + _displayTotal() + " €",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                    const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                    ElevatedButton(
                      onPressed: null,
                      child: Text(
                        'Vous n\'êtes pas connecté',
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(CharlemiappInstance.themeChangeProvider.darkTheme ? const Color(0xFF0F111C) : Colors.grey),
                        padding: MaterialStateProperty.all(const EdgeInsets.all(17)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  String _displayTotal() {
    double total = 0.0;
    CharlemiappInstance.cart.cartItems.forEach((key, value) {
      total += key.getPrice * int.parse(value);
    });
    return NumberFormat("0.00", "fr_FR").format(total);
  }

  List<Widget> _buildElements() {
    ButtonStyle _textButtonStyle = TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      minimumSize: Size.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
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
              decoration: BoxDecoration(
                color: CharlemiappInstance.themeChangeProvider.darkTheme ? midDarkColor : Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 13,
                    child: Text(
                      element.getDiminutif,
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Row(
                      children: [
                        TextButton(
                          style: _textButtonStyle,
                          child: Text(
                            "+",
                            style: GoogleFonts.poppins(fontSize: 18, color: CharlemiappInstance.themeChangeProvider.darkTheme ? Colors.white : Colors.black),
                          ),
                          onPressed: () {
                            setState(() {
                              switch (CharlemiappInstance.cart.addToCart(element)) {
                                case true:
                                  break;
                                case "TARIF":
                                  Fluttertoast.showToast(
                                    msg: "Vous n'êtes pas boursier",
                                    toastLength: Toast.LENGTH_SHORT,
                                    timeInSecForIosWeb: 1,
                                  );
                                  break;
                                case "STOCK":
                                  Fluttertoast.showToast(
                                    msg: "Ce produit n'est plus en stock",
                                    toastLength: Toast.LENGTH_SHORT,
                                    timeInSecForIosWeb: 1,
                                  );
                                  break;
                                default:
                                  Fluttertoast.showToast(
                                    msg: "Impossible d'ajouter plus",
                                    toastLength: Toast.LENGTH_SHORT,
                                    timeInSecForIosWeb: 1,
                                  );
                                  break;
                              }
                            });
                          },
                        ),
                        Text(
                          "$qte",
                          style: GoogleFonts.poppins(fontSize: 18),
                        ),
                        TextButton(
                          style: _textButtonStyle,
                          child: Text(
                            "-",
                            style: GoogleFonts.poppins(fontSize: 18, color: CharlemiappInstance.themeChangeProvider.darkTheme ? Colors.white : Colors.black),
                          ),
                          onPressed: () {
                            setState(() {
                              CharlemiappInstance.cart.removeFromCart(element);
                            });
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.end,
                    ),
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
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      );
    }
    return res;
  }
}
