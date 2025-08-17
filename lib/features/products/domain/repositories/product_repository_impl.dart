// ignore_for_file: avoid_catches_without_on_clauses

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:task/features/products/data/api/product_api_service.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(this._apiService);
  final ProductApiService _apiService;

  @override
  Future<Either<Failure, ProductsResponse>> getProducts({
    int limit = 20,
    int skip = 0,
    String? search,
    String? category,
    String? sortBy,
    String? order,
  }) async {
    try {
      // Debug logging

      // If search query is specified, use the search endpoint (which doesn't support sorting)
      if (search != null && search.isNotEmpty) {
        final response = await _apiService.searchProducts(
          query: search,
          limit: limit,
          skip: skip,
          sortBy: sortBy,
          order: order,
        );
        return Right(response);
      }

      // If category is specified, use the category-specific endpoint
      if (category != null && category.isNotEmpty) {
        final response = await _apiService.getProductsByCategory(
          category: category,
          limit: limit,
          skip: skip,
          sortBy: sortBy,
          order: order,
        );
        return Right(response);
      }

      // Otherwise, use the general products endpoint
      final response = await _apiService.getProducts(
        limit: limit,
        skip: skip,
        sortBy: sortBy,
        order: order,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.connectionTimeout) {
        return const Left(NetworkFailure('Connection timeout'));
      }
      return const Left(NetworkFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, Product>> getProduct(int id) async {
    try {
      final product = await _apiService.getProduct(id);
      return Right(product);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    try {
      final categories = await _apiService.getCategories();
      return Right(categories);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductsResponse>> searchProducts({
    required String query,
    int limit = 20,
    int skip = 0,
  }) async {
    try {
      final response = await _apiService.searchProducts(
        query: query,
        limit: limit,
        skip: skip,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProductsResponse>> getProductsByCategory({
    required String category,
    int limit = 20,
    int skip = 0,
  }) async {
    try {
      final response = await _apiService.getProductsByCategory(
        category: category,
        limit: limit,
        skip: skip,
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure('Connection timeout');
      case DioExceptionType.badResponse:
        return ServerFailure(
          'Server error: ${error.response?.statusCode} ${error.response?.statusMessage}',
        );
      case DioExceptionType.cancel:
        return const NetworkFailure('Request was cancelled');
      case DioExceptionType.connectionError:
        return const NetworkFailure('No internet connection');
      case DioExceptionType.unknown:
        return NetworkFailure('Unknown error: ${error.message}');
      default:
        return UnknownFailure(error.toString());
    }
  }
}
