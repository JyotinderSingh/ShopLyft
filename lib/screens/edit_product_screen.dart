import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../providers/product.dart';

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

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
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
      setState(() {});
    }
  }

  void _saveForm() {
    _form.currentState.save();
    print(_editedProduct.title);
    print(_editedProduct.category);
    print(_editedProduct.description);
    print(_editedProduct.id);
    print(_editedProduct.imageUrl);
    print(_editedProduct.price);
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
      body: Padding(
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
                      title: value,
                      category: _editedProduct.category,
                      description: _editedProduct.description,
                      id: null,
                      imageUrl: _editedProduct.imageUrl,
                      price: _editedProduct.price,
                    );
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
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
                        id: null,
                        imageUrl: _editedProduct.imageUrl,
                        price: double.parse(value),
                      );
                    }),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
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
                    onSaved: (value) {
                      _editedProduct = Product(
                        title: _editedProduct.title,
                        category: _editedProduct.category,
                        description: value,
                        id: null,
                        imageUrl: _editedProduct.imageUrl,
                        price: _editedProduct.price,
                      );
                    }),
                SizedBox(
                  height: 15,
                ),
                DropdownButtonFormField(
                  hint: Text('Select a Category'),
                  value: dropDownValue,
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
                      id: null,
                      imageUrl: _editedProduct.imageUrl,
                      price: _editedProduct.price,
                    );
                  },
                  onChanged: (value) {
                    dropDownValue = value;
                    setState(() {
                      // value;
                    });
                    // dropDownValue = value;
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
                                child: Image.network(_imageUrlController.text),
                              ),
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
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
                        onSaved: (value) {
                          _editedProduct = Product(
                            title: _editedProduct.title,
                            category: _editedProduct.category,
                            description: _editedProduct.description,
                            id: null,
                            imageUrl: value,
                            price: _editedProduct.price,
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
