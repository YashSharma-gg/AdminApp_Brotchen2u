import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String categoryId;
  final String amount;
  final double price;
  final double mrp;
  final String imageUrl;
  final String description;
  bool isFavorite;

  Product({
    required this.id,
    required this.categoryId,
    required this.amount,
    required this.title,
    required this.mrp,
    required this.price,
    required this.imageUrl,
    required this.description,
    this.isFavorite = false,
  });

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String userId) async {
    var oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://store-e2e34.firebaseio.com/userFavorites/$userId/$categoryId/$id.json';
    //'?auth=$token';
    try {
      final response = await http.put(
        Uri.parse(url),
        body: json.encode(
          isFavorite,
        ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
  }