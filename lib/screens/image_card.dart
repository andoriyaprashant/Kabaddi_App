import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  final String imagePath;

  const ImageCard({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.asset(
            imagePath,
            width: 120,
            height: 120, // Adjust the height according to your needs
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}