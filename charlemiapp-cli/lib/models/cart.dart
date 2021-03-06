import 'product.dart';
import '../ressources/screens/home.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Cart {
  Cart() {
    SharedPreferences.getInstance().then((sp) {
      var data = sp.getString('charlemiapp-cart-instance');
      if (data != null) {
        var json = jsonDecode(data);
        if (json['cart'] != null && json['expiration'] > DateTime.now().millisecondsSinceEpoch) {
          cartItems = fromMap(json['cart']);
        } else {
          sp.remove('charlemiapp-cart-instance');
        }
      }
    });
  }

  Map<Product, String> cartItems = {};

  Object addToCart(product) {
    if (product.stock < 1) {
      return "STOCK";
    }
    if (!(Home.user?.estBoursier ?? false) && product.necessiteBoursier) {
      return "TARIF";
    }
    if (cartItems.containsKey(product)) {
      int qte = int.parse(cartItems[product]!) + 1;
      if (qte > 10) {
        return "LIMIT";
      }
      product.stock -= 1;
      cartItems[product] = qte.toString();
      saveToSP(cartItems);
      return true;
    } else {
      product.stock -= 1;
      cartItems.putIfAbsent(product, () => "1");
      saveToSP(cartItems);
      return true;
    }
  }

  void removeFromCart(product) {
    if (cartItems.containsKey(product)) {
      int qte = int.parse(cartItems[product]!) - 1;
      if (qte > 0) {
        cartItems[product] = qte.toString();
      } else {
        cartItems.remove(product);
      }
    }
    saveToSP(cartItems);
  }

  static void saveToSP(cart) async {
    var sp = await SharedPreferences.getInstance();
    var data = {};
    data['cart'] = toJson(cart);
    data['expiration'] = DateTime.now().add(const Duration(minutes: 15)).millisecondsSinceEpoch;
    await sp.setString("charlemiapp-cart-instance", jsonEncode(data));
  }

  static toJson(cart) {
    var array = [];
    cart.forEach((key, value) {
      array.add({
        'product': [key.id, key.name, key.price, key.description, key.diminutif, key.calories, key.imageURL, key.necessiteBoursier, key.stock],
        'qte': value
      });
    });
    return array;
  }

  Map<Product, String> fromMap(json) {
    var cart = <Product, String>{};
    json.forEach((item) {
      cart.putIfAbsent(
        Product(
          id: item['product'][0],
          name: item['product'][1],
          price: item['product'][2],
          description: item['product'][3],
          diminutif: item['product'][4],
          calories: item['product'][5],
          imageURL: item['product'][6],
          necessiteBoursier: item['product'][7] ?? false,
          stock: item['product'][8] ?? -1,
        ),
        () => item['qte'],
      );
    });
    return cart;
  }

  double total() {
    double total = 0.0;
    cartItems.forEach((key, value) {
      total += key.getPrice * int.parse(value);
    });
    return total;
  }

  void cache() {}

  void clearCart() {
    cartItems.clear();
    saveToSP(cartItems);
  }
}
