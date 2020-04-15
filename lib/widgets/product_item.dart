import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  // final double price;

  // ProductItem(this.id, this.title, this.imageUrl, this.price);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return Container(
      decoration: new BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(200, 200, 200, 1),
            blurRadius: 6, // soften the shadow
            spreadRadius: 1.0, //extend the shadow
            offset: Offset(
              0.0, // Move to right 10  horizontally
              5.0, // Move to bottom 10 Vertically
            ),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                ProductDetailScreen.routeName,
                arguments: product.id,
              );
            },
            child: Hero(
              tag: product.id,
              child: FadeInImage(
                placeholder:
                    AssetImage('assets/images/product-placeholder.png'),
                image: NetworkImage(product.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          header: GridTileBar(
            title: Text(
              '\$ ${product.price.toString()}',
              style: TextStyle(fontSize: 15, shadows: [
                Shadow(
                  blurRadius: 14.0,
                  color: Colors.black,
                ),
                Shadow(
                  blurRadius: 12.0,
                  color: Colors.black87,
                ),
              ]),
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Color.fromRGBO(30, 15, 59, 0.85),
            leading: Consumer<Product>(
              builder: (ctx, product, _) => IconButton(
                icon: Icon(product.isFavourite
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  product.toggleFavouriteStatus(
                    authData.token,
                    authData.userId,
                  );
                },
                color: Theme.of(context).accentColor,
              ),
            ),
            title: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                product.title,
                textAlign: TextAlign.center,
              ),
            ),
            trailing: Material(
              color: Color.fromRGBO(30, 15, 59, 0),
              child: InkWell(
                child: IconButton(
                  icon: Icon(Icons.add_shopping_cart),
                  onPressed: () {
                    cart.addItem(product.id, product.price, product.title);
                    Scaffold.of(context).hideCurrentSnackBar();
                    Scaffold.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.deepPurple.withOpacity(0.85),
                      duration: Duration(milliseconds: 1200),
                      action: SnackBarAction(
                        textColor: Colors.white,
                        label: 'Undo',
                        onPressed: () => Provider.of<Cart>(context)
                            .removeSingleItem(product.id),
                      ),
                      content: Row(
                        children: <Widget>[
                          Text("Item added to cart"),
                          SizedBox(width: 5),
                          Icon(Icons.check),
                        ],
                      ),
                    ));
                  },
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
