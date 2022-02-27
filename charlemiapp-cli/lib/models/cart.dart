import 'product.dart';

class Cart {
  Map<Product, int> cartItems = {};

  bool addToCart(product) {
    if (cartItems.containsKey(product)) {
      int qte = cartItems[product]! + 1;
      if (qte > 10) {
        return false;
      }
      cartItems[product] = qte;
      return true;
    } else {
      cartItems.putIfAbsent(product, () => 1);
      return true;
    }
  }

  void removeFromCart(product) {
    if (cartItems.containsKey(product)) {
      int qte = cartItems[product]! - 1;
      if (qte > 0) {
        cartItems[product] = qte;
      } else {
        cartItems.remove(product);
      }
    }
  }
}
