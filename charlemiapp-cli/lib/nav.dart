import 'package:flutter/material.dart';
import 'package:charlemiapp_cli/widgets/appbar.dart';

const midDarkColor = Color(0xFF1c2031);
const darkColor = Color(0xFF121421);
const buttonBlueColor = Color(0xFF4a80ef);
const whiteColor = Color(0xFFFFFFFF);

class Nav extends StatefulWidget {
  const Nav({Key? key}) : super(key: key);

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    /* DiscoverPage(),
    ChartsPage(),
    ProfilePage() */
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: new Column(
        children: [
          new ElevatedButton(onPressed: () {}, child: new Text("Connexion")),
          new ElevatedButton(onPressed: () {}, child: new Text("Inscription"))
        ],
      ),
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
                icon: Icon(Icons.explore), label: '', tooltip: 'Discover'),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_basket), label: '', tooltip: 'Order'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: '',
                tooltip: 'Profile'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          unselectedItemColor: buttonBlueColor,
          onTap: _onItemTapped,
          backgroundColor: const Color(0xff1C2031),
        ),
      ),
    );
  }
}
