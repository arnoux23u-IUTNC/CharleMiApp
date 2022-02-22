/*import '../../models/cart.dart';
import 'package:flutter/material.dart';

class ShopItems extends StatelessWidget {
  const ShopItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Articles'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/checkout'),
          )
        ],
      ),
      body: const ShopItemsWidget(),
    );
  }
}

class ShopItemsWidget extends StatelessWidget {
  const ShopItemsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: bloc.allItems,
      stream: bloc.getStream,
      builder: (context, snapshot) {
        return ["shop_items"].isNotEmpty ? shopItemsListBuilder(snapshot) : const Center(child: Text("All items in shop have been taken"));
      },
    );
  }
}

Widget shopItemsListBuilder(snapshot) {
  return ListView.builder(
    itemCount: snapshot.data["shop_items"].length,
    itemBuilder: (BuildContext context, i) {
      final shopList = snapshot.data["shop_items"];
      return ListTile(
        title: Text(shopList[i].name),
        subtitle: Text("${shopList[i].price}\€"),
        trailing: IconButton(
          icon: const Icon(Icons.add_shopping_cart),
          onPressed: () {
            bloc.addToCart(shopList[i]);
          },
        ),
        onTap: () {},
      );
    },
  );
}
*/