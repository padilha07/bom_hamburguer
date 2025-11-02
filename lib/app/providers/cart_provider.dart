import 'package:flutter/foundation.dart';
import 'package:bom_hamburguer/helpers/database_helper.dart'; // Importa o DB
import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalPrice => product.price * quantity;
}

class CartProvider extends ChangeNotifier {
  final Map<int, CartItem> _items = {};
  final DatabaseHelper _db = DatabaseHelper.instance; // Instância do DB

  Map<int, CartItem> get items => _items;

  // NOVO: Carrega os itens do banco de dados ao iniciar
  Future<void> loadCart() async {
    final dbItems = await _db.getAllItems();
    _items.clear();
    for (var item in dbItems) {
      _items[item.product.id] = item;
    }
    // Não precisa notificar ouvintes aqui, pois o app ainda não começou
  }

  // ATUALIZADO: Agora é async e salva no DB
  Future<void> addItem(Product product) async {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity++;
      await _db.upsert(_items[product.id]!); // Salva no DB
    } else {
      final newItem = CartItem(product: product);
      _items[product.id] = newItem;
      await _db.upsert(newItem); // Salva no DB
    }
    notifyListeners();
  }

  // ATUALIZADO: Agora é async e remove do DB
  Future<void> removeItem(int productId) async {
    if (_items.containsKey(productId)) {
      if (_items[productId]!.quantity > 1) {
        _items[productId]!.quantity--;
        await _db.upsert(_items[productId]!); // Atualiza no DB
      } else {
        _items.remove(productId);
        await _db.delete(productId); // Deleta do DB
      }
      notifyListeners();
    }
  }

  // ATUALIZADO: Agora é async e limpa o DB
  Future<void> clearCart() async {
    _items.clear();
    await _db.clear(); // Limpa o DB
    notifyListeners();
  }

  double get totalAmount {
    return _items.values.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  int get itemCount {
    return _items.values.fold(0, (sum, item) => sum + item.quantity);
  }

  bool get isEmpty => _items.isEmpty;

  // Lógica de desconto (continua a mesma)
  double get discountPercent {
    final categories =
        _items.values.map((item) => item.product.category).toSet();

    final hasSanduiche = categories.contains('Sanduíches');
    final hasAcompanhamento = categories.contains('Acompanhamentos');
    final hasBebida = categories.contains('Bebidas');

    if (hasSanduiche && hasAcompanhamento && hasBebida) {
      return 0.20;
    }
    if (hasSanduiche && hasBebida) {
      return 0.15;
    }
    if (hasSanduiche && hasAcompanhamento) {
      return 0.10;
    }

    return 0.0;
  }

  double get discountValue {
    return totalAmount * discountPercent;
  }

  double get totalAmountWithDiscount {
    return totalAmount - discountValue;
  }
}