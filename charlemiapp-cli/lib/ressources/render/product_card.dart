import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Expanded(
        child: ClipRRect(
          child: Image.asset(product.image ?? 'assets/food.jpg'),
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
