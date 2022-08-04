import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddressItem{
  final String id;
  final String name;
  final String contact;

  final String addLine1;
  final String addLine2;
  final String state;
  final String city;
  final String pincode;

  AddressItem({
    required this.id,
    required this.name,
    required this.state,
    required this.contact,
    required this.addLine1,
    required this.addLine2,

    required this.city,
    required this.pincode,
  });
}

class UserAddress with ChangeNotifier {
  List<AddressItem> _address = [];
  //final String authToken;

//  final String userId;
//  UserAddress(this.userId);

  AddressItem get address {
    return _address.first;
  }

  Future<void> fetchAddress(String userId) async {
    print('111');
    final url = 'https://brotchen2u-a1ad6-default-rtdb.firebaseio.com/address/$userId/.json';
//    final url =
//        'https://store-f24d4.firebaseio.com/finalOrder/$userId/address.json';
    //'?auth=$authToken';
    final response = await http.get(Uri.parse(url));
    final List<AddressItem > loadedAddress = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == {}) {
      return;
    }
    extractedData.forEach((addressId, addressValue) {
      loadedAddress.add(
        AddressItem (
          id: addressId,
          name: addressValue['name'],
          contact: addressValue['contact'],
          state: addressValue['state'],
          addLine1: addressValue['addLine1'],
          addLine2: addressValue['addLine2'],
          city: addressValue['city'],
  
          pincode: addressValue['pincode'],
        ),
      );
    });
    _address = loadedAddress;
    notifyListeners();
  }
  }