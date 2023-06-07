import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() async {
    final SharedPreferences prefs = await _prefs;
    if (!prefs.containsKey('cart')) {
      prefs.setStringList('cart', List<String>.empty());
    }
    List<String>? cart = prefs.getStringList('cart');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: itemBuilder);
  }

  // method to build the list of products
  Widget itemBuilder(BuildContext context, int index) {
    return ListTile(
      title: Text('Product $index'),
      subtitle: Text('Description of product $index'),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {},
      ),
    );
  }
}
