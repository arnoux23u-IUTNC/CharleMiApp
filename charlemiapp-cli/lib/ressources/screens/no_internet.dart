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
        backgroundColor: midDarkColor,
        body: Center(
          child: Column(
            children: <Widget>[
              Image.asset("assets/logo_white.png", width: MediaQuery.of(context).size.width * 0.6),
              Text(
                'No internet connection',
                style: GoogleFonts.poppins(
                  color: whiteColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ));
  }
}
