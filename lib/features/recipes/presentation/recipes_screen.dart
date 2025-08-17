import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:task/core/localization/app_localizations.dart';
import 'package:task/core/widgets/error_widget.dart';
import 'package:task/core/widgets/loading_widget.dart';
import 'package:task/features/recipes/application/providers/recipe_provider.dart';
import 'package:task/features/recipes/presentation/widgets/recipe_card.dart';
import 'package:task/features/recipes/presentation/widgets/recipe_search_bar.dart';

class RecipesScreen extends ConsumerStatefulWidget {
  const RecipesScreen({super.key});

  @override
  ConsumerState<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends ConsumerState<RecipesScreen> {
  final RefreshController _refreshController = RefreshController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(recipesProvider.notifier).loadMore();
    }
  }

  Future<void> _onRefresh() async {
    await ref.read(recipesProvider.notifier).loadRecipes(refresh: true);
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final recipesState = ref.watch(recipesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.recipes ?? 'Recipes'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: RecipeSearchBar(
              onSearch: (query) {
                ref.read(recipesProvider.notifier).searchRecipes(query);
              },
            ),
          ),

          // Recipes List
          Expanded(child: _buildRecipesList(recipesState)),
        ],
      ),
    );
  }

  Widget _buildRecipesList(RecipesState state) {
    if (state.isLoading && state.recipes.isEmpty) {
      return LoadingWidget(
        message:
            '${AppLocalizations.of(context)?.loading ?? 'Loading'} ${AppLocalizations.of(context)?.recipes.toLowerCase() ?? 'recipes'}...',
      );
    }

    if (state.error != null && state.recipes.isEmpty) {
      return AppErrorWidget(
        message: state.error!,
        onRetry: () {
          ref.read(recipesProvider.notifier).loadRecipes(refresh: true);
        },
      );
    }

    if (state.recipes.isEmpty) {
      return AppEmptyWidget(
        message: AppLocalizations.of(context)?.noData ?? 'No recipes found',
        icon: Icons.restaurant_outlined,
      );
    }

    return SmartRefresher(
      controller: _refreshController,
      onRefresh: _onRefresh,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.51,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final recipe = state.recipes[index];
                return RecipeCard(
                  recipe: recipe,
                  onTap: () {
                    context.push('/recipe/${recipe.id}');
                  },
                );
              }, childCount: state.recipes.length),
            ),
          ),

          // Loading more indicator
          if (state.isLoadingMore)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),

          // End of list indicator
          if (!state.hasMore && state.recipes.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)?.loadMore ??
                        'No more recipes to load',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
        ],
      ),
    );
  }
}
