import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const midDarkColor = Color(0xFF1c2031);
const darkColor = Color(0xFF121421);
const buttonBlueColor = Color(0xFF4a80ef);
const whiteColor = Color(0xFFFFFFFF);

class MyAppBarBack extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBarBack({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: midDarkColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
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





