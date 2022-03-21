class TransactionData {
  String date, category, type;
  String? description = "", notes = "";
  double amount;
  List<String?>? tags;

  TransactionData({
    required this.date,
    required this.category,
    required this.amount,
    required this.type,
    this.description,
    this.tags,
    this.notes,
  });

  factory TransactionData.fromJson(dynamic jsonObject) {
    return TransactionData(
      date: jsonObject['date'] as String,
      category: jsonObject['category'] as String,
      amount: double.parse(jsonObject['amount'].toString()),
      type: jsonObject['type'] as String,
      description: jsonObject['description'] as String?,
      tags: List<String>.from(jsonObject["tags"]),
      notes: jsonObject['notes'] as String?,
    );
  }

  static String transform(String? data) {
    switch (data) {
      case "PRODUCTS":
        return "Commande";
      case "ADD":
        return "Ajout de fonds";
      case "REMOVE":
        return "Retrait de fonds";
      default:
        return "Transaction";
    }
  }
}
