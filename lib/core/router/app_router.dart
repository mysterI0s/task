import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:task/core/localization/app_localizations.dart';
import 'package:task/features/main/presentation/main_screen.dart';
import 'package:task/features/products/presentation/product_details_screen.dart';
import 'package:task/features/recipes/presentation/recipe_details_screen.dart';
import 'package:task/features/recipes/presentation/settings_screen.dart';

import '../../features/splash/presentation/splash_screen.dart';

final appRouterProvider = Provider<GoRouter>(
  (ref) => GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    routes: [
      // Splash Screen
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Main Screen with Bottom Navigation
      ShellRoute(
        builder: (context, state, child) => MainScreen(child: child),
        routes: [
          // Home Tab - Products
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) =>
                const SizedBox(), // MainScreen handles this
          ),

          // Recipes Tab
          GoRoute(
            path: '/recipes',
            name: 'recipes',
            builder: (context, state) =>
                const SizedBox(), // MainScreen handles this
          ),

          // Settings Tab
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),

      // Product Details
      GoRoute(
        path: '/product/:id',
        name: 'product-details',
        builder: (context, state) {
          final productId = int.parse(state.pathParameters['id']!);
          return ProductDetailsScreen(productId: productId);
        },
      ),

      // Recipe Details
      GoRoute(
        path: '/recipe/:id',
        name: 'recipe-details',
        builder: (context, state) {
          final recipeId = int.parse(state.pathParameters['id']!);
          return RecipeDetailsScreen(recipeId: recipeId);
        },
      ),
    ],

    // Error handling
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)?.error ?? 'Page Not Found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)?.noData ??
                  'The page you are looking for does not exist.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: Text(AppLocalizations.of(context)?.goHome ?? 'Go Home'),
            ),
          ],
        ),
      ),
    ),
  ),
);
