class Product {
  String id, name;
  int qte;
  double price;
  String? image;

  Product({required this.id, required this.name, required this.price, this.qte = 0});
}
