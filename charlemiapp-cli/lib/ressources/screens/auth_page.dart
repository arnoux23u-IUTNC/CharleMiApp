import 'home.dart';
import 'login_page.dart';
import '../../main.dart';
import 'profile_page.dart';
import 'register_page.dart';
import 'forgotpassword_page.dart';
import '../../ressources/assets/const.dart';
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
    });
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: Image.asset(
                  CharlemiappInstance.themeChangeProvider.darkTheme ? "assets/logo_white.png" : "assets/logo_black.png",
                  height: MediaQuery.of(context).size.height * 0.4,
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      flex: 0,
                      child: Container(
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
                            style: TextStyle(fontSize: 18),
                          ),
                          style: btnDefaultStyle(),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 55, right: 55, bottom: 35),
                        child: TextButton(
                          child: Text(
                            "Inscription",
                            style: TextStyle(fontSize: 18, color: CharlemiappInstance.themeChangeProvider.darkTheme ? Colors.white : Colors.black),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const Register()),
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 55, right: 55, bottom: 35),
                        child: TextButton(
                          child: const Text(
                            "Mot de passe oublié ?",
                            style: TextStyle(fontSize: 18),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ForgotPassword()),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
