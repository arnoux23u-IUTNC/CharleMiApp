import 'colors.dart';
import 'package:flutter/material.dart';

const urlAPI = 'https://europe-west1-charlemi-app.cloudfunctions.net/api';

var defaultButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(buttonBlueColor),
    padding: MaterialStateProperty.all(const EdgeInsets.all(17)),
    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));
