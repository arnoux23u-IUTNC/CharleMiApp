import '../assets/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarBack extends StatelessWidget implements PreferredSizeWidget {
  const AppBarBack({Key? key}) : super(key: key);

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
