import 'package:task/core/storage/local_storage_service.dart';

class CacheManager {
  /// Clear all cached data
  static Future<void> clearAllCache() async {
    await LocalStorageService.clearCache();
  }

  /// Clear only search history
  static Future<void> clearSearchHistory() async {
    await LocalStorageService.clearSearchHistory();
  }

  /// Clear only favorites
  static Future<void> clearFavorites() async {
    await LocalStorageService.clearFavorites();
  }

  /// Check if cache is valid (not expired)
  static bool isCacheValid() => LocalStorageService.isCacheValid();

  /// Get the last time data was fetched
  static DateTime? getLastFetchTime() => LocalStorageService.getLastFetchTime();

  /// Get cache age
  static Duration? getCacheAge() {
    final lastFetch = getLastFetchTime();
    if (lastFetch == null) {
      return null;
    }

    return DateTime.now().difference(lastFetch);
  }

  /// Check if cache is stale (older than threshold)
  static bool isCacheStale({Duration? threshold}) {
    final cacheAge = getCacheAge();
    if (cacheAge == null) {
      return true;
    }

    final staleThreshold = threshold ?? const Duration(hours: 2);
    return cacheAge > staleThreshold;
  }

  /// Get cache statistics
  static Map<String, dynamic> getCacheStats() {
    final cachedProducts = LocalStorageService.getCachedProducts();
    final cachedRecipes = LocalStorageService.getCachedRecipes();
    final cachedCategories = LocalStorageService.getCachedCategories();
    final searchHistory = LocalStorageService.getSearchHistory();
    final favoriteProductIds = LocalStorageService.getFavoriteIds('product');
    final favoriteRecipeIds = LocalStorageService.getFavoriteIds('recipe');

    return {
      'products_count': cachedProducts.length,
      'recipes_count': cachedRecipes.length,
      'categories_count': cachedCategories.length,
      'search_history_count': searchHistory.length,
      'favorite_products_count': favoriteProductIds.length,
      'favorite_recipes_count': favoriteRecipeIds.length,
      'last_fetch_time': getLastFetchTime()?.toIso8601String(),
      'cache_age': getCacheAge()?.inMinutes,
      'is_valid': isCacheValid(),
      'is_stale': isCacheStale(),
    };
  }

  /// Force refresh cache by clearing and setting as invalid
  static Future<void> forceRefresh() async {
    await clearAllCache();
    // This will force the app to fetch fresh data on next request
  }

  /// Preload essential data for offline use
  static Future<void> preloadEssentialData() async {
    // This method can be called during app startup to ensure
    // essential data is available offline
    try {
      // The repositories will handle the actual data loading
      // This is just a placeholder for future implementation
    } catch (e) {
      // Handle preload errors gracefully
    }
  }

  /// Check available offline data
  static Map<String, bool> getOfflineDataAvailability() {
    final cachedProducts = LocalStorageService.getCachedProducts();
    final cachedRecipes = LocalStorageService.getCachedRecipes();
    final cachedCategories = LocalStorageService.getCachedCategories();
    final favoriteProducts = LocalStorageService.getFavoriteIds('product');
    final favoriteRecipes = LocalStorageService.getFavoriteIds('recipe');
    final searchHistory = LocalStorageService.getSearchHistory();

    return {
      'products': cachedProducts.isNotEmpty,
      'recipes': cachedRecipes.isNotEmpty,
      'categories': cachedCategories.isNotEmpty,
      'search_history': searchHistory.isNotEmpty,
      'favorites': favoriteProducts.isNotEmpty || favoriteRecipes.isNotEmpty,
    };
  }

  /// Get offline data summary
  static String getOfflineDataSummary() {
    final cachedProducts = LocalStorageService.getCachedProducts();
    final cachedRecipes = LocalStorageService.getCachedRecipes();
    final cachedCategories = LocalStorageService.getCachedCategories();
    final searchHistory = LocalStorageService.getSearchHistory();
    final favoriteProductIds = LocalStorageService.getFavoriteIds('product');
    final favoriteRecipeIds = LocalStorageService.getFavoriteIds('recipe');
    final lastFetchTime = getLastFetchTime();
    final cacheIsValid = isCacheValid();

    final summary = StringBuffer()
      ..writeln('📱 Offline Data Summary:')
      ..writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━')
      ..writeln('📦 Products: ${cachedProducts.length} cached')
      ..writeln('🍳 Recipes: ${cachedRecipes.length} cached')
      ..writeln('🏷️ Categories: ${cachedCategories.length} cached')
      ..writeln('🔍 Search History: ${searchHistory.length} entries')
      ..writeln(
        '❤️ Favorites: ${favoriteProductIds.length + favoriteRecipeIds.length} total',
      )
      ..writeln(
        '⏰ Last Updated: ${lastFetchTime?.toIso8601String() ?? 'Never'}',
      )
      ..writeln('🔄 Cache Status: ${cacheIsValid ? 'Valid' : 'Expired'}')
      ..writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

    return summary.toString();
  }
}
