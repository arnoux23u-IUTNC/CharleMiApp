import 'cart_page.dart';
import 'auth_page.dart';
import 'no_internet.dart';
import 'browser_page.dart';
import '../assets/colors.dart';
import '../../models/user.dart';
import '../assets/app_icons.dart';
import '../navigation/appbar_noback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

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

  static const List<Widget> _widgetOptions = <Widget>[BrowserPage(), CartScreen(), AuthBuilder()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      connectivityBuilder: (BuildContext context, ConnectivityResult result, Widget child) {
        final bool connected = result != ConnectivityResult.none;
        return connected
            ? Scaffold(
                appBar: const AppBarNoBack(),
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
              )
            : const NoInternet();
      },
      child: Container(),
    );
  }
}
