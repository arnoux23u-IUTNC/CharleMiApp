import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarBack extends StatelessWidget implements PreferredSizeWidget {
  const AppBarBack(this._title, {Key? key}) : super(key: key);

  final String? _title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        _title ?? 'CharleMi\'App',
        style: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}
