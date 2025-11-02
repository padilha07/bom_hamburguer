import 'package:flutter/material.dart';
import '../models/product.dart';

class CardapioProvider extends ChangeNotifier {
  final List<Product> _products = [
    Product(
      id: 1,
      name: 'X Burger',
      price: 5.00,
      category: 'Sanduíches',
      image: '🍔',
    ),
    Product(
      id: 2,
      name: 'X Egg',
      price: 4.50,
      category: 'Sanduíches',
      image: '🥪',
    ),
    Product(
      id: 3,
      name: 'X Bacon',
      price: 7.00,
      category: 'Sanduíches',
      image: '🥓',
    ),
    Product(
      id: 4,
      name: 'Fries',
      price: 2.00,
      category: 'Acompanhamentos',
      image: '🍟',
    ),
    Product(
      id: 5,
      name: 'Soft Drink',
      price: 2.50,
      category: 'Bebidas',
      image: '🥤',
    ),
  ];

  final Map<String, Product> _selectedItems = {}; // chave: categoria

  List<Product> get products => _products;

  List<Product> get selectedItemsList => _selectedItems.values.toList();

  int get selectedItemsCount => _selectedItems.length;

  double get totalSelected {
    return _selectedItems.values.fold(0.0, (sum, item) => sum + item.price);
  }

  void selectItem(Product product) {
    // Se já tiver item da mesma categoria, substitui
    if (_selectedItems.containsKey(product.category)) {
      if (_selectedItems[product.category]!.id == product.id) {
        _selectedItems.remove(product.category); // Deseleciona se for o mesmo
      } else {
        _selectedItems[product.category] = product;
      }
    } else {
      _selectedItems[product.category] = product;
    }
    notifyListeners();
  }

  bool isSelected(Product product) {
    return _selectedItems[product.category]?.id == product.id;
  }

  void clearSelection() {
    _selectedItems.clear();
    notifyListeners();
  }
}
