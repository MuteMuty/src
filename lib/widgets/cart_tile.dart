import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/cart.dart';

class CartTile extends StatefulWidget {
  final int cartId;
  CartItem cartItem;
  CartTile({super.key, required this.cartId, required this.cartItem});

  @override
  State<CartTile> createState() => _CartTileState();
}

class _CartTileState extends State<CartTile> {
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
                        backgroundImage:
                            CachedNetworkImageProvider(image.data ?? ""),
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
                              _updateItemQuantity(
                                  widget.cartId, widget.cartItem.id,
                                  remove: true);
                            },
                          ),
                          Text('$_currQuantity'),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              _updateItemQuantity(
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

    return decodedString;
  }

  Future<void> _updateItemQuantity(int cartId, int itemId,
      {bool remove = false}) async {
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
            'quantity': _currQuantity + (remove ? -1 : 1),
          },
        ]
      }),
    );
    setState(() {
      _currQuantity += (remove ? -1 : 1);
    }); /* 
    final decodedString = json.decode(response.body);
    debugPrint(decodedString.toString()); */
  }
}
