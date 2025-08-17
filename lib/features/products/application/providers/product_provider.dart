import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task/features/products/data/api/product_api_service.dart';
import 'package:task/features/products/domain/repositories/product_repository_impl.dart';

import '../../../../core/config/app_config.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

// Dio provider
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  dio.options.baseUrl = AppConfig.baseUrl;
  dio.options.connectTimeout = AppConfig.connectTimeout;
  dio.options.receiveTimeout = AppConfig.receiveTimeout;
  dio.options.sendTimeout = AppConfig.sendTimeout;

  if (AppConfig.isDebug) {
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    // Add custom interceptor to log request details
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );
  }

  return dio;
});

// API Service provider
final productApiServiceProvider = Provider<ProductApiService>((ref) {
  final dio = ref.read(dioProvider);
  return ProductApiService(dio);
});

// Repository provider
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final apiService = ref.read(productApiServiceProvider);
  return ProductRepositoryImpl(apiService);
});

// Products list state
class ProductsState {
  const ProductsState({
    this.products = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.hasMore = true,
    this.currentPage = 0,
    this.searchQuery,
    this.selectedCategory,
    this.sortBy,
    this.sortOrder,
  });
  final List<Product> products;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final bool hasMore;
  final int currentPage;
  final String? searchQuery;
  final String? selectedCategory;
  final String? sortBy;
  final String? sortOrder;

  ProductsState copyWith({
    List<Product>? products,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    bool? hasMore,
    int? currentPage,
    String? searchQuery,
    String? selectedCategory,
    String? sortBy,
    String? sortOrder,
  }) => ProductsState(
    products: products ?? this.products,
    isLoading: isLoading ?? this.isLoading,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    error: error,
    hasMore: hasMore ?? this.hasMore,
    currentPage: currentPage ?? this.currentPage,
    searchQuery: searchQuery ?? this.searchQuery,
    selectedCategory: selectedCategory ?? this.selectedCategory,
    sortBy: sortBy ?? this.sortBy,
    sortOrder: sortOrder ?? this.sortOrder,
  );
}

// Products provider
final productsProvider = StateNotifierProvider<ProductsNotifier, ProductsState>(
  (ref) {
    final repository = ref.read(productRepositoryProvider);
    return ProductsNotifier(repository);
  },
);

class ProductsNotifier extends StateNotifier<ProductsState> {
  ProductsNotifier(this._repository)
    : super(const ProductsState(sortBy: 'title', sortOrder: 'asc')) {
    loadProducts();
  }
  final ProductRepository _repository;

  Future<void> loadProducts({bool refresh = false}) async {
    if (refresh) {
      state = state.copyWith(
        isLoading: true,
        currentPage: 0,
        products: [],
        hasMore: true,
      );
    } else if (state.isLoading || state.isLoadingMore) {
      return;
    } else {
      state = state.copyWith(isLoading: true);
    }

    // Debug logging for API call parameters

    final result = await _repository.getProducts(
      skip: state.currentPage * AppConfig.defaultPageSize,
      search: state.searchQuery,
      category: state.selectedCategory,
      sortBy: state.sortBy,
      order: state.sortOrder,
    );

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (response) {
        // Debug logging for response
        if (response.products.isNotEmpty) {}

        state = state.copyWith(
          isLoading: false,
          products: refresh
              ? response.products
              : [...state.products, ...response.products],
          hasMore: response.products.length == AppConfig.defaultPageSize,
          currentPage: refresh ? 1 : state.currentPage + 1,
        );
      },
    );
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore) {
      return;
    }

    state = state.copyWith(isLoadingMore: true);

    final result = await _repository.getProducts(
      skip: state.currentPage * AppConfig.defaultPageSize,
      search: state.searchQuery,
      category: state.selectedCategory,
      sortBy: state.sortBy,
      order: state.sortOrder,
    );

    result.fold(
      (failure) =>
          state = state.copyWith(isLoadingMore: false, error: failure.message),
      (response) => state = state.copyWith(
        isLoadingMore: false,
        products: [...state.products, ...response.products],
        hasMore: response.products.length == AppConfig.defaultPageSize,
        currentPage: state.currentPage + 1,
      ),
    );
  }

  Future<void> searchProducts(String query) async {
    state = state.copyWith(
      searchQuery: query,
      currentPage: 0,
      products: [],
      hasMore: true,
    );
    await loadProducts(refresh: true);
  }

  Future<void> filterByCategory(String? category) async {
    state = state.copyWith(
      selectedCategory: category,
      currentPage: 0,
      products: [],
      hasMore: true,
    );
    await loadProducts(refresh: true);
  }

  Future<void> sortProducts(String sortBy, String order) async {
    // Debug logging for sorting

    state = state.copyWith(
      sortBy: sortBy,
      sortOrder: order,
      currentPage: 0,
      products: [],
      hasMore: true,
    );

    await loadProducts(refresh: true);
  }

  void clearFilters() {
    state = state.copyWith(
      currentPage: 0,
      products: [],
      hasMore: true,
      // Keep current sorting parameters
    );
    loadProducts(refresh: true);
  }
}

// Single product provider
final productProvider = FutureProvider.family<Product, int>((ref, id) async {
  final repository = ref.read(productRepositoryProvider);
  final result = await repository.getProduct(id);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (product) => product,
  );
});

// Categories provider
final categoriesProvider = FutureProvider<List<String>>((ref) async {
  try {
    // Get products first to extract categories from them
    final productsState = ref.read(productsProvider);

    // If we already have products, extract categories from them
    if (productsState.products.isNotEmpty) {
      final categoriesSet = <String>{};
      for (final product in productsState.products) {
        if (product.category.isNotEmpty) {
          categoriesSet.add(product.category);
        }
      }
      return categoriesSet.toList()..sort();
    }

    // If no products yet, load them first
    final productsNotifier = ref.read(productsProvider.notifier);
    await productsNotifier.loadProducts(refresh: true);

    // Now extract categories from the loaded products
    final currentState = ref.read(productsProvider);
    final categoriesSet = <String>{};
    for (final product in currentState.products) {
      if (product.category.isNotEmpty) {
        categoriesSet.add(product.category);
      }
    }

    return categoriesSet.toList()..sort();
  } catch (e) {
    throw Exception('Failed to load categories: $e');
  }
});
