import 'product.dart';
import 'dart:async';

class Cart {
  final cartStreamController = StreamController.broadcast();

  Stream get getStream => cartStreamController.stream;

/*Map items = {
    /*'cart_items': [
      /*Product(id: "0007", name: "Sandwich F", price: 12.0),
      Product(id: "0008", name: "Sandwich P", price: 15.5),
      Product(id: "0008", name: "Sandwich K", price: 5.5),
      ]*/
  };*/*/
  //create list with one product

  List<Product> cartItems = [
    Product(id: "P0007", name: "Sandwich F", price: 12.0, qte: 3),
    Product(id: "P0008", name: "Sandwich P", price: 15.5, qte: 1),
    Product(id: "P0009", name: "Sandwich K", price: 5.5, qte: 3),
  ];

  //increment by 1 quantity
  void addQuantity(product) {
    product.qte = product.qte + 1;
  }

  //decrement by 1 quantity
  void removeQuantity(product) {
    product.qte = product.qte - 1;
    if (product.qte == 0) {
      removeFromCart(product);
    }
  }

  //remove product from cart
  void removeFromCart(product) {
    cartItems.remove(product);
  }

  /*void addToCart(product) {
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
  }*/

  void dispose() {
    cartStreamController.close(); // close our StreamController
  }
}
