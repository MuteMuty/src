import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() async {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }

  Future<List<String>> fetchCart() async {
    try {
      List<String> products = [];
      Uri uri = Uri.https('dummyjson.com', '/users/5/carts');
      final response = await http.get(uri);
      final decodedProducts = json.decode(response.body)['products'] as List;

      /* decodedProducts.forEach((product) {
        products.add(Product.fromJson(product));
      }); */

      return products;
    } catch (error) {
      throw error;
    }
  }
}
