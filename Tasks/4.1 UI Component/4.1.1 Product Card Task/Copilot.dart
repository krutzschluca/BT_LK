import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Product Card Example'),
        ),
        body: Center(
          child: ProductCard(
            imageUrl: 'https://via.placeholder.com/150',
            title: 'Sample Product',
            description: 'This is a sample product description.',
            price: '\$29.99',
            onPressed: () {
              print('Add to Cart pressed');
            },
          ),
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String price;
  final VoidCallback onPressed;

  ProductCard({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(imageUrl),
            SizedBox(height: 8.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(description),
            SizedBox(height: 8.0),
            Text(
              price,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 16.0),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: onPressed,
                child: Text('Add to Cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}