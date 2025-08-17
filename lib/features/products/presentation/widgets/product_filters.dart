import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task/core/localization/app_localizations.dart';

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
    final productsState = ref.watch(productsProvider);

    // Sync local state with provider state (only when they differ)
    if (productsState.sortBy != null &&
        productsState.sortOrder != null &&
        (selectedSortBy != productsState.sortBy ||
            selectedOrder != productsState.sortOrder)) {
      // Use Future.microtask to avoid calling setState during build
      Future.microtask(() {
        if (mounted) {
          setState(() {
            selectedSortBy = productsState.sortBy!;
            selectedOrder = productsState.sortOrder!;
          });
        }
      });
    }

    // Ensure selectedSortBy is always valid
    final validSortBy =
        sortOptions.any((option) => option['key'] == selectedSortBy)
        ? selectedSortBy
        : sortOptions.first['key']!;

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
                AppLocalizations.of(context)?.filter ?? 'Filters',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    selectedCategory = null;
                    // Keep current sorting, just clear category
                    // selectedSortBy and selectedOrder remain unchanged
                  });
                  // Just call onClearFilters, which should preserve sorting
                  widget.onClearFilters();
                },
                child: Text(
                  AppLocalizations.of(context)?.clearAll ?? 'Clear All',
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Categories
          Text(
            AppLocalizations.of(context)?.category ?? 'Categories',
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
                  label: Text(AppLocalizations.of(context)?.home ?? 'All'),
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
            AppLocalizations.of(context)?.sortBy ?? 'Sort By',
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
                  value: validSortBy,
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
                          child: Text(
                            _getLocalizedSortOptionLabel(
                              context,
                              option['key']!,
                            ),
                          ),
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
                  items: [
                    DropdownMenuItem(
                      value: 'asc',
                      child: Text(_getSortOrderLabel(selectedSortBy, 'asc')),
                    ),
                    DropdownMenuItem(
                      value: 'desc',
                      child: Text(_getSortOrderLabel(selectedSortBy, 'desc')),
                    ),
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

  String _getSortOrderLabel(String sortBy, String order) {
    if (sortBy == 'title') {
      return order == 'asc' ? 'A-Z' : 'Z-A';
    } else if (sortBy == 'price') {
      return order == 'asc' ? '↑' : '↓';
    } else if (sortBy == 'rating') {
      return order == 'asc' ? '↑' : '↓';
    }
    return order == 'asc' ? 'A-Z' : 'Z-A';
  }

  String _getLocalizedSortOptionLabel(BuildContext context, String key) {
    switch (key) {
      case 'title':
        return AppLocalizations.of(context)?.description ?? 'Name';
      case 'price':
        return AppLocalizations.of(context)?.price ?? 'Price';
      case 'rating':
        return AppLocalizations.of(context)?.rating ?? 'Rating';
      case 'category':
        return AppLocalizations.of(context)?.category ?? 'Category';
      default:
        return 'Name';
    }
  }
}
