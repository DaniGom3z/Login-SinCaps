import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> products = [];
  ScrollController _scrollController = ScrollController(); // ✅ Inicializado directamente
  bool isLoading = false;
  int skip = 0;
  final int limit = 10;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll); // ✅ Aquí lo usamos
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    if (!hasMore) return;

    setState(() {
      isLoading = true;
    });

    final response = await http.get(
      Uri.parse('https://dummyjson.com/products?limit=$limit&skip=$skip'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<Product> newProducts = (data['products'] as List)
          .map((e) => Product.fromJson(e))
          .toList();

      setState(() {
        products.addAll(newProducts);
        skip += limit;
        isLoading = false;
        if (newProducts.length < limit) {
          hasMore = false;
        }
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar productos')),
      );
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !isLoading) {
      fetchProducts();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        controller: _scrollController,
        itemCount: products.length + (isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < products.length) {
            final product = products[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: product.images.isNotEmpty
                    ? Image.network(
                        product.images[0],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : null,
                title: Text(product.title),
                subtitle: Text('\$${product.price}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailScreen(product: product),
                    ),
                  );
                },
              ),
            );
          } else {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
