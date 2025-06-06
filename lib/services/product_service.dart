import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  final _base = 'https://fakestoreapi.com';
  final http.Client client;

  ProductService({http.Client? client}) : client = client ?? http.Client();

  Future<List<Product>> fetchProducts() async {
    final url = Uri.parse('$_base/products');
    final res = await client.get(url);

    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Error ${res.statusCode}: no pude cargar productos');
    }
  }
}
