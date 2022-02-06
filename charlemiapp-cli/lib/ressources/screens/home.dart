import '../assets/colors.dart';
import '../assets/app_icons.dart';
import '../screens/browser_page.dart';
import '../screens/auth_page.dart';
import '../screens/overview_page.dart';
import '../navigation/appbar_noback.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:charlemiapp_cli/models/user.dart';

class Home extends StatefulWidget {
  const Home({Key? key, this.selectedScreen = 0}) : super(key: key);
  static bool loading = false;
  static AppUser? user;
  final int selectedScreen;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late int _selectedIndex = widget.selectedScreen;

  static const List<Widget> _widgetOptions = <Widget>[BrowserPage(), Overview(), AuthBuilder()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //Home.user = Provider.of<AppUser?>(context);
    return Scaffold(
      appBar: const MyAppBarNoBack(),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: Theme(
        data: ThemeData(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          enableFeedback: true,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                AppCustomIcons.compass,
                size: 30,
              ),
              label: '',
              tooltip: 'Discover',
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  AppCustomIcons.shoppingBasket,
                  size: 30,
                ),
                label: '',
                tooltip: 'Order'),
            BottomNavigationBarItem(
                icon: Icon(
                  AppCustomIcons.userCircle,
                  size: 30,
                ),
                label: '',
                tooltip: 'Profile'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          unselectedItemColor: buttonBlueColor,
          onTap: _onItemTapped,
          backgroundColor: midDarkColor,
        ),
      ),
    );
  }
}
