import '../../main.dart';
import '../../models/product.dart';
import '../../ressources/assets/const.dart';
import '../../ressources/assets/colors.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  InkWell buildImage(BuildContext context) {
    return InkWell(
      onTap: () => {
        showDialog(
          context: context,
          builder: (BuildContext context) => _buildAddToCartPopUp(context),
        )
      },
      child: Image.asset('assets/products/${product.id}.png',
          errorBuilder: (c, e, s) =>
              Image.network(product.imageURL, errorBuilder: (c, e, s) => Image.asset("assets/products/default.png"))),
    );
  }

  Widget _buildAddToCartPopUp(BuildContext context) {
    return AlertDialog(
        backgroundColor: midDarkColor,
        title: Row(
          children: [
            Text(
              product.getName,
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            IconButton(
              padding: const EdgeInsets.all(0),
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
        content: Column(
          children: [
            Image.asset('assets/products/${product.id}.png',
                errorBuilder: (c, e, s) =>
                    Image.network(product.imageURL, errorBuilder: (c, e, s) => Image.asset("assets/products/default.png"))),
            const Padding(padding: EdgeInsets.fromLTRB(0, 30, 0, 0)),
            Text(
              "${NumberFormat("0.00", "fr_FR").format(product.price)}€",
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const Padding(padding: EdgeInsets.fromLTRB(0, 30, 0, 0)),
            Text(
              //TODO PRODUCT DESCRIPTION
              "Aucune description disponible",
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
            )
          ],
        ),
        actions: <Widget>[
          ElevatedButton.icon(
            icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
            onPressed: () {
              if (!CharlemiappInstance.cart.addToCart(product)) {
                Fluttertoast.showToast(
                  msg: "Impossible d'ajouter plus",
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 1,
                );
              }
              Navigator.pop(context);
            },
            label: Text(
              'Ajouter au panier',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
            ),
            style: defaultButtonStyle,
          ),
        ],
        actionsAlignment: MainAxisAlignment.center);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 0,
          child: ClipRRect(
            child: buildImage(context),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Text(
          product.name,
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        Row(
          children: [
            Text(
              "${NumberFormat("0.00", "fr_FR").format(product.price)}€",
              style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Material(
                //TODO ANIMATION CLIC
                child: IconButton(
                  alignment: Alignment.centerRight,
                  color: Colors.white,
                  padding: const EdgeInsets.all(0),
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.add_shopping_cart),
                  onPressed: () {
                    CharlemiappInstance.cart.addToCart(product);
                  },
                ),
                color: Colors.transparent),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        )
      ],
    );
  }
}
