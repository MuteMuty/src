import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import '../models/product.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    double dimensions = (MediaQuery.of(context).size.width - 15) / 2;
    return Column(
      children: [
        CachedNetworkImage(
          imageUrl: product.thumbnail,
          width: dimensions,
          height: dimensions,
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
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
