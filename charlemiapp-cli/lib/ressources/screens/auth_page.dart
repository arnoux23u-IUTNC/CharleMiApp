import 'home.dart';
import 'login_page.dart';
import 'profile_page.dart';
import 'register_page.dart';
import '../assets/colors.dart';
import 'forgotpassword_page.dart';
import 'package:flutter/material.dart';

class AuthBuilder extends StatelessWidget {
  const AuthBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Home.user == null) {
      return const AuthPage();
    } else {
      return const ProfilePage();
    }
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    setState(() {
      Home.loading = false;
      Home.user = null;
    });
    return Container(
      color: darkColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Image.asset("assets/logo_white.png", height: MediaQuery.of(context).size.height * 0.4),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 55, right: 55, top: 0, bottom: 15),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Login()),
                        );
                      },
                      child: const Text(
                        'Connexion',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(buttonBlueColor),
                          padding: MaterialStateProperty.all(const EdgeInsets.all(17)),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 55, right: 55, bottom: 35),
                    child: TextButton(
                      child: const Text(
                        "Inscription",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Register()),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 55, right: 55, bottom: 35),
                    child: TextButton(
                      child: const Text(
                        "Mot de passe oublié ?",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ForgotPassword()),
                        );
                      },
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
