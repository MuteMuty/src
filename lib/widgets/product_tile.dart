import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    double dimensions = (MediaQuery.of(context).size.width - 15) / 2;
    return Column(
      children: [
        Image.network(
          width: dimensions,
          height: dimensions,
          product.thumbnail,
          fit: BoxFit.cover,
        ),
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
          child: Text(
            '${product.price}€ • ${product.title}',
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
