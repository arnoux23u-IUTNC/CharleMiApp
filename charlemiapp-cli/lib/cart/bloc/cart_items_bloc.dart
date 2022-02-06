import 'dart:async';
import 'package:cart/cart/product.dart';

class CartItemsBloc {
  final cartStreamController = StreamController.broadcast();

  Stream get getStream => cartStreamController.stream;

  Map allItems = {
    'shop items': [
      Product("Sandwich Fermier", 9.0, 1, 1),
      Product("Panini poulet", 9.0, 2, 1),
      Product("Banane", 2.0, 3, 1),
      Product("Donuts chocolat", 5.0, 4, 1),
    ],
    'cart items': []
  };

  final cartList = ["cart items"];

  void addToCart(product) {
    int present = 0;
    for (int i = 0; i < allItems['cart items'].length; i++) {
      var element = allItems['cart items'][i];
      if (element.id == product.id) {
        present = 1;
        var newProduct = Product(element.name, element.price, element.id, element.qte + 1);
        allItems['cart items'].remove(element);
        allItems['cart items'].add(newProduct);
      }
    }
    if (present == 0) {
      allItems['cart items'].add(product);
    }
    if (allItems['cart items'].length == 0 ){
      allItems['cart items'].add(product);
    }
    num total = 0;
    for (int i = 0; i < allItems['cart items'].length; i++) {
      var element = allItems['cart items'][i];
      var price = element.price;
      var qte = element.qte;
      total += price*qte;
    }
    //total a ajouter au panier
    print(total);
    cartStreamController.sink.add(allItems);
  }

  void removeFromCart(product) {
    var newProduct = Product(product.name, product.price, product.id, product.qte -1);
    if (newProduct.qte <1){
      allItems['cart items'].remove(product);
    }else{
      var i = allItems['cart items'].indexOf(product);
      allItems['cart items'].insert(i, newProduct);
      allItems['cart items'].remove(product);
    }
    num total = 0;
    for (int i = 0; i < allItems['cart items'].length; i++) {
      var element = allItems['cart items'][i];
      var price = element.price;
      var qte = element.qte;
      total += price*qte;
    }
    //total a ajouter au panier
    print(total);
    cartStreamController.sink.add(allItems);
  }

  void dispose() {
    cartStreamController.close(); // close our StreamController
  }
}

final bloc = CartItemsBloc();
