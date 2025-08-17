// ignore_for_file: avoid_catches_without_on_clauses

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:task/core/storage/local_storage_service.dart';
import 'package:task/features/recipes/data/api/recipe_api_service.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/repositories/recipe_repository.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  RecipeRepositoryImpl(this._apiService);
  final RecipeApiService _apiService;

  @override
  Future<Either<Failure, RecipesResponse>> getRecipes({
    int limit = 20,
    int skip = 0,
    String? search,
  }) async {
    try {
      // Try to get cached data first if no search is applied
      if (search == null && LocalStorageService.isCacheValid()) {
        final cachedRecipes = LocalStorageService.getCachedRecipes();
        if (cachedRecipes.isNotEmpty) {
          // Apply pagination to cached data
          final startIndex = skip;
          final paginatedRecipes = cachedRecipes
              .skip(startIndex)
              .take(limit)
              .toList();

          if (paginatedRecipes.isNotEmpty) {
            return Right(
              RecipesResponse(
                recipes: paginatedRecipes,
                total: cachedRecipes.length,
                skip: skip,
                limit: limit,
              ),
            );
          }
        }
      }

      // If no cached data or cache is invalid, fetch from API
      final response = await _apiService.getRecipes(limit: limit, skip: skip);

      // Cache the response if it's a general recipes request (not search)
      if (search == null) {
        await LocalStorageService.cacheRecipes(response.recipes);
      }

      return Right(response);
    } on DioException catch (e) {
      // If API call fails, try to return cached data
      if (search == null) {
        final cachedRecipes = LocalStorageService.getCachedRecipes();
        if (cachedRecipes.isNotEmpty) {
          // Apply pagination to cached data
          final startIndex = skip;
          final paginatedRecipes = cachedRecipes
              .skip(startIndex)
              .take(limit)
              .toList();

          if (paginatedRecipes.isNotEmpty) {
            return Right(
              RecipesResponse(
                recipes: paginatedRecipes,
                total: cachedRecipes.length,
                skip: skip,
                limit: limit,
              ),
            );
          }
        }
      }

      return Left(_handleDioError(e));
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.connectionTimeout) {
        return const Left(NetworkFailure('Connection timeout'));
      }
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Recipe>> getRecipe(int id) async {
    try {
      // Try to get from cache first
      final cachedRecipe = LocalStorageService.getCachedRecipe(id);
      if (cachedRecipe != null) {
        return Right(cachedRecipe);
      }

      // If not in cache, fetch from API
      final recipe = await _apiService.getRecipe(id);

      // Cache the recipe
      await LocalStorageService.cacheRecipe(recipe);

      return Right(recipe);
    } on DioException catch (e) {
      // If API call fails, try to return cached data
      final cachedRecipe = LocalStorageService.getCachedRecipe(id);
      if (cachedRecipe != null) {
        return Right(cachedRecipe);
      }

      return Left(_handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, RecipesResponse>> searchRecipes({
    required String query,
    int limit = 20,
    int skip = 0,
  }) async {
    try {
      final response = await _apiService.searchRecipes(
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
  Future<Either<Failure, List<String>>> getRecipeTags() async {
    try {
      final tags = await _apiService.getRecipeTags();
      return Right(tags);
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
