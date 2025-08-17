import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/providers/product_provider.dart';

class ProductFilters extends ConsumerStatefulWidget {
  const ProductFilters({
    super.key,
    required this.onCategoryChanged,
    required this.onSortChanged,
    required this.onClearFilters,
  });
  final Function(String?) onCategoryChanged;
  final Function(String, String) onSortChanged;
  final VoidCallback onClearFilters;

  @override
  ConsumerState<ProductFilters> createState() => _ProductFiltersState();
}

class _ProductFiltersState extends ConsumerState<ProductFilters> {
  String? selectedCategory;
  String selectedSortBy = 'title';
  String selectedOrder = 'asc';

  final List<Map<String, String>> sortOptions = [
    {'key': 'title', 'label': 'Name'},
    {'key': 'price', 'label': 'Price'},
    {'key': 'rating', 'label': 'Rating'},
    {'key': 'category', 'label': 'Category'},
  ];

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filters',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    selectedCategory = null;
                    selectedSortBy = 'title';
                    selectedOrder = 'asc';
                  });
                  widget.onClearFilters();
                },
                child: const Text('Clear All'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Categories
          Text(
            'Categories',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),

          categoriesAsync.when(
            data: (categories) => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // All Categories chip
                FilterChip(
                  label: const Text('All'),
                  selected: selectedCategory == null,
                  onSelected: (selected) {
                    setState(() {
                      selectedCategory = null;
                    });
                    widget.onCategoryChanged(null);
                  },
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest,
                  selectedColor: Theme.of(context).colorScheme.primaryContainer,
                ),

                // Category chips
                ...categories.map(
                  (category) => FilterChip(
                    label: Text(_formatCategory(category)),
                    selected: selectedCategory == category,
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = selected ? category : null;
                      });
                      widget.onCategoryChanged(selected ? category : null);
                    },
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    selectedColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                  ),
                ),
              ],
            ),
            loading: () => const CircularProgressIndicator(),
            error: (error, stack) => Text('Error loading categories: $error'),
          ),

          const SizedBox(height: 16),

          // Sort Options
          Text(
            'Sort By',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              // Sort by dropdown
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  value: selectedSortBy,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  items: sortOptions
                      .map(
                        (option) => DropdownMenuItem<String>(
                          value: option['key'],
                          child: Text(option['label']!),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedSortBy = value;
                      });
                      widget.onSortChanged(selectedSortBy, selectedOrder);
                    }
                  },
                ),
              ),

              const SizedBox(width: 12),

              // Sort order
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedOrder,
                  decoration: const InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'asc', child: Text('A-Z')),
                    DropdownMenuItem(value: 'desc', child: Text('Z-A')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedOrder = value;
                      });
                      widget.onSortChanged(selectedSortBy, selectedOrder);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatCategory(String category) => category
      .split('-')
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join(' ');
}
