import 'dart:math';

import 'package:product_x/services/api_service.dart';
import '../models/product.dart';

abstract class ProductRepositoryBase {
  Future<List<Product>> fetchProducts();
}

class ProductRepository implements ProductRepositoryBase {
  final ApiService apiService;

  ProductRepository({required this.apiService});

  @override
  Future<List<Product>> fetchProducts() async {
    final data = await apiService.get('products');
    return (data['products'] as List)
        .map((item) => Product.fromJson(item))
        .toList();
  }
}
