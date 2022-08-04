import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import '../models/http_exception.dart';
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  //final String authToken;
//  final String userId;
//  Products(this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favorites {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchSet(String cId) async {
    final filterString = 'orderBy="categoryId"&equalTo="$cId"';
    var url = 'https://brotchen2u-a1ad6-default-rtdb.firebaseio.com/products.json?$filterString';
    print('All Okay' + cId);
    try {
      final response = await http.get(Uri.parse(url));
      print(response.body);
      final List<Product> loadedProducts = [];
      //print(response.body);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == {}) {
        return;
      }
//      url =
//          'https://store-f24d4.firebaseio.com/userFavorites/$userId/$cId.json';
      //'?auth=$authToken';
      //final favoriteResponse = await http.get(url);
      //print(favoriteResponse.body);
      // print('0');
      //final favoriteData = json.decode(favoriteResponse.body);
      // print('1');
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            categoryId: prodData['categoryId'],
            title: prodData['title'],
            description: prodData['description'],
            amount: prodData['amount'],
            mrp: prodData['mrp'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
//            isFavorite:
//                favoriteData == null ? false : favoriteData[prodId] ?? false,
            // ?? checks if favoriteData[prodId] is null then false
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
      //print(_items.where((prod) => prod.isFavorite).toList()[1].title);
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = 'https://brotchen2u-a1ad6-default-rtdb.firebaseio.com/products.json';
    //'?auth=$authToken';
    try {
      final response = await http.post(
       Uri.parse(url),
        body: json.encode({
          'title': product.title,
          'price': product.price,
          'mrp': product.mrp,
          'categoryId': product.categoryId,
          'imageUrl': product.imageUrl,
          'description': product.description,
          'amount': product.amount,
        }),
      );

      final _newProduct = Product(
        id: json.decode(response.body)['name'],
        categoryId: product.categoryId,
        title: product.title,
        price: product.price,
        mrp: product.mrp,
        imageUrl: product.imageUrl,
        description: product.description,
        amount: product.amount,

        
      );
      _items.add(_newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final index = _items.indexWhere((prod) => prod.id == id);
    print(index);
    final urlUpdate = 'https://brotchen2u-a1ad6-default-rtdb.firebaseio.com/products/$id.json';
    //'auth=$authToken';
    await http.patch(
      Uri.parse(urlUpdate),
      body: json.encode({
        'title': newProduct.title,
        'price': newProduct.price,
        'mrp': newProduct.mrp,
        'categoryId': newProduct.categoryId,
        'imageUrl': newProduct.imageUrl,
        'description': newProduct.description,
        'amount': newProduct.amount,
      }),
    );
    _items[index] = newProduct;
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final url = 'https://brotchen2u-a1ad6-default-rtdb.firebaseio.com/products/$id.json';
    //'?auth=$authToken';
    //_items.removeWhere((prod) => prod.id == id);
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    final response = await http.delete(Uri.parse(url));
    _items.removeAt(existingProductIndex);
    notifyListeners();
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      //throw HttpException('Could not delete');
    }
    existingProduct = Product(mrp: 0,price:0 ,id: '',title: '',categoryId: '',imageUrl: '', amount: '', description: '') ;
  }
}