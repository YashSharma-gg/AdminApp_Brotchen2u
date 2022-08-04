import 'package:admin_app/screens/order_history_details.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:admin_app/screens/edit_carousel.dart';

import './providers/user_address.dart';
import './providers/category.dart';
import './providers/products.dart';
import './providers/orders.dart';
import './screens/categories_screen.dart';
import './screens/edit_products_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  static  const MaterialColor my_color =  MaterialColor(
    0xfff1bc4d,
     <int, Color>{
      50: Color(0xfff1bc4d),
      100:Color(0xfff1bc4d),
      200:Color(0xfff1bc4d),
      300:Color(0xfff1bc4d),
      400:Color(0xfff1bc4d),
      500:Color(0xfff1bc4d),
      600:Color(0xfff1bc4d),
      700:Color(0xfff1bc4d),
      800:Color(0xfff1bc4d),
      900:Color(0xfff1bc4d),
    },
  );
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Category(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => UserAddress(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Admin App',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          ////
          primaryColor: const Color(0xff3c5f84),
          indicatorColor:const Color(0xffe77805),
        ),
        home: CategoriesScreen(),
        routes: {
          UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
          EditProductsScreen.routeName: (ctx) => EditProductsScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          EditCarousel.routeName: (ctx) => EditCarousel(),
          OrderHistoryDetails.routeName: (ctx) => OrderHistoryDetails(),

        },
      ),
    );
  }
}