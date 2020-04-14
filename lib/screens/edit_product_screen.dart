import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _categoriesFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var dropDownValue = Categories.Uncategorized;
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
    category: Categories.Uncategorized,
  );

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
    'category': Categories.Uncategorized,
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
          'category': _editedProduct.category,
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  final List<String> quotes = [
    "'Do what you can, with what you have, where you are.' —Theodore Roosevelt",
    "'Begin somewhere; you cannot build a reputation on what you intend to do.' —Liz Smith",
    "'Do not wait until the conditions are perfect to begin. Beginning makes the conditions perfect.' —Alan Cohen",
    "'The beginning is the most important part of the work.' —Plato",
    "'Don't wait for the right moment to start, start and make each moment right.'― Roy T. Bennett",
    "'Selling is a sacred trust between buyer and seller.'",
  ];

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Wrap(
                    children: <Widget>[
                      Icon(Icons.error),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Unexpected Error'),
                    ],
                  ),
                  content: Text(
                      'Something went wrong, the error has been reported to the space station.'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Okay'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    )
                  ],
                ));
      } 
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    // print(_editedProduct.title);
    // print(_editedProduct.category);
    // print(_editedProduct.description);
    // print(_editedProduct.id);
    // print(_editedProduct.imageUrl);
    // print(_editedProduct.price);
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _saveForm,
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
                strokeWidth: 6,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(
                          labelText: 'Title',
                          hintText: 'The name of your product',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            title: value.trim(),
                            category: _editedProduct.category,
                            description: _editedProduct.description,
                            id: _editedProduct.id,
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price,
                            isFavourite: _editedProduct.isFavourite,
                          );
                        },
                        validator: (value) {
                          if (value.trim().isEmpty) {
                            return 'Title cannot be empty';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: InputDecoration(
                          labelText: 'Price',
                          hintText: 'The price displayed to the customer',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            title: _editedProduct.title,
                            category: _editedProduct.category,
                            description: _editedProduct.description,
                            id: _editedProduct.id,
                            imageUrl: _editedProduct.imageUrl,
                            price: double.parse(value),
                            isFavourite: _editedProduct.isFavourite,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Price cannot be empty';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          if (double.parse(value) <= 0) {
                            return 'The price should be greater than 0';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                          initialValue: _initValues['description'],
                          decoration: InputDecoration(
                            labelText: 'Description',
                            hintText: 'Detailed description for the product',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          focusNode: _descriptionFocusNode,
                          validator: (value) {
                            if (value.trim().isEmpty) {
                              return 'Description cannot be empty';
                            }
                            if (value.trim().length < 10) {
                              return 'Description must be longer than 10 characters';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                              title: _editedProduct.title,
                              category: _editedProduct.category,
                              description: value.trim(),
                              id: _editedProduct.id,
                              imageUrl: _editedProduct.imageUrl,
                              price: _editedProduct.price,
                              isFavourite: _editedProduct.isFavourite,
                            );
                          }),
                      SizedBox(
                        height: 15,
                      ),
                      DropdownButtonFormField(
                        hint: Text('Select a Category'),
                        value: _initValues['category'],
                        icon: Icon(Icons.keyboard_arrow_down),
                        iconSize: 25,
                        // elevation: 5,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusColor: Colors.deepPurple,
                        ),
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 15,
                        ),
                        // onChanged: ,
                        items: <DropdownMenuItem>[
                          DropdownMenuItem(
                            value: Categories.Clothing,
                            child: Text('Clothing'),
                          ),
                          DropdownMenuItem(
                            value: Categories.Kitchen,
                            child: Text('Kitchen'),
                          ),
                          DropdownMenuItem(
                            value: Categories.Home,
                            child: Text('Home'),
                          ),
                          DropdownMenuItem(
                            value: Categories.Electronics,
                            child: Text('Electronics'),
                          ),
                          DropdownMenuItem(
                            value: Categories.Kids,
                            child: Text('Kids'),
                          ),
                          DropdownMenuItem(
                            value: Categories.Uncategorized,
                            child: Text('Uncategorized'),
                          ),
                        ],
                        onSaved: (value) {
                          _editedProduct = Product(
                            title: _editedProduct.title,
                            category: value,
                            description: _editedProduct.description,
                            id: _editedProduct.id,
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price,
                            isFavourite: _editedProduct.isFavourite,
                          );
                        },
                        onChanged: (value) {
                          _initValues['category'] = value;
                          setState(() {
                            // value;
                          });
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 15, right: 15),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Center(child: Text('Enter a URL'))
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: FittedBox(
                                      fit: BoxFit.cover,
                                      child: Image.network(
                                          _imageUrlController.text),
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              // initialValue: _initValues['imageUrl'],
                              decoration: InputDecoration(
                                labelText: 'Image URL',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              onFieldSubmitted: (_) {
                                setState(() {});
                                _saveForm();
                              },
                              focusNode: _imageUrlFocusNode,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'URL cannot be empty';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'Please enter a valid URL';
                                }
                                if (!value.endsWith('.jpg') &&
                                    !value.endsWith('.jpeg')) {
                                  return 'The enter a valid image (JPG or JPEG) URL';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _editedProduct = Product(
                                  title: _editedProduct.title,
                                  category: _editedProduct.category,
                                  description: _editedProduct.description,
                                  id: _editedProduct.id,
                                  imageUrl: value,
                                  price: _editedProduct.price,
                                  isFavourite: _editedProduct.isFavourite,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: Center(
                            child: Text(
                          (quotes.toList()..shuffle()).first,
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
