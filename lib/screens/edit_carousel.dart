import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:admin_app/providers/category.dart';
import 'package:admin_app/widgets/app_drawer.dart';
import 'package:admin_app/widgets/carousel_list.dart';

class EditCarousel extends StatefulWidget {
  static const routeName = '/edit-carousel';

  @override
  _EditCarouselState createState() => _EditCarouselState();
}

class _EditCarouselState extends State<EditCarousel> {
  var _isLoading = false;
  late File _pickedImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _isLoading = true;
    });
    Provider.of<Category>(context, listen: false).fetchCarousel().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
    );
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });

    final ref = FirebaseStorage.instance
        .ref()
        .child('carousel_image')
        .child(DateTime.now().toIso8601String() + '.jpg');

    await ref.putFile(_pickedImage);

    final url = await ref.getDownloadURL();

    Provider.of<Category>(context, listen: false).addCarouselImage(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Center(child: Text('Edit Carousel', style: TextStyle(color: Colors.black54),)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _pickImage,
            color: Colors.black54,
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : CarouselList(),
    );
  }
}