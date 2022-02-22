import '../ressources/screens/home.dart';
import '../ressources/assets/const.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/product.dart';

Future<String> placeOrder(List<Product> items) async {
  var encodedBody = json.encode({"items": items});
  var response = await http.post(Uri.parse(/*urlAPI*/ 'http://192.168.0.4:5564/api/place-order'),
      headers: {'x-auth-token': Home.user!.uid, 'Content-Type': 'application/json'}, body: encodedBody);
  return response.statusCode == 200 ? "response.body" : "null";
}
