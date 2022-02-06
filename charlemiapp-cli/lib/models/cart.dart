import 'product.dart';
import 'dart:async';

class CartItemsBloc {
  final cartStreamController = StreamController.broadcast();

  Stream get getStream => cartStreamController.stream;

  Map allItems = {
    'shop_items': [
      Product(id: "0001", name: "Sandwich Fermier", price: 9.0),
      Product(id: "0002", name: "Sandwich Fermier", price: 9.0),
      Product(id: "0003", name: "Sandwich Fermier", price: 9.0),
      Product(id: "0004", name: "Sandwich Fermier", price: 9.0),
      Product(id: "0005", name: "Sandwich Fermier", price: 9.0),
      Product(id: "0006", name: "Sandwich Fermier", price: 9.0),
    ],
    'cart_items': []
  };

  final cartList = ["cart_items"];

  void addToCart(product) {
    int present = 0;
    for (int i = 0; i < allItems['cart_items'].length; i++) {
      var element = allItems['cart_items'][i];
      if (element.id == product.id) {
        present = 1;
        var newProduct = Product(id: element.id, name: element.name, price: element.price, qte: element.qte + 1);
        allItems['cart_items'].remove(element);
        allItems['cart_items'].add(newProduct);
      }
    }
    if (present == 0) {
      allItems['cart_items'].add(product);
    }
    if (allItems['cart_items'].length == 0) {
      allItems['cart_items'].add(product);
    }
    num total = 0;
    for (int i = 0; i < allItems['cart_items'].length; i++) {
      var element = allItems['cart_items'][i];
      var price = element.price;
      var qte = element.qte;
      total += price * qte;
    }
    //total a ajouter au panier
    print("total is $total");
    cartStreamController.sink.add(allItems);
  }

  void removeFromCart(product) {
    var newProduct = Product(id: product.id, name: product.name, price: product.price, qte: product.qte - 1);
    if (newProduct.qte < 1) {
      allItems['cart_items'].remove(product);
    } else {
      var i = allItems['cart_items'].indexOf(product);
      allItems['cart_items'].insert(i, newProduct);
      allItems['cart_items'].remove(product);
    }
    num total = 0;
    for (int i = 0; i < allItems['cart_items'].length; i++) {
      var element = allItems['cart_items'][i];
      var price = element.price;
      var qte = element.qte;
      total += price * qte;
    }
    //total a ajouter au panier
    print("total is  : $total");
    cartStreamController.sink.add(allItems);
  }

  void dispose() {
    cartStreamController.close(); // close our StreamController
  }
}

final bloc = CartItemsBloc();
