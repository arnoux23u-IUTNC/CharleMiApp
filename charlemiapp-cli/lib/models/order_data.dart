import 'package:flutter/material.dart';

class OrderData {
  String timestamp, status, withdrawal;
  String? instructions;
  double total;
  Map<String, int> items;

  OrderData(
      {required this.timestamp,
      required this.status,
      required this.withdrawal,
      required this.items,
      required this.total,
      this.instructions});

  factory OrderData.fromJson(dynamic jsonObject) {
    return OrderData(
      timestamp: jsonObject['timestamp'] as String,
      status: jsonObject['status'] as String,
      withdrawal: jsonObject['instructions']['withdrawal'] as String,
      items: _arrayMap(jsonObject['items']),
      total: jsonObject['total'] as double,
      instructions: jsonObject['instructions']['notes'] as String?,
    );
  }

  static Map<String, int> _arrayMap(List<dynamic> items) {
    Map<String, int> map = {};
    for (var item in items) {
      map[item['name']] = int.parse(item['qte']);
    }
    return map;
  }

  static String transform(String status) {
    switch (status) {
      case "PENDING":
        return "En attente";
      case "WAITING":
        return "Préparation";
      case "DONE":
        return "Prête";
      default:
        return "Annulée";
    }
  }

  static Color color(String status) {
    switch (status) {
      case "PENDING":
        return Colors.grey;
      case "WAITING":
        return Colors.orange;
      case "DONE":
        return Colors.green;
      default:
        return Colors.redAccent;
    }
  }

  static String transformDate(String s) {
    return s.split(" ")[1].substring(0, 5);
  }
}
