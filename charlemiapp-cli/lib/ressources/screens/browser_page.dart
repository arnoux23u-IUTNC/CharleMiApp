import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/product.dart';
import '../render/product_card.dart';
import '../assets/colors.dart';

class BrowserPage extends StatefulWidget {
  const BrowserPage({Key? key}) : super(key: key);

  @override
  _BrowserPageState createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  String category = "Sandwichs";
  late Future<List<Product>> products;

  @override
  void initState() {
    products = Product.getProducts();
    super.initState();
  }

  void setSelectedCategory(String category) {
    setState(() {
      category = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: products,
      builder: _buildProducts,
    );
  }

  ElevatedButton _buildButton(String text) {
    return ElevatedButton(
      onPressed: () => setSelectedCategory(text),
      child: Text(
        text,
        style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w300),
      ),
      style: ButtonStyle(
        backgroundColor: category == text ? MaterialStateProperty.all(buttonBlueColor) : MaterialStateProperty.all(midDarkColor),
        padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildButtons() {
    return [
      _buildButton("Sandwichs"),
      const SizedBox(width: 8),
      _buildButton("Viennoiseries"),
      const SizedBox(width: 8),
      _buildButton("Plats chauds"),
      const SizedBox(width: 8),
      _buildButton("Desserts"),
      const SizedBox(width: 8),
      _buildButton("Petites faim"),
      const SizedBox(width: 8),
      _buildButton("Boissons")
    ];
  }

  Widget _buildProducts(BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
    if (snapshot.hasData) {
      return Container(
          color: darkColor,
          child: Column(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 5),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _buildButtons(),
                ),
                //top padings
              ),
              Expanded(
                  child: GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      itemCount: snapshot.data!.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.75,
                      ),
                      itemBuilder: (context, index) => ProductCard(product: snapshot.data![index])))
            ],
          ));
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
