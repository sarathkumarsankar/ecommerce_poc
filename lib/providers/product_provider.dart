// Provide ApiService globally
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product_x/repositories/product_repository.dart';
import 'package:product_x/services/api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

// Provide ProductRepository, depending on ApiService
final productRepositoryProvider = Provider<ProductRepositoryBase>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return ProductRepository(apiService: apiService);
});
