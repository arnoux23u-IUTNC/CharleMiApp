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
  late Future<List<Product>> products;
  bool _hasBeenPressedSandwich = false;
  bool _hasBeenPressedBoissons = false;
  bool _hasBeenPressedViennoiseries = false;
  bool _hasBeenPressedPlatsChauds = false;
  bool _hasBeenPressedDesserts = false;
  bool _hasBeenPressedPetiteFaim = false;

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

  List<Widget> _buildFiltersButtons() {
    List<Widget> buttonsFilter = List.empty(growable: true);

    buttonsFilter.add(Container(
      padding: const EdgeInsets.all(5),
      child: ElevatedButton(
        onPressed: () => {
          setState(() {
            _hasBeenPressedSandwich = !_hasBeenPressedSandwich;
          })
        },
        style: ButtonStyle(
          backgroundColor: _hasBeenPressedSandwich ? MaterialStateProperty.all(buttonBlueColor) : MaterialStateProperty.all(midDarkColor),
        ),
        child: Text(
          "Sandwichs",
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w300),
        ),
      ),
    ));
    buttonsFilter.add(Container(
      padding: const EdgeInsets.all(5),
      child: ElevatedButton(
        onPressed: () => {
          setState(() {
            _hasBeenPressedBoissons = !_hasBeenPressedBoissons;
          })
        },
        style: ButtonStyle(
          backgroundColor: _hasBeenPressedBoissons ? MaterialStateProperty.all(buttonBlueColor) : MaterialStateProperty.all(midDarkColor),
        ),
        child: Text(
          "Boissons",
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w300),
        ),
      ),
    ));
    buttonsFilter.add(Container(
      padding: const EdgeInsets.all(5),
      child: ElevatedButton(
        onPressed: () => {
          setState(() {
            _hasBeenPressedViennoiseries = !_hasBeenPressedViennoiseries;
          })
        },
        style: ButtonStyle(
          backgroundColor: _hasBeenPressedViennoiseries ? MaterialStateProperty.all(buttonBlueColor) : MaterialStateProperty.all(midDarkColor),
        ),
        child: Text(
          "Viennoiseries",
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w300),
        ),
      ),
    ));
    buttonsFilter.add(Container(
      padding: const EdgeInsets.all(5),
      child: ElevatedButton(
        onPressed: () => {
          setState(() {
            _hasBeenPressedPlatsChauds = !_hasBeenPressedPlatsChauds;
          })
        },
        style: ButtonStyle(
          backgroundColor: _hasBeenPressedPlatsChauds ? MaterialStateProperty.all(buttonBlueColor) : MaterialStateProperty.all(midDarkColor),
        ),
        child: Text(
          "Plats Chauds",
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w300),
        ),
      ),
    ));
    buttonsFilter.add(Container(
      padding: const EdgeInsets.all(5),
      child: ElevatedButton(
        onPressed: () => {
          setState(() {
            _hasBeenPressedDesserts = !_hasBeenPressedDesserts;
          })
        },
        style: ButtonStyle(
          backgroundColor: _hasBeenPressedDesserts ? MaterialStateProperty.all(buttonBlueColor) : MaterialStateProperty.all(midDarkColor),
        ),
        child: Text(
          "Desserts",
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w300),
        ),
      ),
    ));
    buttonsFilter.add(Container(
      padding: const EdgeInsets.all(5),
      child: ElevatedButton(
        onPressed: () => {
          setState(() {
            _hasBeenPressedPetiteFaim = !_hasBeenPressedPetiteFaim;
          })
        },
        style: ButtonStyle(
          backgroundColor: _hasBeenPressedPetiteFaim ? MaterialStateProperty.all(buttonBlueColor) : MaterialStateProperty.all(midDarkColor),
        ),
        child: Text(
          "Petites faims",
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w300),
        ),
      ),
    ));

    return buttonsFilter;
  }

  Widget _buildProducts(BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
    if (snapshot.hasData) {
      return Container(
          color: darkColor,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                  child: GridView.count(
                crossAxisCount: 3,
                children: _buildFiltersButtons(),
              )),
              Expanded(
                  child: GridView.builder(
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
      return Center(child: Text('Aucune produit trouvé', style: GoogleFonts.poppins(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400)));
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
