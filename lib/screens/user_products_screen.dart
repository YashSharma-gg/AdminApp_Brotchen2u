import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './edit_products_screen.dart';
//import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import '../providers/products.dart';

class UserProductsScreen extends StatefulWidget {
  static const routeName = '/user-product';

  @override
  _UserProductsScreenState createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  var _init = true;
  var categoryId;
  var categoryTitle;


  @override
  void didChangeDependencies() {
    if (_init) {
//      setState(() {
//        _isLoading = true;
//      });

      final routeArgs =
          ModalRoute.of(context)!.settings.arguments as Map<String, String>;
      categoryId = routeArgs['categoryId'];
      categoryTitle = routeArgs['categoryTitle'];

    }
    _init = false;
    super.didChangeDependencies();
  }

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchSet(categoryId);
  }

  @override
  Widget build(BuildContext context) {
    //final productData = Provider.of<Products>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Center(child: Text('$categoryTitle',style: const TextStyle(color: Colors.black54))),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add, color: Colors.black54,),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  EditProductsScreen.routeName,
                  arguments: {
                    'prodId': null,
                    'categoryId': categoryId,
                  },
                );
              },
            ),
          ],
        ),
        //drawer: AppDrawer(),
        body: FutureBuilder(
          future: _refreshProducts(context),
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: () => _refreshProducts(context),
                      child: Consumer<Products>(
                        builder: (ctx, productData, _) => Padding(
                          padding: const EdgeInsets.all(8),
                          child: ListView.builder(
                            itemBuilder: (_, i) {
                              return Column(
                                children: <Widget>[
                                  UserProductItem(
                                    productData.items[i].id,
                                    productData.items[i].title,
                                    productData.items[i].imageUrl,
                                  ),
                                  const Divider(),
                                ],
                              );
                            },
                            itemCount: productData.items.length,
                          ),
                        ),
                      ),
                    ),
        ),
      ),
    );
  }
}