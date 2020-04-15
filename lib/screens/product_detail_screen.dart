import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/product.dart';
import 'package:provider/provider.dart';

import '../screens/image_detail_screen.dart';
import '../providers/cart.dart';
import '../providers/products.dart';
import '../widgets/badge.dart';
import '../screens/cart_screen.dart';
import '../providers/auth.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-detail';

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String categoryName(Categories cat) {
    switch (cat) {
      case Categories.Clothing:
        return 'Clothing';
        break;
      case Categories.Electronics:
        return 'Electronics';
        break;
      case Categories.Home:
        return 'Home';
        break;
      case Categories.Kids:
        return 'Kids';
        break;
      case Categories.Kitchen:
        return 'Kitchenware';
        break;
      case Categories.Uncategorized:
        return 'General';
        break;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final productId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    final loadedProduct = Provider.of<Products>(context).findById(productId);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
        actions: <Widget>[
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: double.infinity,
              child: GestureDetector(
                child: Stack(children: <Widget>[
                  Container(
                    width: double.infinity,
                    child: Hero(
                      tag: loadedProduct.id,
                      child: Image.network(
                        loadedProduct.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 15),
                    alignment: Alignment.bottomCenter,
                    child: Opacity(
                      opacity: 0.25,
                      child: Chip(
                        backgroundColor: Colors.black,
                        label: Text(
                          "Tap to view in fullscreen",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (ctx) =>
                            ImageDetailScreen(loadedProduct.imageUrl)),
                  );
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(
                top: 5,
                left: 20,
                right: 20,
              ),
              child: Text(
                loadedProduct.title,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                softWrap: true,
                overflow: TextOverflow.fade,
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(
                // top: 5,
                left: 20,
                right: 20,
              ),
              child: Text(
                categoryName(loadedProduct.category),
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
                softWrap: true,
                overflow: TextOverflow.fade,
              ),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(left: 20, right: 20, top: 5),
              child: Text(
                '\$${loadedProduct.price}',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 15,
              ),
              width: double.infinity,
              child: RaisedButton(
                child: Text(
                  'Add to cart',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  cart.addItem(
                    loadedProduct.id,
                    loadedProduct.price,
                    loadedProduct.title,
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 5,
              ),
              width: double.infinity,
              alignment: Alignment.topCenter,
              margin: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              child: Text(
                loadedProduct.description,
                style: TextStyle(fontSize: 17),
                softWrap: true,
                overflow: TextOverflow.fade,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
            loadedProduct.isFavourite ? Icons.favorite : Icons.favorite_border),
        // onPressed: () {
        // },
        // color: Theme.of(context).accentColor,
        onPressed: () {
          setState(() {
            loadedProduct.toggleFavouriteStatus(
              authData.token,
              authData.userId,
            );
          });
        },
      ),
    );
  }
}
