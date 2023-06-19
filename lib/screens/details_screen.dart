import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'cart_screen.dart';
import 'fullscreen_images.dart';

import '../models/product.dart';
import '../widgets/my_snack_bar.dart';

class DetailsScreen extends StatefulWidget {
  final Product product;

  const DetailsScreen({required this.product, super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  List<bool> _dots = [];

  @override
  void initState() {
    _dots = List<bool>.filled(widget.product.images.length, false);
    _dots[0] = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(widget.product.title),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              debugPrint('Cart');
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CartScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  PageView.builder(
                    itemCount: widget.product.images.length,
                    onPageChanged: (index) {
                      setState(() {
                        _dots = List<bool>.filled(
                            widget.product.images.length, false);
                        _dots[index] = true;
                      });
                    },
                    itemBuilder: (context, index) {
                      return InkWell(
                        child: Hero(
                          tag: widget.product.images[index],
                          child: CachedNetworkImage(
                            imageUrl: widget.product.images[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => FullscreenImages(
                                images: widget.product.images,
                                index: index,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _dots.map((dot) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: dot ? Colors.white : Colors.grey,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey.shade600),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text("€${widget.product.price}"),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.yellow,
                      ),
                      const SizedBox(width: 5),
                      Text("${widget.product.rating}"),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(widget.product.description),
                ],
              ),
            ),
            ElevatedButton(
              child: const Text('Add to cart'),
              onPressed: () async {
                // TODO: Add to cart

                ScaffoldMessenger.of(context).showSnackBar(
                  mySnackBar(context, 'Added to cart'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
