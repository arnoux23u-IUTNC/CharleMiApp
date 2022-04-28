import 'cart_page.dart';
import 'auth_page.dart';
import '../../main.dart';
import 'no_internet.dart';
import 'browser_page.dart';
import '../assets/colors.dart';
import '../../models/user.dart';
import '../assets/app_icons.dart';
import '../navigation/appbar_noback.dart';
import '../../services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_offline/flutter_offline.dart';

class Home extends StatefulWidget {
  const Home({Key? key, this.selectedScreen = 0}) : super(key: key);
  static bool loading = false;
  static AppUser? user;
  final int selectedScreen;

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  late int _selectedIndex = widget.selectedScreen;

  static List<Widget> _widgetOptions(state) {
    return <Widget>[BrowserPage(homeState: state), const CartScreen(), const AuthBuilder()];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void notify() {
    setState(() {});
  }

  Widget _buildNavIcon({required IconData icon, required int count}) {
    if (_selectedIndex == 1 || count == 0) {
      return Icon(icon);
    } else {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            icon,
          ),
          Positioned(
            right: -4,
            top: -4,
            child: Container(
              height: 19,
              width: 19,
              decoration: const BoxDecoration(
                color: colorAmbre,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text("$count"),
              ),
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          AuthenticationService.delegate(snapshot.data).then((user) {
            if (user != null) {
              Home.user = user;
            }
          });
        }
        return OfflineBuilder(
          connectivityBuilder: (BuildContext context, ConnectivityResult result, Widget child) {
            final bool connected = result != ConnectivityResult.none;
            return connected
                ? Scaffold(
                    appBar: const AppBarNoBack(),
                    body: _widgetOptions(this)[_selectedIndex],
                    bottomNavigationBar: BottomNavigationBar(
                      showSelectedLabels: false,
                      showUnselectedLabels: false,
                      iconSize: 30,
                      type: BottomNavigationBarType.fixed,
                      enableFeedback: true,
                      items: <BottomNavigationBarItem>[
                        const BottomNavigationBarItem(
                          icon: Icon(
                            AppCustomIcons.compass,
                          ),
                          label: '',
                          tooltip: 'Explore',
                        ),
                        BottomNavigationBarItem(
                          icon: _buildNavIcon(
                            icon: AppCustomIcons.shoppingBasket,
                            count: CharlemiappInstance.cart.cartItems.values.fold(0, (a, b) => a + int.parse(b)),
                          ),
                          label: '',
                          tooltip: 'Cart',
                        ),
                        const BottomNavigationBarItem(
                          icon: Icon(
                            AppCustomIcons.userCircle,
                          ),
                          label: '',
                          tooltip: 'Profile',
                        ),
                      ],
                      currentIndex: _selectedIndex,
                      onTap: _onItemTapped,
                    ),
                  )
                : const NoInternet();
          },
          child: Container(),
        );
      },
    );
  }
}
