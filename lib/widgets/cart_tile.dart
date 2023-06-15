import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart.dart';

class CartTile extends StatelessWidget {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final CartItem cartItem;
  CartTile({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getImage(cartItem.id),
        initialData:
            "https://icon-library.com/images/icon-placeholder/icon-placeholder-14.jpg",
        builder: (BuildContext context, AsyncSnapshot<String> image) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(image.data ?? ""),
            ),
            title: Text(cartItem.title),
            subtitle: Row(
              children: [
                Text('${cartItem.price}€ x ${cartItem.quantity} = '),
                Text(
                  '${cartItem.total}€',
                  style:
                      const TextStyle(decoration: TextDecoration.lineThrough),
                ),
                Text(' ${cartItem.discountedPrice}€'),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Item removed!'),
                  ),
                );
              },
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
}
