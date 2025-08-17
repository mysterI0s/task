import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task/core/config/app_config.dart';
import 'package:task/features/products/domain/entities/product.dart';
import 'package:task/features/recipes/domain/entities/recipe.dart';

class LocalStorageService {
  static const String _productsKey = 'cached_products';
  static const String _recipesKey = 'cached_recipes';
  static const String _categoriesKey = 'cached_categories';
  static const String _lastFetchTimeKey = 'last_fetch_time';
  static const String _searchHistoryKey = 'search_history';
  static const String _appStateKey = 'app_state';

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Products storage
  static Future<void> cacheProducts(List<Product> products) async {
    final productsJson = products.map((p) => p.toJson()).toList();
    await _prefs.setString(_productsKey, jsonEncode(productsJson));
    await _updateLastFetchTime();
  }

  static List<Product> getCachedProducts() {
    try {
      final productsString = _prefs.getString(_productsKey);
      if (productsString != null) {
        final productsList = jsonDecode(productsString) as List;
        return productsList
            .map((json) => Product.fromJson(json as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      // If there's an error parsing, return empty list
    }
    return [];
  }

  static Product? getCachedProduct(int id) {
    try {
      final products = getCachedProducts();
      return products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  static Future<void> cacheProduct(Product product) async {
    final products = getCachedProducts();
    final existingIndex = products.indexWhere((p) => p.id == product.id);

    if (existingIndex != -1) {
      products[existingIndex] = product;
    } else {
      products.add(product);
    }

    await cacheProducts(products);
  }

  // Recipes storage
  static Future<void> cacheRecipes(List<Recipe> recipes) async {
    final recipesJson = recipes.map((r) => r.toJson()).toList();
    await _prefs.setString(_recipesKey, jsonEncode(recipesJson));
    await _updateLastFetchTime();
  }

  static List<Recipe> getCachedRecipes() {
    try {
      final recipesString = _prefs.getString(_recipesKey);
      if (recipesString != null) {
        final recipesList = jsonDecode(recipesString) as List;
        return recipesList
            .map((json) => Recipe.fromJson(json as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      // If there's an error parsing, return empty list
    }
    return [];
  }

  static Recipe? getCachedRecipe(int id) {
    try {
      final recipes = getCachedRecipes();
      return recipes.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }

  static Future<void> cacheRecipe(Recipe recipe) async {
    final recipes = getCachedRecipes();
    final existingIndex = recipes.indexWhere((r) => r.id == recipe.id);

    if (existingIndex != -1) {
      recipes[existingIndex] = recipe;
    } else {
      recipes.add(recipe);
    }

    await cacheRecipes(recipes);
  }

  // Categories storage
  static Future<void> cacheCategories(List<String> categories) async {
    await _prefs.setStringList(_categoriesKey, categories);
  }

  static List<String> getCachedCategories() =>
      _prefs.getStringList(_categoriesKey) ?? [];

  // Search history
  static Future<void> addSearchQuery(String query) async {
    final history = getSearchHistory();
    if (!history.contains(query)) {
      history.insert(0, query);
      if (history.length > 10) {
        history.removeLast();
      }
      await _prefs.setStringList(_searchHistoryKey, history);
    }
  }

  static List<String> getSearchHistory() =>
      _prefs.getStringList(_searchHistoryKey) ?? [];

  // Favorites
  static Future<void> toggleFavorite(int id, String type) async {
    final key = '${type}_$id';
    final isFavorite = _prefs.getBool(key) ?? false;
    await _prefs.setBool(key, !isFavorite);
  }

  static bool isFavorite(int id, String type) {
    final key = '${type}_$id';
    return _prefs.getBool(key) ?? false;
  }

  static List<int> getFavoriteIds(String type) {
    final favorites = <int>[];
    final keys = _prefs.getKeys();

    for (final key in keys) {
      if (key.startsWith('${type}_') && _prefs.getBool(key) == true) {
        final id = int.tryParse(key.substring(type.length + 1));
        if (id != null) {
          favorites.add(id);
        }
      }
    }
    return favorites;
  }

  // App state persistence
  static Future<void> saveAppState(Map<String, dynamic> state) async {
    await _prefs.setString(_appStateKey, jsonEncode(state));
  }

  static Map<String, dynamic> getAppState() {
    try {
      final stateString = _prefs.getString(_appStateKey);
      if (stateString != null) {
        final decoded = jsonDecode(stateString);
        if (decoded is Map) {
          return Map<String, dynamic>.from(decoded);
        }
      }
    } catch (e) {
      // If there's an error parsing, return empty map
    }
    return {};
  }

  // Cache management
  static Future<void> _updateLastFetchTime() async {
    await _prefs.setInt(
      _lastFetchTimeKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  static DateTime? getLastFetchTime() {
    final timestamp = _prefs.getInt(_lastFetchTimeKey);
    if (timestamp != null) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return null;
  }

  static bool isCacheValid() {
    final lastFetch = getLastFetchTime();
    if (lastFetch == null) {
      return false;
    }

    final now = DateTime.now();
    final difference = now.difference(lastFetch);
    return difference < AppConfig.cacheExpiration;
  }

  static Future<void> clearCache() async {
    await _prefs.remove(_productsKey);
    await _prefs.remove(_recipesKey);
    await _prefs.remove(_categoriesKey);
    await _prefs.remove(_lastFetchTimeKey);
    await _prefs.remove(_appStateKey);
  }

  static Future<void> clearSearchHistory() async {
    await _prefs.remove(_searchHistoryKey);
  }

  static Future<void> clearFavorites() async {
    final keys = _prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith('product_') || key.startsWith('recipe_')) {
        await _prefs.remove(key);
      }
    }
  }
}
