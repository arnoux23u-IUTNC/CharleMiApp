import '../ressources/assets/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkThemePreference {
  static const themeStatus = "charlemiapp_theme_status";

  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(themeStatus, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(themeStatus) ?? false;
  }
}

class DarkThemeProvider with ChangeNotifier {
  DarkThemePreference darkThemePreference = DarkThemePreference();
  bool _darkTheme = true;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = !value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }
}

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      primaryColor: isDarkTheme ? darkColor : Colors.white,
      cardColor: Colors.white,
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: MaterialStateProperty.all<Color>(
          isDarkTheme ? darkColor : Colors.white,
        ),
        // isAlwaysShown: true,
      ),
      //Contour des input
      highlightColor: isDarkTheme ? Colors.white : Colors.grey,
      focusColor: Colors.blue,
      dialogBackgroundColor: isDarkTheme ? midDarkColor : Colors.white,
      disabledColor: Colors.grey,
      toggleableActiveColor: buttonBlueColor,
      colorScheme: ColorScheme(
        primary: Colors.white,
        secondary: darkColor,
        surface: Colors.white,
        background: Colors.blue,
        error: Colors.orange,
        onPrimary: Colors.white,
        onSecondary: Colors.blue,
        onSurface: isDarkTheme ? Colors.grey : Colors.black,
        onBackground: Colors.black,
        onError: Colors.red,
        brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: isDarkTheme ? midDarkColor : Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: isDarkTheme ? darkColor : Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        errorMaxLines: 2,
        filled: true,
        contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        hintStyle: GoogleFonts.poppins(
          color: greyedFont,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: isDarkTheme ? Colors.white : Colors.grey,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            buttonBlueColor,
          ),
          foregroundColor: MaterialStateProperty.all<Color>(
            Colors.white,
          ),
        ),
      ),
      canvasColor: isDarkTheme ? darkColor : Colors.grey[300],
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(colorScheme: isDarkTheme ? const ColorScheme.dark() : const ColorScheme.light()),
      appBarTheme: AppBarTheme(
        elevation: 0.0,
        foregroundColor: isDarkTheme ? Colors.white : Colors.black,
        backgroundColor: isDarkTheme ? midDarkColor : Colors.white,
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: Colors.white,
        hourMinuteColor: MaterialStateColor.resolveWith((states) => states.contains(MaterialState.selected) ? Colors.blue.shade100 : Colors.grey.shade300),
        hourMinuteTextColor: MaterialStateColor.resolveWith((states) => states.contains(MaterialState.selected) ? Colors.blueAccent : Colors.black),
        dialHandColor: buttonBlueColor,
        dialBackgroundColor: Colors.white,
        dialTextColor: MaterialStateColor.resolveWith((states) => states.contains(MaterialState.selected) ? Colors.white : Colors.black),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: buttonBlueColor,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDarkTheme ? midDarkColor : Colors.white,
        selectedItemColor: colorAmbre,
        unselectedItemColor: buttonBlueColor,
      ),
    );
  }
}
