import 'package:flutter_test/flutter_test.dart';
import 'package:login/models/product.dart';  

void main() {
  group('Product model tests', () {
    test('Constructor assigns fields correctly', () {
      final product = Product(
        id: 1,
        title: 'Test Product',
        price: 9.99,
        description: 'A product for testing',
        images: ['http://example.com/image1.png', 'http://example.com/image2.png'],
      );

      expect(product.id, 1);
      expect(product.title, 'Test Product');
      expect(product.price, 9.99);
      expect(product.description, 'A product for testing');
      expect(product.images.length, 2);
      expect(product.images[0], 'http://example.com/image1.png');
    });

    test('fromJson creates Product correctly', () {
      final json = {
        'id': 2,
        'title': 'Json Product',
        'price': 15.5,
        'description': 'Created from json',
        'images': ['http://example.com/img1.png', 'http://example.com/img2.png'],
      };

      final product = Product.fromJson(json);

      expect(product.id, 2);
      expect(product.title, 'Json Product');
      expect(product.price, 15.5);
      expect(product.description, 'Created from json');
      expect(product.images, isA<List<String>>());
      expect(product.images.length, 2);
      expect(product.images[1], 'http://example.com/img2.png');
    });

    test('fromJson converts price to double if given as int', () {
      final json = {
        'id': 3,
        'title': 'Int Price Product',
        'price': 10,
        'description': 'Price is an int in JSON',
        'images': ['http://example.com/img.png'],
      };

      final product = Product.fromJson(json);

      expect(product.price, 10.0);
    });
  });
}
