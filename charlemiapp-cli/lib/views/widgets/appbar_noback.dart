import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const midDarkColor = Color(0xFF1c2031);
const darkColor = Color(0xFF121421);
const buttonBlueColor = Color(0xFF4a80ef);
const whiteColor = Color(0xFFFFFFFF);

<<<<<<< HEAD:charlemiapp-cli/lib/widgets/appbar.dart
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({Key? key}) : super(key: key);
=======
class MyAppBarNoBack extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBarNoBack({Key? key}) : super(key: key);
>>>>>>> charlemiapp-cli:charlemiapp-cli/lib/views/widgets/appbar_noback.dart

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
