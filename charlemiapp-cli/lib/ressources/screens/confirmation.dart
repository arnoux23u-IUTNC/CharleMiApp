import '../../main.dart';
import '../assets/colors.dart';
import '../../models/product.dart';
import '../../ressources/screens/home.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../navigation/appbar_back.dart';

class Confirmation extends StatefulWidget {
  const Confirmation({Key? key}) : super(key: key);

  @override
  State<Confirmation> createState() => _ConfirmationState();
}

class _ConfirmationState extends State<Confirmation> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AppBarBack(),
      backgroundColor: darkColor,
    );
  }
}
