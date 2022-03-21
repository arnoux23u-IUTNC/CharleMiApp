import 'colors.dart';
import 'package:flutter/material.dart';

const urlAPI = 'https://europe-west1-charlemi-app.cloudfunctions.net/api';

ButtonStyle btnDefaultStyle([bool smallPaddings = false]) {
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.all(buttonBlueColor),
    padding: MaterialStateProperty.all(EdgeInsets.all(smallPaddings ? 10 : 17)),
    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
  );
}
