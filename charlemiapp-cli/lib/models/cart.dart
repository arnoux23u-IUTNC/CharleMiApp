import 'product.dart';

class Cart {

  Map<Product, int> cartItems = {
    Product(id: "P0007", name: "Sandwich F", price: 12.0): 1,
    Product(id: "P0008", name: "Sandwich P", price: 15.5): 2,
    Product(id: "P0009", name: "Sandwich K", price: 5.5): 3,
  };

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
