import 'package:flutter/material.dart';
import 'package:no_screenshot/no_screenshot.dart'; // 👈 Importa la librería
import '../models/product.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  ProductDetailScreen({required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _noScreenshot = NoScreenshot.instance; // 👈 Creamos una instancia

  @override
  void initState() {
    super.initState();
    _noScreenshot.screenshotOff(); // 👈 Desactivamos capturas
  }

  @override
  void dispose() {
    _noScreenshot.screenshotOn(); // 👈 Volvemos a activar capturas
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.description, style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text(
              'Precio: \$${product.price}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // ListView horizontal para las imágenes
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: product.images.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Image.network(
                      product.images[index],
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
