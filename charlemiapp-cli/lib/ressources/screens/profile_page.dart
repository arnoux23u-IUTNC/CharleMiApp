import 'home.dart';
import '../loader.dart';
import '../../services/authentication.dart';
import 'package:flutter/material.dart';

final AuthenticationService _auth = AuthenticationService();

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) => Home.loading
      ? const Loader()
      : Center(
          child: Column(children: [
            Text('Bonjour ${Home.user?.lastName} ${Home.user?.firstName}'),
            ElevatedButton(
                onPressed: () async => {
                      setState(() {
                        Home.loading = true;
                      }),
                      await _auth.signOut(),
                      setState(() {
                        Home.loading = false;
                        Home.user = null;
                      }),
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Home(selectedScreen: 2)), (route) => false)
                    },
                child: const Text('Log out'))
          ]),
        );
}
