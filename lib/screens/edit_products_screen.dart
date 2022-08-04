import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products.dart';

class EditProductsScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductsScreenState createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  var catId;
  final _priceFocusNode = FocusNode();
  final _mrpFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _amountFocusNode = FocusNode();

//  final _imageUrlController = TextEditingController();
//  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _initValue = true;
  var _initProduct = {
    'id' : '',
    'title': '',
    'categoryId': '',
    'amount':'',
    'description':'',
    'imageUrl': '',
    'price': '',
    'mrp': '',
  };
  var _isLoading = false;

  var _editedProduct = Product(
    id: '',
    categoryId: '',
    title: '',
    description: '',
    amount: '',
    price: 0,
    mrp: 0,
    imageUrl: '',
  );

  @override
  void didChangeDependencies() {
    if (_initValue) {
      final routeArgs =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final prodId = routeArgs['prodId'];
      setState(() {
        catId = routeArgs['categoryId'];
        print('XXXXXXXXXXX');
        print(catId);
      });
      if (prodId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(prodId);
        _initProduct = {
          'title': _editedProduct.title,
          'categoryId': _editedProduct.categoryId,

          'description': _editedProduct.description,
          'amount': _editedProduct.amount,
          'imageUrl': _editedProduct.imageUrl,
          'price': _editedProduct.price.toString(),
          'mrp': _editedProduct.mrp.toString(),
        };
      }
    }
    _initValue = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    _mrpFocusNode.dispose();
    _priceFocusNode.dispose();
    _amountFocusNode.dispose();

    super.dispose();
  }

//  void _updateImageUrl() {
//    if (!_imageUrlFocusNode.hasFocus) {
//      if ((_imageUrlController.text.isEmpty) ||
//          (!_imageUrlController.text.startsWith('http') &&
//              !_imageUrlController.text.startsWith('https')) ||
//          (!_imageUrlController.text.endsWith('.jpg') &&
//              !_imageUrlController.text.endsWith('.jpeg') &&
//              !_imageUrlController.text.endsWith('.png'))) {
//        return;
//      }
//      setState(() {});
//    }
//  }

  File? _pickedImage;

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 150,
    );
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
  }

  Future<void> _saveForm() async {
    final _isValid = _form.currentState!.validate();
    if (!_isValid) {
      return;
    }
    _form.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    if (_pickedImage !=null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('products_image')
          .child(DateTime.now().toIso8601String() + '.jpg');

      await ref.putFile(_pickedImage!);

      final url = await ref.getDownloadURL();
      setState(() {
        _editedProduct = Product(
          id: _editedProduct.id,
          description: _editedProduct.description,
          amount: _editedProduct.amount,
          categoryId: _editedProduct.categoryId,
          title: _editedProduct.title,
          price: _editedProduct.price,
          mrp: _editedProduct.mrp,
          imageUrl: url,
          isFavorite: _editedProduct.isFavorite,
        );
      });
    }

    if (_editedProduct.id != '') {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);

      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('An error occurred'),
            content: const Text('Something went wrong'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text(
                  'Okay!',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ],
          ),
        );
      }
//      finally {
//        setState(() {
//          _isLoading = false;
//        });
//        Navigator.of(context).pop();
//      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Center(child: Text('Edit Product',style: TextStyle(color: Colors.black54)),),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save,color: Colors.black54,),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initProduct['title'],
                      decoration: const InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          description:_editedProduct.description ,
                          amount: _editedProduct.amount,
                          categoryId: _editedProduct.categoryId,

                          title: value!,
                          price: _editedProduct.price,
                          mrp: _editedProduct.mrp,
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a title.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initProduct['price'],
                      decoration: const InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_mrpFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a price.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number.';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a price > 0';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          categoryId: _editedProduct.categoryId,

                          description: _editedProduct.description,
                          amount: _editedProduct.amount,
                          title: _editedProduct.title,
                          mrp: _editedProduct.mrp,
                          price: double.parse(value!),
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initProduct['mrp'],
                      decoration: const InputDecoration(labelText: 'MRP'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _mrpFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_amountFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a price.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number.';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a price > 0';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          categoryId: _editedProduct.categoryId,
                          description: _editedProduct.description,
                          amount: _editedProduct.amount,
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          mrp: double.parse(value!),
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initProduct['amount'],
                      decoration: const InputDecoration(labelText: 'amount'),
                      textInputAction: TextInputAction.next,
                      focusNode: _amountFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          categoryId: _editedProduct.categoryId,

                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          amount: _editedProduct.amount,
                          price: _editedProduct.price,
                          mrp: _editedProduct.mrp,
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a title.';
                        }
                        return null;
                      },
                    ),
                    
                    
                    TextFormField(
                      initialValue:
                          catId == null ? _initProduct['categoryId'] : catId,
                      readOnly: true,
                      decoration: const InputDecoration(labelText: 'categoryId'),
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a description.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          categoryId: value!,

                          description: _editedProduct.description,
                          amount: _editedProduct.amount,
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          mrp: _editedProduct.mrp,
                          imageUrl: _editedProduct.imageUrl,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    
                    Column(
                      children: <Widget>[
                        Container(
                            height: 100,
                            width: 100,
                            //padding: const EdgeInsets.all(8.0),
                            margin: const EdgeInsets.only(
                              top: 8,
                              right: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                            child: _pickedImage == null &&
                                    _editedProduct.imageUrl == ''
                                ? const Padding(
                                    padding:  EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        'Upload Product Image',
                                      ),
                                    ),
                                  )
                                : FittedBox(
                                    fit: BoxFit.fill,
                                    child: _editedProduct.imageUrl != ''
                                        ? Image.network(
                                            _editedProduct.imageUrl,
//                      fit: BoxFit.cover,
                                          )
                                        : Image.file(_pickedImage!),
                                    
                                  )),
                        TextButton.icon(
                          style: TextButton.styleFrom(textStyle: TextStyle(color:Theme.of(context).primaryColor )),
                          onPressed: _pickImage,
                          icon: const Icon(Icons.image),
                          label: const Text('Upload Image'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}