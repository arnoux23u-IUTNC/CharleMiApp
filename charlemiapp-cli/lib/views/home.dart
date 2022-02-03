<<<<<<< HEAD:charlemiapp-cli/lib/ressources/nav.dart
import 'package:charlemiapp_cli/models/user.dart';
import 'package:flutter/material.dart';
import 'package:charlemiapp_cli/widgets/appbar.dart';
import 'package:provider/provider.dart';
import 'screens/authscreen.dart';
=======
import 'package:charlemiapp_cli/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:charlemiapp_cli/views/widgets/appbar_noback.dart';
import 'package:charlemiapp_cli/views/browser/browser_page.dart';
import 'package:charlemiapp_cli/views/user/signInUp_page.dart';
import 'package:charlemiapp_cli/views/shop/overview_page.dart';
>>>>>>> charlemiapp-cli:charlemiapp-cli/lib/views/home.dart

const midDarkColor = Color(0xFF1c2031);
const darkColor = Color(0xFF121421);
const buttonBlueColor = Color(0xFF4a80ef);
const whiteColor = Color(0xFFFFFFFF);

<<<<<<< HEAD:charlemiapp-cli/lib/ressources/nav.dart
class Nav extends StatefulWidget {

  const Nav({Key? key}) : super(key: key);
  static bool loading = false;
  static AppUser? user;
=======
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
>>>>>>> charlemiapp-cli:charlemiapp-cli/lib/views/home.dart

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
<<<<<<< HEAD:charlemiapp-cli/lib/ressources/nav.dart
=======
  static const List<Widget> _widgetOptions = <Widget>[
    BrowserPage(),
    Overview(),
    SignInUp()
  ];
>>>>>>> charlemiapp-cli:charlemiapp-cli/lib/views/home.dart

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Nav.user = Provider.of<AppUser?>(context);
    var screens = [
      const HomeScreen(),
      const ExploreScreen(),
      ((Nav.user != null) ? const ProfileScreen() :  const AuthScreen()),
    ];
    return Scaffold(
<<<<<<< HEAD:charlemiapp-cli/lib/ressources/nav.dart
      appBar: MyAppBar(),
      body: screens[_selectedIndex],
=======
      appBar: const MyAppBarNoBack(),
      body: _widgetOptions[_selectedIndex],
>>>>>>> charlemiapp-cli:charlemiapp-cli/lib/views/home.dart
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
<<<<<<< HEAD:charlemiapp-cli/lib/ressources/nav.dart
            BottomNavigationBarItem(icon: Icon(Icons.explore), label: '', tooltip: 'Discover'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_basket), label: '', tooltip: 'Order'),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: '', tooltip: 'Profile'),
=======
            BottomNavigationBarItem(
              icon: Icon(AppCustomIcons.compass, size: 30,),
              label: '',
              tooltip: 'Discover',
            ),
            BottomNavigationBarItem(
                icon: Icon(AppCustomIcons.shopping_basket, size: 30,), label: '', tooltip: 'Order'),
            BottomNavigationBarItem(
                icon: Icon(AppCustomIcons.user_circle, size: 30,),
                label: '',
                tooltip: 'Profile'),
>>>>>>> charlemiapp-cli:charlemiapp-cli/lib/views/home.dart
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
