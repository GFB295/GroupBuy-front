import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../services/api_service.dart';

final productProvider = StateNotifierProvider<ProductNotifier, AsyncValue<List<Product>>>((ref) => ProductNotifier());

class ProductNotifier extends StateNotifier<AsyncValue<List<Product>>> {
  ProductNotifier() : super(const AsyncValue.loading()) {
    loadOffers();
  }

  final ApiService _api = ApiService();

  Future<void> loadOffers({
    String? category,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    String? order,
  }) async {
    try {
      state = const AsyncValue.loading();
      final data = await _api.fetchOffers(
        category: category,
        minPrice: minPrice,
        maxPrice: maxPrice,
        sortBy: sortBy,
        order: order,
      );
      final products = data.map<Product>((p) => Product.fromJson(p)).toList();
      state = AsyncValue.data(products);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<Product?> getOfferById(String id) async {
    try {
      final data = await _api.fetchOfferById(id);
      return Product.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  Future<List<String>> getCategories() async {
    try {
      return await _api.fetchCategories();
    } catch (e) {
      return [];
    }
  }

  Future<void> refreshOffers() async {
    await loadOffers();
  }
} 