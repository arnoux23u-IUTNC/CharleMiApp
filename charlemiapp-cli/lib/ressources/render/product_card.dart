import '../../models/product.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  Image buildImage() {
    return Image.asset('assets/products/${product.id}.png',
        errorBuilder: (c, e, s) =>
            Image.network("${product.imageURL}", errorBuilder: (c, e, s) => Image.asset("assets/products/default.png")));
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: buildImage(),
        ),
      ),
      Text(
        product.name,
        style: GoogleFonts.poppins(color: Colors.white),
      ),
      Text(
        "${NumberFormat("0.00", "fr_FR").format(product.price)}€",
        style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
      )
    ]);
  }
}
