import 'package:admin_app/screens/order_history_details.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:clipboard_manager/clipboard_manager.dart';
import 'dart:math';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' as ord;
import '../providers/user_address.dart';

class OrderItem extends StatefulWidget {
  final ord.OrderItem orders;
  final int index;

  OrderItem(this.orders, this.index);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  var _expanded2 = false;
  var _init = true;
  var _isLoading = false;
  var add;
  var status;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    print('init ${widget.orders.id}');
    Provider.of<UserAddress>(context, listen: false)
        .fetchAddress(widget.orders.uId)
        .then((_) {
      setState(() {
        add = Provider.of<UserAddress>(context, listen: false).address;
        _isLoading = false;
      });
    });
    super.initState();
  }

//  @override
//  void didChangeDependencies() {
//    if (_init) {
//      Provider.of<UserAddress>(context, listen: false)
//          .fetchAddress(widget.orders.uId);
//       _init = false;
//    }
//    super.didChangeDependencies();
//  }

  @override
  void didUpdateWidget(OrderItem oldWidget) {
    // TODO: implement didUpdateWidget

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    print('main');
    print('final ${widget.orders.uId}');
    print('after uid');
    //add = Provider.of<UserAddress>(context).address;
    //print('${add.name}');

    var totalOrder = "Order no.: ${widget.index + 1000} \n";

    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Card(
            margin: const EdgeInsets.all(10),
            
            child: Column(
              children: <Widget>[
                ListTile(
                  ///////////////////////////////////////////////////////////////////////////
                  
                  onTap: (){
                    Navigator.of(context).pushNamed(OrderHistoryDetails.routeName);
                  },//_showEditDialog,
                  leading: CircleAvatar(
                    backgroundColor: Colors.orange[400],
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: FittedBox(
                        child: Text('${widget.index + 1000}', style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  ),
                  title: Text(
                    //'Rs. ${widget.orders.amount.toStringAsFixed(2)}',
                    '${this.add.name}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Rs. ${widget.orders.amount}'),
                      Text(
                        DateFormat('dd-MM-yy HH:mm')
                            .format(widget.orders.dateTime),
                      ),
                      Text(
                        'Status: ${widget.orders.status}',
                      ),
                    ],
                  ),
                  trailing: FittedBox(
                    child: Column(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            _expanded ? Icons.expand_less : Icons.expand_more,
                            //size: 10,
                          ),
                          onPressed: () {
                            setState(() {
                              _expanded = !_expanded;
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            _expanded2 ? Icons.expand_less : Icons.expand_more,
                            // size: 10,
                          ),
                          onPressed: () {
                            setState(() {
                              _expanded2 = !_expanded2;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                if (_expanded && !_expanded2)
                  Container(
                    height: min(widget.orders.products.length * 20.0 + 50, 150),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 4,
                    ),
                    child: SingleChildScrollView(
                      child: widget.orders.products != []
                          ? Column(
                              children: <Widget>[
                                SizedBox(
                                  height: min(
                                      widget.orders.products.length * 20.0 + 10,
                                      100),
                                  child: ListView(
                                    children:
                                        widget.orders.products.map((prod) {
                                      totalOrder = totalOrder +
                                          "${prod.title} \t ${prod.quantity} x Rs. ${prod.amount} \n";
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            '${prod.title}',
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '${prod.quantity} x Rs. ${prod.price}',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
//                          FlatButton(
//                            onPressed: () {
//                              ClipboardManager.copyToClipBoard(totalOrder)
//                                  .then((result) {
//                                final snackBar = SnackBar(
//                                  content: Text('Copied to Clipboard'),
//                                  action: SnackBarAction(
//                                    label: 'Undo',
//                                    onPressed: () {},
//                                  ),
//                                );
//                                Scaffold.of(context).showSnackBar(snackBar);
//                              });
//                            },
//                            child: Text('COPY ORDER'),
//                          ),
                              ],
                            )
                          : Container(),
                    ),
                  ),
                if (!_expanded && _expanded2)
                  Container(
                    height: 120,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 2,
                    ),
                    child: ListView(
                      children: <Widget>[
                        Text('Contact: ${this.add.contact}'),
                        Text('Address Line 1: ${this.add.addLine1}'),
                        Text('Address Line 2: ${this.add.addLine2}'),
                        Text('Landmark: ${this.add.state}'),
                        Text('City: ${this.add.city}'),
                        Text('Pincode: ${this.add.pincode}'),
                      ],
                    ),
                  ),
              ],
            ),
          );
  }




  // Here it was Future<bool> before which gave an error
  Future<dynamic> _showEditDialog() {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Change Status'),
        content: TextField(
          decoration: const InputDecoration(labelText: 'Status'),
          onChanged: (value) {
            this.status = value;
          },
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.orange[400]
            ),
            onPressed: () {
              Provider.of<ord.Orders>(context, listen: false)
                  .updateOrder(widget.orders.uId, widget.orders.id, this.status)
                  .then((_) {
                Navigator.of(context).pop();
              });
            },
            child:const Text(
              'Okay',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}