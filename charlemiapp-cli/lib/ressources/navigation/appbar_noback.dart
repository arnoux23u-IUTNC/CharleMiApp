import '../assets/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarNoBack extends StatelessWidget implements PreferredSizeWidget {
  const AppBarNoBack({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: midDarkColor,
      title: Text(
        'CharleMi\'App',
        style: GoogleFonts.poppins(
          color: whiteColor,
          fontSize: 22,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}
