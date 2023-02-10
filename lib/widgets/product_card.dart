import 'package:flutter/material.dart';
import 'package:src/models/product.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool titleIsClicked = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => setState(() => titleIsClicked = !titleIsClicked),
      child: Card(
        elevation: 10,
        child: Column(
          children: [
            if (!titleIsClicked) ...[
              Container(
                height: (MediaQuery.of(context).size.width - 33) / 2,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(widget.product.thumbnail),
                    fit: BoxFit.cover,
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          child: PageView(
                            children: widget.product.images.map((image) {
                              return Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(image),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 3),
                child: Column(
                  children: [
                    Text(
                      "\€${widget.product.price.toStringAsFixed(2)}",
                      overflow: TextOverflow.clip,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      widget.product.title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(5),
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.product.description,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Price: \$${widget.product.price.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Brand: ${widget.product.brand}",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Category: ${widget.product.category}",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
