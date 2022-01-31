import 'package:flutter/material.dart';

const midDarkColor = Color(0xFF1c2031);
const darkColor = Color(0xFF121421);
const buttonBlueColor = Color(0xFF4a80ef);

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        left: 55, right: 55, top: 30, bottom: 15),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO Sign In Guillaume
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(buttonBlueColor),
                          padding:
                          MaterialStateProperty.all(const EdgeInsets.all(17)),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)
                          ))
                      ),
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
                        // TODO Guillaume Sign Up
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


