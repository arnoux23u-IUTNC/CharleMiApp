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
  int _selectedCategory = 0;
  late Future<List<String>> categories;
  late Future<List<Product>> products;

  @override
  void initState() {
    products = Product.getProducts("Sandwichs");
    categories = Product.getCategories();
    super.initState();
  }

  void setSelectedCategory(int index) async {
    setState(() {
      _selectedCategory = index;
    });
    products = Product.getProducts((await categories)[_selectedCategory]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: darkColor,
        child: Column(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 5),
              scrollDirection: Axis.horizontal,
              child: FutureBuilder<List<String>>(
                future: categories,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Row(
                      children: _buildButtons(snapshot.data),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text('Aucune catégorie trouvée',
                            style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400)));
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              //top padings
            ),
            Expanded(
                child: FutureBuilder<List<Product>>(
                    future: products,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return GridView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            itemCount: snapshot.data!.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 0.75,
                            ),
                            itemBuilder: (context, index) => ProductCard(product: snapshot.data![index]));
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text('Aucun produit trouvé',
                                style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400)));
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    })),
          ],
        ));
  }

  List<Widget> _buildButtons(data) {
    List<Widget> widgets = [];
    for (var category in data) {
      widgets.add(ElevatedButton(
        onPressed: () => {setSelectedCategory(data.indexOf(category)), setState(() {})},
        child: Text(
          category,
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w300),
        ),
        style: ButtonStyle(
          backgroundColor: data.indexOf(category) == _selectedCategory
              ? MaterialStateProperty.all(buttonBlueColor)
              : MaterialStateProperty.all(midDarkColor),
          padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ));
      widgets.add(const SizedBox(width: 8));
    }
    return widgets;
  }
}
