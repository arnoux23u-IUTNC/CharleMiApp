import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'nav.dart';

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: midDarkColor,
      child: const Center(
        child: SpinKitRing(
          color: Colors.white,
          size: 50.0,
        ),
      ),
    );
  }
}
