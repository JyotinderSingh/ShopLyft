import 'package:flutter/material.dart';

import '../widgets/category_item.dart';
import '../widgets/app_drawer.dart';
import '../providers/product.dart';

class CategoriesScreen extends StatelessWidget {
  static const routeName = "/categories-screen";
  final CATEGORIES = [
    {
      'id': Categories.Clothing,
      'title': "Clothing",
      'icon': Icons.blur_on,
    },
    {
      'id': Categories.Electronics,
      'title': "Electronics",
      'icon': Icons.camera,
    },
    {
      'id': Categories.Home,
      'title': "Home",
      'icon': Icons.home,
    },
    {
      'id': Categories.Kids,
      'title': "Kids",
      'icon': Icons.child_friendly,
    },
    {
      'id': Categories.Kitchen,
      'title': "Kitchen",
      'icon': Icons.kitchen,
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      drawer: AppDrawer(),
      body: GridView(
        padding: const EdgeInsets.all(17),
        children: CATEGORIES
            .map((catData) => CategoryItem(
                  catData['id'],
                  catData['title'],
                  catData['icon'],
                ))
            .toList(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
      ),
    );
  }
}
