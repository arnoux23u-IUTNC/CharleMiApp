/*import '../../models/cart.dart';
import 'package:flutter/material.dart';

class Checkout extends StatelessWidget {
  const Checkout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panier')),
      body: StreamBuilder(
        stream: bloc.getStream,
        initialData: bloc.allItems,
        builder: (context, snapshot) {
          return ['cart_items'].isNotEmpty
              ? Column(
                  children: <Widget>[
                    Expanded(child: checkoutListBuilder(snapshot)),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("Payer"),
                    ),
                    const SizedBox(height: 40)
                  ],
                )
              : const Center(child: Text("Aucun produit dans le panier"));
        },
      ),
    );
  }
}

Widget checkoutListBuilder(snapshot) {
  return ListView.builder(
    itemCount: snapshot.data["cart_items"].length,
    itemBuilder: (BuildContext context, i) {
      final cartList = snapshot.data["cart_items"];
      return ListTile(
        title: Text(cartList[i].name),
        subtitle: Text("Quantité : ${cartList[i].qte}"),
        trailing: IconButton(
          icon: const Icon(Icons.remove_shopping_cart),
          onPressed: () {
            bloc.removeFromCart(cartList[i]);
          },
        ),
        onTap: () {},
      );
    },
  );
}
*/