import 'package:flutter/material.dart';
import 'package:teslo_app/features/products/domain/domain.dart';

class ProductCard extends StatelessWidget {

  final Product product;
  

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ImageViewer(images: product.images),

        Text(product.title, textAlign: TextAlign.center,),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _ImageViewer extends StatelessWidget {
  final List<String> images;

  const _ImageViewer({
    required this.images,
  
  });

  @override
  Widget build(BuildContext context) {
    final imageHeight = 250.0;

    if(images.isEmpty){
      return  ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          'assets/images/no-image.png', 
          fit:BoxFit.cover,
          height: imageHeight,
        ),
      );
    }

    return  ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: FadeInImage(
        fit:BoxFit.cover,
        fadeOutDuration: const Duration(milliseconds: 10),
        height: imageHeight,
        image: NetworkImage(images.first),
        placeholder: AssetImage('assets/loaders/bottle-loader.gif'),
      )
    );
  }
}