import 'package:flutter/material.dart';
import './category_items.dart';
import 'package:provider/provider.dart';
import '../providers/category.dart' show Category;

class CategoryGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final categories = Provider.of<Category>(context).category;
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      //color: Colors.black12,
    //  height: deviceSize.height - 350,
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: categories.length,
        itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
          value: categories[index],
          child: CategoryItems(
//          products[index].id,
//          products[index].title,
//          products[index].imageUrl,
              ),
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
      ),
    );
  }
}