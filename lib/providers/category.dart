import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoryItem with ChangeNotifier {
  final String id;
  final String title;
 final String imageUrl;

  CategoryItem({
    required this.id,
    required this.title,
   required this.imageUrl,
  });
}

class CarouselItem with ChangeNotifier {
  final String carouselId;
  final String carouselImage;


  CarouselItem({
    required this.carouselId,
    required this.carouselImage,

  });
}

class Category with ChangeNotifier {
//  String authToken;
//  Category(this.authToken);
  List<CategoryItem> _category = [];
  List<CarouselItem> _carouselImg = [];

  List<CategoryItem> get category {
    return [..._category];
  }


  List<CarouselItem> get carouselImg {
    return [..._carouselImg];
  }

  Future<void> fetchCat() async {
    const url = 'https://brotchen2u-a1ad6-default-rtdb.firebaseio.com/category.json';
    //'?auth=$authToken';
    final response = await http.get(Uri.parse(url),);
    //print(response.body);
    final List<CategoryItem> loadedCategories = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == {}) {
      return;
    }
    extractedData.forEach((categoryId, catValue) {
      loadedCategories.add(
        CategoryItem(
          id: categoryId,
          title: catValue['title'],
         imageUrl: catValue['imageUrl'],
        ),
      );
    });
    _category = loadedCategories;
    notifyListeners();
  }

  Future<void> addCategory(String title, String imageUrl) async {
    const url = 'https://brotchen2u-a1ad6-default-rtdb.firebaseio.com/category.json';
    //'?auth=$authToken';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'title': title,
          'imageUrl': imageUrl,
        }),
      );

      _category.insert(
        0,
        CategoryItem(
          id: json.decode(response.body)['name'],
          title: title,
          imageUrl: imageUrl,

        ),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

 
  Future<void> fetchCarousel() async {
    const url = 'https://brotchen2u-a1ad6-default-rtdb.firebaseio.com/carousel.json';
    //'?auth=$authToken';
    final response = await http.get(Uri.parse(url),);
    //print(response.body);
    final List<CarouselItem> loadedCarousel = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == {}) {
      return;
    }
    extractedData.forEach((carId, carValue) {
      loadedCarousel.add(
        CarouselItem(
          carouselId: carId,
          carouselImage: carValue['imgUrl'],

        ),
      );
    });
    _carouselImg = loadedCarousel;
    notifyListeners();
  }

  Future<void> addCarouselImage(String carouselUrl) async {
    const url = 'https://brotchen2u-a1ad6-default-rtdb.firebaseio.com/carousel.json';
    //'?auth=$authToken';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'imgUrl': carouselUrl,
        }),
      );

//      final _newCarouselImage = carouselUrl;
      _carouselImg.insert(
        0,
        CarouselItem(
          carouselId: json.decode(response.body)['name'],
          carouselImage: carouselUrl,
        ),
      );
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<void> removeCarouselImage(String id) async {
    final url = 'https://brotchen2u-a1ad6-default-rtdb.firebaseio.com/carousel/$id.json';
    //'?auth=$authToken';
    final existingCarouselIndex =
        _carouselImg.indexWhere((prod) => prod.carouselId == id);
    var existingCarousel = _carouselImg[existingCarouselIndex];
    final response = await http.delete(Uri.parse(url),);
    _carouselImg.removeAt(existingCarouselIndex);
    notifyListeners();
    if (response.statusCode >= 400) {
      _carouselImg.insert(existingCarouselIndex, existingCarousel);
      notifyListeners();
//      throw HttpException('Could not delete');
    }
    existingCarousel = CarouselItem(carouselId: '', carouselImage: '');
  }
}