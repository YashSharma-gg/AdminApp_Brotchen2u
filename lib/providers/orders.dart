//import 'package:daily_bag/providers/user_address.dart';
import 'package:admin_app/providers/user_address.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItems> products;
  final DateTime dateTime;
  final String uId;
  final AddressItem addressItem;
  var status;

  OrderItem({
    required this.id,
    required this.products,
    required this.amount,
    required this.dateTime,
    required this.uId,
    required this.addressItem,
    this.status = "Order Requested",
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  //final String authToken;
  //final String userId;

  late String user;
  Orders();

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrder() async {
    //final url = 'https://store-f24d4.firebaseio.com/orders/$userId.json';
    const url = 'https://brotchen2u-a1ad6-default-rtdb.firebaseio.com/order.json';
    //'?auth=$authToken';
    final response = await http.get(Uri.parse(url));
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == {}) {
      return;
    }
    extractedData.forEach((orderId, orderValue) {
      user = orderValue['userId'];
      loadedOrders.add(
        OrderItem(
          //oId: orderId,
          addressItem: AddressItem (id: '', name: '', state: '', contact: '', addLine1: '', addLine2: '', city: '', pincode: ''),
          id: orderId,
          uId: orderValue['userId'],
          products: orderValue['products'] != null
              ? (orderValue['products'] as List<dynamic>)
                  .map(
                    (item) => CartItems(
                      id: item['id'],
                      title: item['title'],
                      price: item['price'],
                      amount: item['amount'],
                      quantity: item['quantity'],
                      imageUrl: item['imageUrl'],
                    ),
                  )
                  .toList()
              : [],
          amount: orderValue['amount'],
          status: orderValue['status'],
          dateTime: DateTime.parse(orderValue['dateTime']),
        ),
      );
      print('order $user');
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> updateOrder(
    String userId,
    String id,
    String stat,
  ) async {
    final index = _orders.indexWhere((ord) => ord.id == id);
    print('Order no. $id');
//    final urlUpdate =
//        'https://store-f24d4.firebaseio.com/finalOrder/$userId/order/$id.json';
//    //'auth=$authToken';
//    await http.patch(
//      urlUpdate,
//      body: json.encode({
//        'status': stat,
//      }),
//    );






    final urlUpdate2 = 'https://brotchen2u-a1ad6-default-rtdb.firebaseio.com/order/$id.json';
    await http.patch(
      Uri.parse(urlUpdate2),
      body: json.encode({
        'status': stat,
      }),
    );
    _orders[index].status = stat;
    notifyListeners();
  }
}