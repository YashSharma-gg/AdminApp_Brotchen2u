import '../widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
//import './cart_screen.dart';
import '../widgets/category_grid.dart';
//import '../widgets/badge.dart';
import '../providers/category.dart';
//import '../providers/cart.dart';

class CategoriesScreen extends StatefulWidget {
  static const routeName = '/categories-screen';
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var _catTitle = '';
  @override
  void initState() {
    Provider.of<Category>(context, listen: false).fetchCarousel();
    Provider.of<Category>(context, listen: false).fetchCat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Categories',style: TextStyle(color: Colors.black54),)),
          backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add,color: Colors.black54,),
              onPressed: () async {
                return showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        height: 150,
                        width: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: 180,
                              child: TextField(
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  hintText: 'Enter category Title',
                                  
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _catTitle = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextButton(
                              onPressed: () {
                                Provider.of<Category>(context, listen: false)
                                    .addCategory(_catTitle, '');
                                Navigator.of(context).pop();
                              },

                              style: TextButton.styleFrom(
                                backgroundColor: Colors.orange[400]
                              ),

                              child: const Text('ADD',
                                  style: TextStyle(
                                    color: Colors.white,// colorScheme was accentColor previously
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,

                                  )),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        drawer: AppDrawer(
          
        ),

        body: SingleChildScrollView(
          child: CategoryGrid(),
        ),
      ),
    );
  }
}