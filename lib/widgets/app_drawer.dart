//import '../screens/tnc.dart';

//import '../screens/about_us.dart';

//import '../screens/cart_screen.dart';

//import '../screens/edit_address_screen.dart';
import 'package:flutter/material.dart';
import 'package:admin_app/screens/edit_carousel.dart';
//import '../providers/auth.dart';
import 'package:admin_app/screens/orders_screen.dart';
//import '../providers/user_address.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  var id = '';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            backgroundColor: Colors.white,
            title: const Center(
            child: Text('Hey, Admin!', style: TextStyle(color: Colors.black54),),
            ),
            automaticallyImplyLeading: false,
          ),
          SizedBox(height: 8,),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
//          Divider(),
//          ListTile(
//            leading: Icon(Icons.location_on),
//            title: Text('Manage Address'),
//            onTap: () {
////              setState(() {
////                _init = true;
////              });
//              id != null
//                  ? Navigator.of(context).pushNamed(
//                      EditAddressScreen.routeName,
//                      arguments: id,
//                    )
//                  : Navigator.of(context).pushNamed(
//                      EditAddressScreen.routeName,
//                    );
//            },
//          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('View Orders'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
         const Divider(),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Edit Carousel'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(EditCarousel.routeName);
            },
          ),
          const Divider(),
//          ListTile(
//            leading: Icon(Icons.shopping_cart),
//            title: Text('Your Cart'),
//            onTap: () {
//              Navigator.of(context).pushReplacementNamed(CartScreen.routeName);
//            },
//          ),
//          Divider(),
//          ListTile(
//            leading: Icon(Icons.person),
//            title: Text('About Us'),
//            onTap: () {
//              Navigator.of(context).pushReplacementNamed(AboutUs.routeName);
//            },
//          ),
//          Divider(),
//          ListTile(
//            leading: Icon(Icons.info_outline),
//            title: Text('Terms & Conditions'),
//            onTap: () {
//              Navigator.of(context)
//                  .pushReplacementNamed(TermsAndConditions.routeName);
//            },
//          ),
//          Divider(),
//          ListTile(
//            leading: Icon(Icons.exit_to_app),
//            title: Text('Logout'),
//            onTap: () {
//              Navigator.of(context).pop();
//              Navigator.of(context).pushReplacementNamed('/');
//              Provider.of<Auth>(context, listen: false).logout();
//            },
//          ),
//          Divider(),
        ],
      ),
    );
  }
}