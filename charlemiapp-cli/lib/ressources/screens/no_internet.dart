import 'dart:io';
import 'package:flutter/services.dart';

import '../assets/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoInternet extends StatefulWidget {
  const NoInternet({Key? key}) : super(key: key);

  @override
  _NoInternetState createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: darkColor,
        body: Center(
          child: Stack(
            children: <Widget>[
              Center(
                  child: Container(
                    padding: const EdgeInsets.only(top: 100, bottom: 15),
                    child: Column(
                      children: <Widget>[
                        Image.asset("assets/wifi-slash.png", width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.4),
                        Text(
                          'Vous n\'êtes pas connecté à internet',
                          style: GoogleFonts.poppins(
                            color: colorAmbre,
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
              ),

              Positioned(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.only(left: 55, right: 55, top: 30, bottom: 15),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (Platform.isAndroid) {
                            SystemNavigator.pop();
                          } else if (Platform.isIOS) {
                            exit(0);
                          }
                        },
                        child: Text(
                          'Quitter',
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(buttonBlueColor),
                            padding: MaterialStateProperty.all(const EdgeInsets.all(17)),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
                      ),
                    ),
                  )),
            ],
          ),
        ));
  }
}
