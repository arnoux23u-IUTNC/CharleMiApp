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

  ConstrainedBox buildImage(BuildContext context) {
    return ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: InkWell(
            onTap: () => {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => _buildAddToCartPopUp(context),
                  )
                },
            child: Image.asset('assets/products/${product.id}.png',
                errorBuilder: (c, e, s) => Image.network("${product.imageURL}", errorBuilder: (c, e, s) => Image.asset("assets/products/default.png")))));
  }

  Widget _buildAddToCartPopUp(BuildContext context) {
    return AlertDialog(
      title: const Text('Ajouter ce produit au panier?'),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () async {

          },
          child: const Text('Oui'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: buildImage(context),
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
