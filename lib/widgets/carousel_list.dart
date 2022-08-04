import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:admin_app/widgets/carousel_item.dart';
import '../providers/category.dart';

class CarouselList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final carousels = Provider.of<Category>(context).carouselImg;
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      //color: Colors.black12,
      height: deviceSize.height,
      child: ListView.builder(
        itemCount: carousels.length,
        itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
          value: carousels[index],
          child: CarouselItems(),
        ),
      ),
    );
  }
}