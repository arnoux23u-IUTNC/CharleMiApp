import 'dart:ui';

import 'package:charlemiapp_cli/ressources/assets/colors.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home.dart';
import '../loader.dart';
import '../../services/authentication.dart';
import 'package:flutter/material.dart';

final AuthenticationService _auth = AuthenticationService();

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) => Home.loading
      ? const Loader()
      : Container(
          height: MediaQuery.of(context).size.height,
          color: darkColor,
          child: Scrollbar(
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 40, bottom: 50),
                    child: Text(
                        'Bonjour, ${Home.user?.lastName} ${Home.user?.firstName}',
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w600)),
                  )),
                      Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                                'Votre solde est de 38,9 €',
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400)),
                          )),
                  Container(
                      padding: const EdgeInsets.only(
                          left: 55, right: 55, bottom: 15),
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () async => {
                          setState(() {
                            Home.loading = true;
                          }),
                          await _auth.signOut(),
                          setState(() {
                            Home.loading = false;
                            Home.user = null;
                          }),
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const Home(selectedScreen: 2)),
                              (route) => false)
                        },
                        child: Text(
                          'Modifier Solde',
                          style: GoogleFonts.poppins(color: colorAmbre, fontSize: 15, fontWeight: FontWeight.w300),
                        ),
                      )),
                  Container(
                      padding: const EdgeInsets.only(
                          left: 55, right: 55, top: 30, bottom: 15),
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async => {
                          setState(() {
                            Home.loading = true;
                          }),
                          await _auth.signOut(),
                          setState(() {
                            Home.loading = false;
                            Home.user = null;
                          }),
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const Home(selectedScreen: 2)),
                              (route) => false)
                        },
                        child: Text(
                          'Se déconnecter',
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(buttonBlueColor),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.all(17)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)))),
                      )),
                  Container(
                      padding: const EdgeInsets.only(
                          left: 55, right: 55, bottom: 15),
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () async => {
                          setState(() {
                            Home.loading = true;
                          }),
                          await _auth.signOut(),
                          setState(() {
                            Home.loading = false;
                            Home.user = null;
                          }),
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const Home(selectedScreen: 2)),
                              (route) => false)
                        },
                        child: Text(
                          'Supprimer votre compte',
                          style: GoogleFonts.poppins(color: Colors.red, fontSize: 15, fontWeight: FontWeight.w300),
                        ),
                      )),
                ])),
          ),
        );
}
