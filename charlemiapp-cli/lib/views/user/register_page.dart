import 'package:charlemiapp_cli/views/widgets/appbar_back.dart';
import 'package:flutter/material.dart';

const midDarkColor = Color(0xFF1c2031);
const darkColor = Color(0xFF121421);
const buttonBlueColor = Color(0xFF4a80ef);

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const MyAppBarBack(),
        body: Container(
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
                            'Submit',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(buttonBlueColor),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(17)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12)))),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ));
  }
}
