import 'home.dart';
import '../loader.dart';
import '../../main.dart';
import '../assets/colors.dart';
import '../../models/product.dart';
import '../render/product_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BrowserPage extends StatefulWidget {
  final HomeState homeState;

  const BrowserPage({Key? key, required this.homeState}) : super(key: key);

  @override
  BrowserPageState createState() => BrowserPageState();
}

class BrowserPageState extends State<BrowserPage> {
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
    return Column(
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
                return Center(child: Text('Aucune catégorie trouvée', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w400)));
              } else {
                return const Center(
                  child: Loader(),
                );
              }
            },
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Product>>(
            future: products,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: snapshot.data!.length,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) => ProductCard(parentWidget: widget.homeState, product: snapshot.data![index]),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Aucun produit trouvé', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w400)));
              } else {
                return const Center(
                  child: Loader(),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  List<Widget> _buildButtons(data) {
    List<Widget> widgets = [];
    for (var category in data) {
      widgets.add(
        ElevatedButton(
          onPressed: () => {setSelectedCategory(data.indexOf(category)), setState(() {})},
          child: Text(
            category,
            style: GoogleFonts.poppins(color: CharlemiappInstance.themeChangeProvider.darkTheme ? Colors.white : Colors.black, fontWeight: FontWeight.w300),
          ),
          style: ButtonStyle(
            backgroundColor: data.indexOf(category) == _selectedCategory
                ? MaterialStateProperty.all(buttonBlueColor)
                : CharlemiappInstance.themeChangeProvider.darkTheme
                    ? MaterialStateProperty.all(midDarkColor)
                    : MaterialStateProperty.all(Colors.white),
            padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      );
      widgets.add(const SizedBox(width: 8));
    }
    return widgets;
  }
}
