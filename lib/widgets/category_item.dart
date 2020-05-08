import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/category_products_overview.dart';

import '../providers/product.dart';

class CategoryItem extends StatelessWidget {
  final Categories id;
  final String title;
  final icon;

  CategoryItem(this.id, this.title, this.icon);

  void selectCategory(BuildContext ctx) {
    Navigator.of(ctx)
        .pushNamed(CategoryProductsOverview.routeName, arguments: id);
  }

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
    return InkWell(
      onTap: () => selectCategory(context),
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Stack(
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 50,
                  ),
                  Icon(
                    icon,
                    color: Colors.black12,
                    size: 80,
                  ),
                ],
              ),
            ),
            Opacity(
              opacity: 0.85,
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).accentColor.withOpacity(0.7),
              Theme.of(context).primaryColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.7),
              blurRadius: 9,
              spreadRadius: 0,
              offset: Offset(0, 5),
            ),
          ],
        ),
      ),
    );
  }
}
