import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task/core/widgets/error_widget.dart';
import 'package:task/core/widgets/loading_widget.dart';
import 'package:task/features/products/application/providers/product_provider.dart';
import 'package:task/features/products/domain/entities/product.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  const ProductDetailsScreen({super.key, required this.productId});
  final int productId;

  @override
  ConsumerState<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _imageController;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _imageController = PageController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productProvider(widget.productId));

    return Scaffold(
      body: productAsync.when(
        data: _buildProductDetails,
        loading: () =>
            const LoadingWidget(message: 'Loading product details...'),
        error: (error, stack) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.refresh(productProvider(widget.productId)),
        ),
      ),
    );
  }

  Widget _buildProductDetails(Product product) => CustomScrollView(
    slivers: [
      // App Bar with Images
      SliverAppBar(
        expandedHeight: 400,
        pinned: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        flexibleSpace: FlexibleSpaceBar(
          background: _buildImageCarousel(product),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border_rounded),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.share_rounded)),
        ],
      ),

      // Product Info
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Price
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.brand ?? 'Unknown Brand',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      if (product.discountPercentage != null &&
                          product.discountPercentage! > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${product.discountPercentage!.toStringAsFixed(0)}% OFF',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onErrorContainer,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Rating and Stock
              Row(
                children: [
                  // Rating
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          (product.rating ?? 0.0).toStringAsFixed(1),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                              ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${product.reviews?.length ?? 0})',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                              ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Stock Status
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: (product.stock ?? 0) > 0
                          ? Theme.of(context).colorScheme.secondaryContainer
                          : Theme.of(context).colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      (product.stock ?? 0) > 0
                          ? 'In Stock (${product.stock})'
                          : 'Out of Stock',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: (product.stock ?? 0) > 0
                            ? Theme.of(context).colorScheme.onSecondaryContainer
                            : Theme.of(context).colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Tags
              if (product.tags?.isNotEmpty == true) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: product.tags!
                      .map(
                        (tag) => Chip(
                          label: Text(tag),
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          labelStyle: Theme.of(context).textTheme.bodySmall,
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 20),
              ],
            ],
          ),
        ),
      ),

      // Tabs
      SliverPersistentHeader(
        pinned: true,
        delegate: _StickyTabBarDelegate(
          child: Container(
            color: Theme.of(context).colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Theme.of(
                context,
              ).colorScheme.onSurfaceVariant,
              indicatorColor: Theme.of(context).colorScheme.primary,
              tabs: const [
                Tab(text: 'Description'),
                Tab(text: 'Details'),
                Tab(text: 'Reviews'),
              ],
            ),
          ),
        ),
      ),

      // Tab Content
      SliverFillRemaining(
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildDescriptionTab(product),
            _buildDetailsTab(product),
            _buildReviewsTab(product),
          ],
        ),
      ),
    ],
  );

  Widget _buildImageCarousel(Product product) {
    final images = (product.images?.isNotEmpty == true)
        ? product.images!
        : [product.thumbnail ?? ''];

    return Stack(
      children: [
        PageView.builder(
          controller: _imageController,
          onPageChanged: (index) {
            setState(() {
              _currentImageIndex = index;
            });
          },
          itemCount: images.length,
          itemBuilder: (context, index) => CachedNetworkImage(
            imageUrl: images[index],
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: const Icon(Icons.image_not_supported, size: 64),
            ),
          ),
        ),

        // Image indicators
        if (images.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: images
                  .asMap()
                  .entries
                  .map(
                    (entry) => Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentImageIndex == entry.key
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.3),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildDescriptionTab(Product product) => SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Text(
      product.description,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
    ),
  );

  Widget _buildDetailsTab(Product product) => SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        _buildDetailItem('Category', product.category),
        _buildDetailItem('SKU', product.sku ?? 'N/A'),
        _buildDetailItem('Weight', '${product.weight ?? 0}g'),
        if (product.dimensions != null)
          _buildDetailItem(
            'Dimensions',
            '${product.dimensions!.width} × ${product.dimensions!.height} × ${product.dimensions!.depth} cm',
          ),
        _buildDetailItem('Warranty', product.warrantyInformation ?? 'N/A'),
        _buildDetailItem('Shipping', product.shippingInformation ?? 'N/A'),
        _buildDetailItem('Return Policy', product.returnPolicy ?? 'N/A'),
        _buildDetailItem(
          'Minimum Order',
          '${product.minimumOrderQuantity ?? 1} units',
        ),
        _buildDetailItem('Availability', product.availabilityStatus ?? 'N/A'),
      ],
    ),
  );

  Widget _buildDetailItem(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    ),
  );

  Widget _buildReviewsTab(Product product) {
    if (product.reviews?.isEmpty != false) {
      return const Center(child: Text('No reviews available'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: product.reviews!.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final review = product.reviews![index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Row(
            children: [
              Text(
                review.reviewerName,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Row(
                children: List.generate(
                  5,
                  (starIndex) => Icon(
                    starIndex < review.rating ? Icons.star : Icons.star_border,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(review.comment),
              const SizedBox(height: 4),
              Text(
                review.date.toString().substring(0, 10),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  _StickyTabBarDelegate({required this.child});
  final Widget child;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => child;

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
