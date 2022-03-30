import '../../main.dart';
import 'assets/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitRing(
        color: CharlemiappInstance.themeChangeProvider.darkTheme ? Colors.white : buttonBlueColor,
        size: 50.0,
        lineWidth: 3.0,
      ),
    );
  }
}
