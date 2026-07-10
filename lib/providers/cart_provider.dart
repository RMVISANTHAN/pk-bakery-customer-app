import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';
import '../utils/api_constants.dart';

class CartLine {
  final Product product;
  final String? weightOption;
  int quantity;

  CartLine({required this.product, this.weightOption, this.quantity = 1});

  double get lineTotal {
    final weightMod = product.weightOptions
            .firstWhere((w) => w.label == weightOption, orElse: () => WeightOption(label: '', priceModifier: 0))
            .priceModifier;
    return (product.finalPrice + weightMod) * quantity;
  }
}

class CartProvider extends ChangeNotifier {
  final List<CartLine> _lines = [];

  List<CartLine> get lines => List.unmodifiable(_lines);
  int get itemCount => _lines.fold(0, (sum, l) => sum + l.quantity);
  double get subtotal => _lines.fold(0, (sum, l) => sum + l.lineTotal);

  void addProduct(Product product, {String? weightOption, int quantity = 1}) {
    final existingIndex =
        _lines.indexWhere((l) => l.product.id == product.id && l.weightOption == weightOption);
    if (existingIndex >= 0) {
      _lines[existingIndex].quantity += quantity;
    } else {
      _lines.add(CartLine(product: product, weightOption: weightOption, quantity: quantity));
    }
    notifyListeners();
    _syncAdd(product.id, weightOption, quantity);
  }

  void updateQuantity(String productId, String? weightOption, int quantity) {
    final line = _lines.firstWhere((l) => l.product.id == productId && l.weightOption == weightOption);
    line.quantity = quantity;
    notifyListeners();
    ApiService.instance.put('${ApiConstants.cart}/$productId',
        data: {'quantity': quantity, 'weightOption': weightOption});
  }

  void removeLine(String productId, String? weightOption) {
    _lines.removeWhere((l) => l.product.id == productId && l.weightOption == weightOption);
    notifyListeners();
    ApiService.instance.delete('${ApiConstants.cart}/$productId', data: {'weightOption': weightOption});
  }

  void clear() {
    _lines.clear();
    notifyListeners();
    ApiService.instance.delete(ApiConstants.cart);
  }

  Future<void> _syncAdd(String productId, String? weightOption, int quantity) async {
    try {
      await ApiService.instance.post(ApiConstants.cart, data: {
        'productId': productId,
        'weightOption': weightOption,
        'quantity': quantity,
      });
    } catch (_) {
      // Non-fatal: local cart state remains the source of truth for the UI;
      // consider a retry queue for production offline handling.
    }
  }
}
