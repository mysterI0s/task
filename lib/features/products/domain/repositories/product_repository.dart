import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, ProductsResponse>> getProducts({
    int limit = 20,
    int skip = 0,
    String? search,
    String? category,
    String? sortBy,
    String? order,
  });

  Future<Either<Failure, Product>> getProduct(int id);

  Future<Either<Failure, List<String>>> getCategories();

  Future<Either<Failure, ProductsResponse>> searchProducts({
    required String query,
    int limit = 20,
    int skip = 0,
  });

  Future<Either<Failure, ProductsResponse>> getProductsByCategory({
    required String category,
    int limit = 20,
    int skip = 0,
  });
}
