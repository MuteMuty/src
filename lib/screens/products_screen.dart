import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../models/product.dart';
import '../widgets/product_tile.dart';
import 'details_screen.dart';
import 'user_screen.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
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
          onPressed: () {
            debugPrint('Person');
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UserScreen(),
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
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: _updateSearchTerm,
                ),
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
