import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late Future<List<Product>> _products;

  @override
  void initState() {
    super.initState();
    _products = fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _products,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Product>? products = snapshot.data;
          return ListView.builder(
            itemCount: products!.length,
            itemBuilder: (context, index) {
              Product product = products[index];
              return Card(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    children: <Widget>[
                      Image.network(
                        product.thumbnail,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 10),
                      Text(
                        product.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        product.description,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Failed to load products'),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Future<List<Product>> fetchProducts() async {
    final Uri url = Uri.https('dummyjson.com', 'products');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> responseJson = json.decode(response.body)['products'];
      List<Product> products = <Product>[];
      responseJson.forEach((productJson) {
        debugPrint(productJson.toString());
        products.add(Product.fromJson(productJson));
      });
      return products;
    } else {
      throw Exception('Failed to load products');
    }
  }
}

class Product {
  final String title;
  final String description;
  final String thumbnail;

  Product({
    required this.title,
    required this.description,
    required this.thumbnail,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      title: json['title'],
      description: json['description'],
      thumbnail: json['thumbnail'],
    );
  }
}
