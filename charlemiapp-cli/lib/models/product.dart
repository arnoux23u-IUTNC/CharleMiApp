import 'package:charlemiapp_cli/ressources/screens/home.dart';

import '../ressources/assets/const.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product {
  String id, name;
  double price;
  String? imageURL;

  Product({required this.id, required this.name, required this.price, this.imageURL});

  String get getId => id;

  String get getName => name;

  double get getPrice => price;

  static Future<List<Product>> getProducts() async {
    var response = await http.get(Uri.parse(urlAPI + '/products-list'));
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)["list"] == "No products found") {
        return List<Product>.empty();
      } else {
        return List<Product>.from(jsonDecode(response.body)["list"].map((e) => Product.fromJson(e)));
      }
    }
    return List<Product>.empty();
  }

  factory Product.fromJson(dynamic jsonObject) {
    return Product(
        id: jsonObject['id'] as String,
        name: jsonObject['name'] as String,
        price: double.parse(jsonObject['price'].toString()),
        imageURL: jsonObject['image'] as String?);
  }

  toJson() {
    return {
      'product_id': id,
      'qte': Home.cart.cartItems[this]
    };
  }
}
