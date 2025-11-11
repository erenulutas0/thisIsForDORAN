import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  String? _error;
  String? _selectedCategory;
  double? _minRating;
  String? _sortBy;

  List<Product> get products => _products;
  List<Product> get filteredProducts => _filteredProducts;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get selectedCategory => _selectedCategory;
  double? get minRating => _minRating;
  String? get sortBy => _sortBy;

  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await _apiService.getProducts();
      _filteredProducts = _products;
      _error = null;
      // Mevcut filtreleri uygula
      _applyFilters();
    } catch (e) {
      _error = e.toString();
      _products = [];
      _filteredProducts = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void setMinRating(double? rating) {
    _minRating = rating;
    _applyFilters();
  }

  void setSortBy(String sortBy) {
    _sortBy = sortBy;
    _applyFilters();
  }

  void applyFilters({
    String? category,
    double? minRating,
    String? sortBy,
  }) {
    _selectedCategory = category ?? _selectedCategory;
    _minRating = minRating ?? _minRating;
    _sortBy = sortBy ?? _sortBy;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredProducts = List<Product>.from(_products);

    // Category filter
    if (_selectedCategory != null && _selectedCategory != 'All') {
      _filteredProducts = _filteredProducts
          .where((product) => product.category == _selectedCategory)
          .toList();
    }

    // Rating filter
    if (_minRating != null && _minRating! > 0) {
      _filteredProducts = _filteredProducts
          .where((product) =>
              product.rating != null && product.rating! >= _minRating!)
          .toList();
    }

    // Sort
    if (_sortBy != null && _sortBy != 'Default') {
      switch (_sortBy) {
        case 'Price: Low to High':
          _filteredProducts.sort((a, b) {
            final priceA = a.discountPrice ?? a.price;
            final priceB = b.discountPrice ?? b.price;
            return priceA.compareTo(priceB);
          });
          break;
        case 'Price: High to Low':
          _filteredProducts.sort((a, b) {
            final priceA = a.discountPrice ?? a.price;
            final priceB = b.discountPrice ?? b.price;
            return priceB.compareTo(priceA);
          });
          break;
        case 'Rating: High to Low':
          _filteredProducts.sort((a, b) {
            final ratingA = a.rating ?? 0.0;
            final ratingB = b.rating ?? 0.0;
            return ratingB.compareTo(ratingA);
          });
          break;
        case 'Rating: Low to High':
          _filteredProducts.sort((a, b) {
            final ratingA = a.rating ?? 0.0;
            final ratingB = b.rating ?? 0.0;
            return ratingA.compareTo(ratingB);
          });
          break;
      }
    }

    notifyListeners();
  }

  void resetFilters() {
    _selectedCategory = null;
    _minRating = null;
    _sortBy = null;
    _filteredProducts = _products;
    notifyListeners();
  }

  void searchProducts(String query) {
    if (query.isEmpty) {
      _filteredProducts = _products;
    } else {
      _filteredProducts = _products
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }
}

