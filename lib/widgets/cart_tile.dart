import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart.dart';

class CartTile extends StatefulWidget {
  final cartId;
  CartItem cartItem;
  CartTile({super.key, required this.cartId, required this.cartItem});

  @override
  State<CartTile> createState() => _CartTileState();
}

class _CartTileState extends State<CartTile> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  int _currQuantity = 0;

  @override
  void initState() {
    super.initState();
    _currQuantity = widget.cartItem.quantity;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getImage(widget.cartItem.id),
        initialData:
            "https://icon-library.com/images/icon-placeholder/icon-placeholder-14.jpg",
        builder: (BuildContext context, AsyncSnapshot<String> image) {
          return _currQuantity == 0
              ? const SizedBox()
              : Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(image.data ?? ""),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 160,
                            child: Text(
                              widget.cartItem.title,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text('${widget.cartItem.price}€'),
                        ],
                      ),
                      const Expanded(child: SizedBox()),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              _removeItemQuantity(
                                  widget.cartId, widget.cartItem.id);
                            },
                          ),
                          Text('$_currQuantity'),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              _addItemQuantity(
                                  widget.cartId, widget.cartItem.id);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
        });
  }

  Future<String> _getImage(int id) async {
    final queryParameters = {
      'select': 'thumbnail',
    };
    Uri uri = Uri.https('dummyjson.com', '/products/$id', queryParameters);
    final response = await http.get(uri);
    final String decodedString = json.decode(response.body)['thumbnail'];
    debugPrint(decodedString);

    return decodedString;
  }

  Future<void> _addItemQuantity(int cartId, int itemId) async {
    Uri uri = Uri.https('dummyjson.com', '/carts/$cartId');
    final response = await http.put(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'merge': true,
        'products': [
          {
            'id': itemId,
            'quantity': _currQuantity + 1,
          },
        ]
      }),
    );
    setState(() {
      _currQuantity++;
    });
    final decodedString = json.decode(response.body);
    debugPrint(decodedString.toString());
  }

  Future<void> _removeItemQuantity(int cartId, int itemId) async {
    debugPrint('Cart ID: $cartId, Item ID: $itemId');
    Uri uri = Uri.https('dummyjson.com', '/carts/$cartId');
    final response = await http.put(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'merge': true,
        'products': [
          {
            'id': itemId,
            'quantity': _currQuantity - 1,
          },
        ]
      }),
    );
    setState(() {
      _currQuantity--;
    });
  }
}
