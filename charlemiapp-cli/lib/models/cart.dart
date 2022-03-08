import 'product.dart';
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

  bool addToCart(product) {
    if (cartItems.containsKey(product)) {
      int qte = int.parse(cartItems[product]!) + 1;
      if (qte > 10) {
        return false;
      }
      cartItems[product] = qte.toString();
      saveToSP(cartItems);
      return true;
    } else {
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
        'product': [key.id, key.name, key.price, key.imageURL],
        'qte': value
      });
    });
    return array;
  }

  Map<Product, String> fromMap(json) {
    var cart = <Product, String>{};
    json.forEach((item) {
      cart.putIfAbsent(
        Product(id: item['product'][0], name: item['product'][1], price: item['product'][2], imageURL: item['product'][3]),
        () => item['qte'],
      );
    });
    return cart;
  }

  void cache() {}
}
