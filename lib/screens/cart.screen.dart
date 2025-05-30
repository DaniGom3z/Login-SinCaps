import 'package:flutter/material.dart';
import '../cart/cart.dart';
import 'package:no_screenshot/no_screenshot.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _noScreenshot = NoScreenshot.instance;

  @override
  void initState() {
    super.initState();
    // Al entrar, desactiva capturas
    _noScreenshot.screenshotOff();
  }

  @override
  void dispose() {
    // Al salir, reactiva capturas
    _noScreenshot.screenshotOn();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = Cart.items;

    return Scaffold(
      appBar: AppBar(
        title: Text('Carrito de Compras'),
        actions: [
          if (items.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete),
              tooltip: 'Vaciar carrito',
              onPressed: () {
                Cart.clear();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Carrito vaciado')));
                // Refrescar pantalla
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => CartScreen()),
                );
              },
            ),
        ],
      ),
      body: items.isEmpty
          ? Center(child: Text('El carrito está vacío'))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final product = items[index];
                return ListTile(
                  leading: (product.images.isNotEmpty)
                      ? Image.network(product.images[0], height: 40)
                      : Icon(Icons.shopping_cart),
                  title: Text(product.title),
                  subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                );
              },
            ),
      bottomNavigationBar: items.isNotEmpty
          ? Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.grey[200],
              child: Text(
                'Total: \$${Cart.total.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : null,
    );
  }
}
