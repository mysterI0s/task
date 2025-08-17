import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task/features/products/application/providers/product_provider.dart';
import 'package:task/features/recipes/data/api/recipe_api_service.dart';
import 'package:task/features/recipes/domain/repositories/recipe_repository_impl.dart';

import '../../../../core/config/app_config.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/repositories/recipe_repository.dart';

// API Service provider
final recipeApiServiceProvider = Provider<RecipeApiService>((ref) {
  final dio = ref.read(dioProvider);
  return RecipeApiService(dio);
});

// Repository provider
final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  final apiService = ref.read(recipeApiServiceProvider);
  return RecipeRepositoryImpl(apiService);
});

// Recipes list state
class RecipesState {
  const RecipesState({
    this.recipes = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.hasMore = true,
    this.currentPage = 0,
    this.searchQuery,
  });
  final List<Recipe> recipes;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final bool hasMore;
  final int currentPage;
  final String? searchQuery;

  RecipesState copyWith({
    List<Recipe>? recipes,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    bool? hasMore,
    int? currentPage,
    String? searchQuery,
  }) => RecipesState(
    recipes: recipes ?? this.recipes,
    isLoading: isLoading ?? this.isLoading,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    error: error,
    hasMore: hasMore ?? this.hasMore,
    currentPage: currentPage ?? this.currentPage,
    searchQuery: searchQuery ?? this.searchQuery,
  );
}

// Recipes provider
final recipesProvider = StateNotifierProvider<RecipesNotifier, RecipesState>((
  ref,
) {
  final repository = ref.read(recipeRepositoryProvider);
  return RecipesNotifier(repository);
});

class RecipesNotifier extends StateNotifier<RecipesState> {
  RecipesNotifier(this._repository) : super(const RecipesState()) {
    loadRecipes();
  }
  final RecipeRepository _repository;

  Future<void> loadRecipes({bool refresh = false}) async {
    if (refresh) {
      state = state.copyWith(
        isLoading: true,
        currentPage: 0,
        recipes: [],
        hasMore: true,
      );
    } else if (state.isLoading || state.isLoadingMore) {
      return;
    } else {
      state = state.copyWith(isLoading: true);
    }

    final result = await _repository.getRecipes(
      skip: state.currentPage * AppConfig.defaultPageSize,
      search: state.searchQuery,
    );

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (response) => state = state.copyWith(
        isLoading: false,
        recipes: refresh
            ? response.recipes
            : [...state.recipes, ...response.recipes],
        hasMore: response.recipes.length == AppConfig.defaultPageSize,
        currentPage: refresh ? 1 : state.currentPage + 1,
      ),
    );
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoadingMore) {
      return;
    }

    state = state.copyWith(isLoadingMore: true);

    final result = await _repository.getRecipes(
      skip: state.currentPage * AppConfig.defaultPageSize,
      search: state.searchQuery,
    );

    result.fold(
      (failure) =>
          state = state.copyWith(isLoadingMore: false, error: failure.message),
      (response) => state = state.copyWith(
        isLoadingMore: false,
        recipes: [...state.recipes, ...response.recipes],
        hasMore: response.recipes.length == AppConfig.defaultPageSize,
        currentPage: state.currentPage + 1,
      ),
    );
  }

  Future<void> searchRecipes(String query) async {
    state = state.copyWith(
      searchQuery: query,
      currentPage: 0,
      recipes: [],
      hasMore: true,
    );

    if (query.isEmpty) {
      await loadRecipes(refresh: true);
      return;
    }

    state = state.copyWith(isLoading: true);

    final result = await _repository.searchRecipes(query: query);

    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (response) => state = state.copyWith(
        isLoading: false,
        recipes: response.recipes,
        hasMore: response.recipes.length == AppConfig.defaultPageSize,
        currentPage: 1,
      ),
    );
  }

  void clearSearch() {
    state = state.copyWith(currentPage: 0, recipes: [], hasMore: true);
    loadRecipes(refresh: true);
  }
}

// Single recipe provider
final recipeProvider = FutureProvider.family<Recipe, int>((ref, id) async {
  final repository = ref.read(recipeRepositoryProvider);
  final result = await repository.getRecipe(id);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (recipe) => recipe,
  );
});

// Recipe tags provider
final recipeTagsProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.read(recipeRepositoryProvider);
  final result = await repository.getRecipeTags();

  return result.fold(
    (failure) => throw Exception(failure.message),
    (tags) => tags,
  );
});
