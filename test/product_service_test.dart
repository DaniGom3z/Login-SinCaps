import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import 'package:login/models/product.dart';
import 'package:login/services/product_service.dart';

import 'mocks.mocks.dart'; // Importa el mock generado

void main() {
  group('ProductService tests', () {
    late MockClient mockClient;
    late ProductService productService;

    setUp(() {
      mockClient = MockClient();
      productService = ProductService(client: mockClient);
    });

    test('fetchProducts returns list of products on success', () async {
      final fakeResponse = jsonEncode([
        {
          "id": 1,
          "title": "Test Product",
          "price": 9.99,
          "description": "Description here",
          "images": ["http://example.com/img.png"]
        },
        {
          "id": 2,
          "title": "Another Product",
          "price": 20.0,
          "description": "Another description",
          "images": ["http://example.com/img2.png"]
        }
      ]);

      when(mockClient.get(Uri.parse('https://fakestoreapi.com/products')))
          .thenAnswer((_) async => http.Response(fakeResponse, 200));

      final products = await productService.fetchProducts();

      expect(products, isA<List<Product>>());
      expect(products.length, 2);
      expect(products[0].id, 1);
      expect(products[0].title, 'Test Product');
      expect(products[1].price, 20.0);
    });

    test('fetchProducts throws Exception on non-200 response', () {
      when(mockClient.get(Uri.parse('https://fakestoreapi.com/products')))
          .thenAnswer((_) async => http.Response('Error', 404));

      expect(() async => await productService.fetchProducts(),
          throwsException);
    });
  });
}
