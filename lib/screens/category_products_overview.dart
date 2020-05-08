import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../providers/products.dart';
import '../widgets/category_products_grid.dart';

enum FilterOptions {
  Favourites,
  All,
}

class CategoryProductsOverview extends StatefulWidget {
  static const routeName = '/category-products-overview';
  // final String title;
  // var id;

  // CategoryProductsOverview(this.title, this.id);
  
  @override
  _CategoryProductsOverview createState() => _CategoryProductsOverview();
}

class _CategoryProductsOverview extends State<CategoryProductsOverview> {
  var _showOnlyFavourites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final cat = ModalRoute.of(context).settings.arguments as Categories;
    return Scaffold(
      appBar: AppBar(
        title: Text('ShopLyft'),
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
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => Provider.of<Products>(context).fetchAndSetProducts(),
        child: _isLoading
            ? Center(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    strokeWidth: 8,
                  ),
                ),
              )
            : CategoryProductsGrid(cat),
      ),
    );
  }
}
