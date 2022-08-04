import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:admin_app/screens/user_products_screen.dart';
import '../providers/category.dart';

class CategoryItems extends StatelessWidget {
//  final String id;
//  final String imageUrl;
//  final String title;
//
//  CategoryItems(this.id, this.title, this.imageUrl);
  @override
  Widget build(BuildContext context) {
    final categoryItem = Provider.of<CategoryItem>(context);
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
//      height: 50,
      width: MediaQuery.of(context).size.width * 0.45,
      
      // margin: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        
        onPressed: () {
          Navigator.of(context).pushNamed(
           UserProductsScreen.routeName,
            arguments: {
              'categoryId':categoryItem.id,
              'categoryTitle':categoryItem.title
              }
            
          );
        },style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          
          
          
        ),
        primary: Colors.orange[400]), 
        child: Container(
          
          constraints: const BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
          alignment: Alignment.center,
          
          child: Text(
            categoryItem.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );

    

  }
  
}