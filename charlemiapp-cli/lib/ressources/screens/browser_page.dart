import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/product.dart';
import '../render/product_card.dart';

class BrowserPage extends StatefulWidget {
  const BrowserPage({Key? key}) : super(key: key);

  @override
  _BrowserPageState createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  late Future<List<Product>> products;

  @override
  void initState() {
    products = Product.getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: products,
      builder: _buildProducts,
    );
  }

  Widget _buildProducts(BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
    if (snapshot.hasData) {
      return Container(
        padding: const EdgeInsets.all(16),
          child: GridView.builder(
              itemCount: snapshot.data!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 22,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) => ProductCard(product: snapshot.data![index])));
    } else if (snapshot.hasError) {
      return Center(
          child: Text('Aucune produit trouvé',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400)));
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
