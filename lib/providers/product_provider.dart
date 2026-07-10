import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';
import '../utils/api_constants.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchProducts({String? search, String? category}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await ApiService.instance.get(
        ApiConstants.products,
        query: {
          if (search != null && search.isNotEmpty) 'search': search,
          if (category != null) 'category': category,
        },
      );
      _products = (response.data['data'] as List).map((p) => Product.fromJson(p)).toList();
    } catch (e) {
      _error = 'Could not load products. Pull down to try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Product?> fetchProductById(String id) async {
    try {
      final response = await ApiService.instance.get('${ApiConstants.products}/$id');
      return Product.fromJson(response.data['data']);
    } catch (e) {
      return null;
    }
  }
}
