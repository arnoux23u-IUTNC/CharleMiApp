import 'package:charlemiapp_cli/ressources/screens/home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product {
  String id, name;
  int qte;
  double price;
  String? image;

  Product({required this.id, required this.name, required this.price, this.qte = 0, String? image});

  String get getId => id;
  String get getName => name;
  int get getQte => qte;
  double get getPrice => price;
  String? get getImage => image;

  static Future<List<Product>> getProducts() async {
    var response = await http.get(Uri.parse('https://europe-west1-charlemi-app.cloudfunctions.net/api/products-list'));
    if(response.statusCode == 200) {
      if(jsonDecode(response.body)["list"] == "No products found") {
        return List<Product>.empty();
      }
      else{
        return List<Product>.from(jsonDecode(response.body)["list"].map((e) => Product.fromJson(e)));
      }
    }
    return List<Product>.empty();
  }

  factory Product.fromJson(dynamic jsonObject) {
    return Product(
        id: jsonObject['id'] as String,
        name: jsonObject['name'] as String,
        qte: int.parse(jsonObject['stock'].toString()),
        price: double.parse(jsonObject['price'].toString()),
        image: jsonObject['image'] as String?
    );
  }



}
