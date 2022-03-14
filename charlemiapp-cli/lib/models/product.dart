import '../main.dart';
import '../ressources/assets/const.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Product {
  String id, name, diminutif, description, calories;
  double price;
  String imageURL;
  bool necessiteBoursier;

  Product(
      {required this.id,
      required this.name,
      required this.price,
      required this.description,
      required this.diminutif,
      required this.calories,
      required this.imageURL,
      required this.necessiteBoursier});

  String get getId => id;

  String get getName => name;

  double get getPrice => price;

  static Future<List<Product>> getProducts(String category) async {
    var response = await http.get(Uri.parse(urlAPI + '/products-list?category=$category'));
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)["list"] == "No products found") {
        return List<Product>.empty();
      } else {
        return List<Product>.from(jsonDecode(response.body)["list"].map((e) => Product.fromJson(e)));
      }
    }
    return List<Product>.empty();
  }

  static Future<List<String>> getCategories() async {
    var response = await http.get(Uri.parse(urlAPI + '/product-categories'));
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)["categories"] == "No categories found") {
        return List<String>.empty();
      } else {
        return List<String>.from(jsonDecode(response.body)["categories"]);
      }
    }
    return List<String>.empty();
  }

  factory Product.fromJson(dynamic jsonObject) {
    return Product(
      id: jsonObject['id'] as String,
      name: jsonObject['name'] as String,
      price: double.parse(jsonObject['price'].toString()),
      imageURL: jsonObject['image'] as String? ?? "null",
      necessiteBoursier: jsonObject['boursier'] as bool? ?? false,
      calories: jsonObject['calories'] as String? ?? "Cal : NC",
      description: jsonObject['description'] as String? ?? "Aucune description disponible",
      diminutif: jsonObject['diminutif'] as String? ?? jsonObject['name'],
    );
  }

  toJson() {
    return {'product_id': id, 'qte': CharlemiappInstance.cart.cartItems[this]};
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, price: $price, imageURL: $imageURL, necessiteBoursier: $necessiteBoursier}';
  }

  equals(Product other) {
    return id == other.id;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          price == other.price &&
          imageURL == other.imageURL &&
          necessiteBoursier == other.necessiteBoursier;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ price.hashCode ^ imageURL.hashCode;
}
