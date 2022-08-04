import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category.dart';

class CarouselItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    final _carItem = Provider.of<CarouselItem>(context);
    return GestureDetector(
      onLongPress: () async{
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Are you Sure?',),
            content: const Text('Do you want to remove this item?',),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  'No',
                  style: TextStyle(color: Colors.orange)
                ),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    await Provider.of<Category>(context, listen: false)
                        .removeCarouselImage(_carItem.carouselId);
                    Navigator.of(context).pop(true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Image removed from carousel!',
                          textAlign: TextAlign.center,
                          
                        ),
                      ),
                    );
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Deleting failed!',
                          textAlign: TextAlign.center,
                          
                        ),
                      ),
                    );
                  }
                },
                child: Text(
                  'Yes',
                  style: TextStyle(color: Colors.orange)
                ),
              ),
            ],
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          height: 200,
          width: double.infinity,
          child: Card(
            elevation: 4,
            child: Image.network(
              _carItem.carouselImage,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}