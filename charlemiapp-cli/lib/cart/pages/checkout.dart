import 'package:flutter/material.dart';
import 'package:cart/cart/bloc/cart_items_bloc.dart';

class Checkout extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Panier')),
      body: StreamBuilder(
        stream: bloc.getStream,
        initialData: bloc.allItems,
        builder: (context, snapshot) {
          return ['cart items'].length > 0
              ? Column(
                  children: <Widget>[
                    Expanded(child: checkoutListBuilder(snapshot)),
                    RaisedButton(
                      onPressed: () {},
                      child: Text("Payer"),
                      color: Colors.white,
                    ),
                    SizedBox(height: 40)
                  ],
                )
              : Center(child: Text("Aucun produit dans le panier"));
        },
      ),
    );
  }
}

Widget checkoutListBuilder(snapshot) {
  return ListView.builder(
    itemCount: snapshot.data["cart items"].length,
    itemBuilder: (BuildContext context, i) {
      final cartList = snapshot.data["cart items"];
      return ListTile(
        title: Text(cartList[i].name),
        subtitle: Text("Quantité : ${cartList[i].qte}"),
        trailing: IconButton(
          icon: Icon(Icons.remove_shopping_cart),
          onPressed: () {
            bloc.removeFromCart(cartList[i]);
          },
        ),
        onTap: () {},
      );
    },
  );
}
