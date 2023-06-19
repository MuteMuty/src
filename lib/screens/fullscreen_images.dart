import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FullscreenImages extends StatefulWidget {
  final List<String> images;
  final int index;

  const FullscreenImages(
      {required this.images, required this.index, super.key});

  @override
  State<FullscreenImages> createState() => _FullscreenImagesState();
}

class _FullscreenImagesState extends State<FullscreenImages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Stack(
        children: [
          PageView.builder(
            itemCount: widget.images.length,
            controller: PageController(initialPage: widget.index),
            itemBuilder: (context, index) {
              return Hero(
                tag: widget.images[index],
                child: GestureDetector(
                  child: CachedNetworkImage(
                    imageUrl: widget.images[index],
                    fit: BoxFit.fitWidth,
                  ),
                  onVerticalDragUpdate: (details) {
                    if (details.localPosition.distance > 400) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              );
            },
          ),
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
