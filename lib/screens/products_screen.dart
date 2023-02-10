import 'package:flutter/material.dart';
import 'package:src/models/product.dart';
import 'package:src/widgets/product_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  _fetchProducts() async {
    final Uri uri = Uri.https('dummyjson.com', '/products');
    final response = await http.get(uri);
    var products = json.decode(response.body)['products'] as List;
    setState(() {
      _products = products.map((product) => Product.fromJson(product)).toList();
      _filteredProducts = _products;
    });
  }

  void _filterProducts(String value) {
    setState(() {
      _filteredProducts = _products
          .where((product) =>
              product.title.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              hintText: 'Search for a product',
              hintStyle: TextStyle(color: Colors.grey[300]),
            ),
            controller: _searchController,
            onChanged: _filterProducts,
          ),
        ),
        if (_filteredProducts.isEmpty)
          const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        else
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 5.0,
                  childAspectRatio: 6 / 8),
              itemCount: _filteredProducts.length,
              itemBuilder: (ctx, i) =>
                  ProductCard(product: _filteredProducts[i]),
              padding: const EdgeInsets.all(10),
            ),
          ),
      ],
    );
  }
}
