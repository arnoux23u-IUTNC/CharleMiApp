import 'package:charlemiapp_cli/models/cart.dart';
import 'package:flutter/material.dart';

import '../../models/product.dart';
import '../assets/colors.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: darkColor,
      child: Column(children: <Widget>[
        Expanded(
            child: Container(
          height: MediaQuery.of(context).size.height,
          color: darkColor,
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Center(
                  child: Column(
                children: _buildElements(),
              )),
            ),
          ),
        ))
      ]),
    );
  }

  List<Widget> _buildElements() {
    CartItemsBloc cart = CartItemsBloc();
    List<Product> items = cart.cartList;
    List<Widget> res = List.empty(growable: true);

    for (Product element in items) {
      res.add(Container(
        color: midDarkColor,
        child: Text(element.getName),
      ));
    }
    return res;
  }
}
