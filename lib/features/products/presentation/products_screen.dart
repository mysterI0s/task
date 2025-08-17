import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:task/core/widgets/error_widget.dart';
import 'package:task/core/widgets/loading_widget.dart';
import 'package:task/features/products/application/providers/product_provider.dart';
import 'package:task/features/products/presentation/widgets/product_card.dart';
import 'package:task/features/products/presentation/widgets/product_filters.dart';
import 'package:task/features/products/presentation/widgets/product_search_bar.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  final RefreshController _refreshController = RefreshController();
  final ScrollController _scrollController = ScrollController();
  bool _showFilters = false;

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
      ref.read(productsProvider.notifier).loadMore();
    }
  }

  Future<void> _onRefresh() async {
    await ref.read(productsProvider.notifier).loadProducts(refresh: true);
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
            icon: Icon(
              _showFilters ? Icons.filter_list_off : Icons.filter_list,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: ProductSearchBar(
              onSearch: (query) {
                ref.read(productsProvider.notifier).searchProducts(query);
              },
            ),
          ),

          // Filters
          if (_showFilters)
            ProductFilters(
              onCategoryChanged: (category) {
                ref.read(productsProvider.notifier).filterByCategory(category);
              },
              onSortChanged: (sortBy, order) {
                ref.read(productsProvider.notifier).sortProducts(sortBy, order);
              },
              onClearFilters: () {
                ref.read(productsProvider.notifier).clearFilters();
              },
            ),

          // Products List
          Expanded(child: _buildProductsList(productsState)),
        ],
      ),
    );
  }

  Widget _buildProductsList(ProductsState state) {
    if (state.isLoading && state.products.isEmpty) {
      return const LoadingWidget();
    }

    if (state.error != null && state.products.isEmpty) {
      return AppErrorWidget(
        message: state.error!,
        onRetry: () {
          ref.read(productsProvider.notifier).loadProducts(refresh: true);
        },
      );
    }

    if (state.products.isEmpty) {
      return const AppEmptyWidget(
        message: 'No products found',
        icon: Icons.inventory_2_outlined,
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
                childAspectRatio: 0.50,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final product = state.products[index];
                return ProductCard(
                  product: product,
                  onTap: () {
                    context.push('/product/${product.id}');
                  },
                );
              }, childCount: state.products.length),
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
          if (!state.hasMore && state.products.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    'No more products to load',
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
