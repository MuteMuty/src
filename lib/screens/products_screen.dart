import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.dart';
import '../widgets/product_tile.dart';
import '../widgets/search_field.dart';
import 'details_screen.dart';
import 'user_screen.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  static const _pageSize = 20;

  String _searchTerm = '';

  final PagingController<int, ProductItem> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shop App"),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              debugPrint('Cart');
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.person),
          /* Image.network(
            'https://cdn.iconscout.com/icon/free/png-256/avatar-370-456322.png',
          ) */
          onPressed: () {
            debugPrint('Person');
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const UserScreen(),
              ),
            );
          },
        ),
      ),
      body: buildProductsView(),
      backgroundColor: Colors.grey[900],
    );
  }

  Widget buildProductsView() => RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _pagingController.refresh(),
        ),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPersistentHeader(
              pinned: true,
              delegate: SearchField(
                onChanged: _updateSearchTerm,
              ),
            ),
            PagedSliverGrid<int, ProductItem>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<ProductItem>(
                itemBuilder: (context, item, index) => InkWell(
                  child: item,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DetailsScreen(
                        product: item.product,
                      ),
                    ),
                  ),
                ),
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.86,
              ),
            ),
          ],
        ),
      );

  Future<void> _fetchPage(int pageKey) async {
    final queryParameters = {
      'q': _searchTerm,
      'limit': _pageSize.toString(),
      'skip': pageKey.toString(),
    };

    try {
      List<ProductItem> products = [];
      Uri uri = Uri.https('dummyjson.com', '/products/search', queryParameters);
      final response = await http.get(uri);
      final decodedProducts = json.decode(response.body)['products'] as List;

      decodedProducts.forEach((product) {
        products.add(ProductItem(
          product: Product.fromJson(product),
        ));
      });

      final isLastPage = products.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(products);
      } else {
        final nextPageKey = pageKey + products.length;
        _pagingController.appendPage(products, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  void _updateSearchTerm(String searchTerm) {
    _searchTerm = searchTerm;
    _pagingController.refresh();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
