import '../screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarNoBack extends StatelessWidget implements PreferredSizeWidget {
  const AppBarNoBack({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'CharleMi\'App',
        style: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w300,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.settings_outlined,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Settings(),
              ),
            );
          },
        ),
      ],
    );
  }
}
