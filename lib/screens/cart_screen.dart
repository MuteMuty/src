import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:src/models/cart.dart';
import 'package:src/screens/user_screen.dart';

import '../models/user.dart';
import '../widgets/cart_tile.dart';
import '../widgets/my_snack_bar.dart';
import '../widgets/search_field.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  static const _pageSize = 10;
  int _cartId = 0;
  User? _user;

  String _searchTerm = '';

  final PagingController<int, CartItem> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height - (70 + 56),
        child: _user != null
            ? buildCartView()
            : const Center(
                child: Text('No user signed in!'),
              ),
      ),
      backgroundColor: Colors.grey[900],
      bottomSheet: Container(
        alignment: Alignment.center,
        height: 70,
        color: Colors.grey[900],
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          child: Text(_user != null ? 'Order' : 'Sign in to order'),
          onPressed: () async {
            if (_user == null) {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const UserScreen(),
                ),
              );
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              mySnackBar(context, 'Order placed successfully!'),
            );
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Widget buildCartView() => RefreshIndicator(
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
            PagedSliverList<int, CartItem>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<CartItem>(
                itemBuilder: (context, item, index) => CartTile(
                  cartId: _cartId,
                  cartItem: item,
                ),
              ),
            ),
          ],
        ),
      );

  Future<void> _fetchPage(int pageKey) async {
    final SharedPreferences prefs = await _prefs;
    if (prefs.getInt('user') == null) {
      return null;
    }
    final int? currentUser = prefs.getInt('user');

    final queryParameters = {
      'q': _searchTerm,
      'limit': _pageSize.toString(),
      'skip': pageKey.toString(),
    };

    try {
      List<Cart> carts = [];
      Uri uri = Uri.https(
          'dummyjson.com', '/carts/user/$currentUser', queryParameters);
      final response = await http.get(uri);
      final decodedCarts = json.decode(response.body)['carts'] as List;

      decodedCarts.forEach((cart) {
        carts.add(Cart.fromJson(cart));
      });
      setState(() {
        _cartId = carts[0].id;
      });

      final isLastPage = carts.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(carts[0].products);
      } else {
        final nextPageKey = pageKey + carts.length;
        _pagingController.appendPage(carts[0].products, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  void getCurrentUser() async {
    final SharedPreferences prefs = await _prefs;
    if (prefs.getInt('user') == null) {
      return null;
    }
    final int? currentUser = prefs.getInt('user');

    Uri uri = Uri.https('dummyjson.com', '/users/$currentUser');
    final response = await http.get(uri);
    final decodedUser = json.decode(response.body);

    setState(() {
      _user = User.fromJson(decodedUser);
    });
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
