import 'package:charlemiapp_cli/views/widgets/appbar_noback.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_icons.dart';
import '../models/user.dart';
import 'screens/authscreen.dart';
import '../views/browser/browser_page.dart';
import '../views/shop/overview_page.dart';
import '../views/user/signInUp_page.dart';


const midDarkColor = Color(0xFF1c2031);
const darkColor = Color(0xFF121421);
const buttonBlueColor = Color(0xFF4a80ef);
const whiteColor = Color(0xFFFFFFFF);

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static bool loading = false;
  static AppUser? user;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    BrowserPage(),
    Overview(),
    SignInUp()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Home.user = Provider.of<AppUser?>(context);
    var screens = [
      const HomeScreen(),
      const ExploreScreen(),
      ((Home.user != null) ? const ProfileScreen() : const AuthScreen()),
    ];
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
                  AppCustomIcons.shopping_basket,
                  size: 30,
                ),
                label: '',
                tooltip: 'Order'),
            BottomNavigationBarItem(
                icon: Icon(
                  AppCustomIcons.user_circle,
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
