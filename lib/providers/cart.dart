import 'package:flutter/foundation.dart';

class CartItems {
  final String id;
  final String title;
  final double price;
  final int quantity;
  final String amount;
  final String imageUrl;

  CartItems({
    required this.id,
    required this.title,
    required this.price,
    required this.amount,
    required this.quantity,
    required this.imageUrl,
  });
}