import '../../main.dart';
import '../screens/home.dart';
import '../assets/const.dart';
import '../assets/colors.dart';
import '../../models/product.dart';
import '../navigation/appbar_back.dart';
import '../../services/order_manager.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({Key? key}) : super(key: key);

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  TimeOfDay? _selected;
  String _selectedStr = "Heure de retrait";
  late Future<bool> _isOpen;
  final TextEditingController _controller = TextEditingController();

  @override
  initState() {
    super.initState();
    _isOpen = Future(() async {
      var response = await http.get(Uri.parse(urlAPI + '/is-open'), headers: {'x-auth-token': Home.user!.uid});
      if (response.statusCode == 200) {
        return jsonDecode(response.body)["open"] as bool;
      } else {
        return false;
      }
    });
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
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                color: CharlemiappInstance.themeChangeProvider.lightTheme ? midDarkColor : Colors.grey,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 165,
                    child: Text(
                      element.getName,
                      style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    "x $qte",
                    style: GoogleFonts.poppins(fontSize: 18),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarBack(null),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 18,
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 30, bottom: 10),
                      child: Image.asset(
                        'assets/check-circle.png',
                        height: MediaQuery.of(context).size.width / 4,
                        alignment: Alignment.center,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          "Finalisez votre commande",
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 20),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 55, right: 55, top: 15, bottom: 15),
                          width: double.infinity,
                          child: Column(
                            children: [
                              const Padding(padding: EdgeInsets.only(top: 20)),
                              TextFormField(
                                maxLines: null,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                autofocus: false,
                                controller: _controller,
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.newline,
                                decoration: const InputDecoration(
                                  hintText: "Instructions de retrait",
                                ),
                              ),
                              const Padding(padding: EdgeInsets.only(top: 20)),
                              _buildTimePicker()
                            ],
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 10)),
                        Text(
                          "Total : " + _displayTotal() + " €",
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 18),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 20)),
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
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.only(left: 55, right: 55, bottom: 5),
              width: double.infinity,
              child: Column(
                children: [
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  SizedBox(
                    width: double.infinity,
                    child: FutureBuilder(
                      future: _isOpen,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return (snapshot.data as bool)
                              ? ElevatedButton(
                                  onPressed: () async {
                                    if (_selected == null || _selectedStr == "Heure de retrait") {
                                      Fluttertoast.showToast(
                                        msg: "Heure de retrait invalide",
                                        toastLength: Toast.LENGTH_SHORT,
                                        timeInSecForIosWeb: 1,
                                      );
                                    } else {
                                      _buildToastOrder(jsonDecode(await placeOrder(_selectedStr, _controller.text, CharlemiappInstance.cart.cartItems)));
                                    }
                                  },
                                  child: Text(
                                    'Confirmer',
                                    style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
                                  ),
                                  style: btnDefaultStyle(),
                                )
                              : ElevatedButton(
                                  onPressed: null,
                                  child: Text(
                                    'Cafétéria fermée',
                                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(const EdgeInsets.all(17)),
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                  ),
                                );
                        } else {
                          return ElevatedButton(
                            onPressed: null,
                            child: Text(
                              'Cafétéria fermée',
                              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(const EdgeInsets.all(17)),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePicker() {
    return ElevatedButton(
      onPressed: () async {
        var time = DateTime.now();
        var timeafter =
            time.minute + 15 > 59 ? TimeOfDay(hour: time.hour + 1, minute: time.minute + 15 - 60) : TimeOfDay(hour: time.hour, minute: time.minute + 15);
        _selected = await showTimePicker(
          context: context,
          initialTime: timeafter,
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child ??
                  Theme(
                    data: ThemeData.light().copyWith(),
                    child: child ?? Container(),
                  ),
            );
          },
        );
        if (_selected != null) {
          if (_selected!.hour < time.hour ||
              (_selected!.hour == time.hour && _selected!.minute < (time.minute + 15)) ||
              _selected!.hour > 15 ||
              _selected!.hour < 10) {
            Fluttertoast.showToast(
              msg: "> ${NumberFormat("00", "fr_FR").format(timeafter.hour)}:${NumberFormat("00", "fr_FR").format(timeafter.minute)} | < 16h",
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
        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
      ),
      style: btnDefaultStyle(),
    );
  }

  void _buildToastOrder(data) {
    if (data['success'] == true) {
      Fluttertoast.showToast(
          msg: "Succès",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        CharlemiappInstance.cart.clearCart();
      });
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Home(selectedScreen: 2)), (route) => false);
    } else {
      switch (data['message']) {
        case 'Charlemiam is closed':
          Fluttertoast.showToast(
              msg: "Charlemiam is closed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          break;
        case 'Not enough funds':
          Fluttertoast.showToast(
              msg: "Solde insuffisant",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          break;
        case 'Scolarship fee error':
          Fluttertoast.showToast(
              msg: "Vous n'êtes pas boursier",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          break;
        case 'Not enough stocks':
          Fluttertoast.showToast(
              msg: "Un produit n'est plus disponible",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          break;
        default:
          Fluttertoast.showToast(
              msg: "An error occured",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          break;
      }
    }
  }
}
