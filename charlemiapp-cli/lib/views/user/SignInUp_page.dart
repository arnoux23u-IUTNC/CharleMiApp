import 'package:charlemiapp_cli/views/user/register_page.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';

const midDarkColor = Color(0xFF1c2031);
const darkColor = Color(0xFF121421);
const buttonBlueColor = Color(0xFF4a80ef);

class SignInUp extends StatefulWidget {
  const SignInUp({Key? key}) : super(key: key);

  @override
  _SignInUpState createState() => _SignInUpState();
}

class _SignInUpState extends State<SignInUp> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: darkColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Image.asset("assets/logo_white.png"),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        left: 55, right: 55, top: 30, bottom: 15),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()),
                        );
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(buttonBlueColor),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(17)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)))),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(left: 55, right: 55, bottom: 35),
                    child: TextButton(
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Register()),
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
