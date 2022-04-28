import '../models/product.dart';
import '../ressources/assets/const.dart';
import '../ressources/screens/home.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:charlemiapp_cli/main.dart';

Future<String> placeOrder(String withdrawTime, String instructions, Map<Product, String> items) async {
  var arrayItems = [];
  items.forEach((key, value) {
    arrayItems.add({'product_id': key.id, 'qte': value});
  });
  var encodedBody = json.encode({
    "items": arrayItems,
    "total": CharlemiappInstance.cart.total(),
    "time": withdrawTime,
    "instructions": instructions,
  });
  var response =
      await http.post(Uri.parse(urlAPI + '/place-order'), headers: {'x-auth-token': Home.user!.uid, 'Content-Type': 'application/json'}, body: encodedBody);
  return response.body;
}
