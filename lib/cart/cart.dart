import '../models/product.dart';

class Cart {
  static final Map<Product, int> _items = {};

  static void add(Product product) {
    if (_items.containsKey(product)) {
      _items[product] = _items[product]! + 1;
    } else {
      _items[product] = 1;
    }
  }

  static void remove(Product product) {
    _items.remove(product);
  }

  static Map<Product, int> get items => _items;

  static double get total {
    double sum = 0;
    _items.forEach((product, quantity) {
      sum += product.price * quantity;
    });
    return sum;
  }

  static void clear() {
    _items.clear();
  }
}
