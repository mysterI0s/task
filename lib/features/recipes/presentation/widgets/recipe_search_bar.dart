import 'package:flutter/material.dart';
import 'package:task/core/localization/app_localizations.dart';

class RecipeSearchBar extends StatefulWidget {
  const RecipeSearchBar({super.key, required this.onSearch, this.initialQuery});
  final Function(String) onSearch;
  final String? initialQuery;

  @override
  State<RecipeSearchBar> createState() => _RecipeSearchBarState();
}

class _RecipeSearchBarState extends State<RecipeSearchBar> {
  late TextEditingController _controller;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _controller.text.trim();
    setState(() {
      _isSearching = true;
    });
    widget.onSearch(query);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
      }
    });
  }

  void _clearSearch() {
    _controller.clear();
    widget.onSearch('');
    setState(() {
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Theme.of(
        context,
      ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
      ),
    ),
    child: TextField(
      controller: _controller,
      onSubmitted: (_) => _performSearch(),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText:
            '${AppLocalizations.of(context)?.search ?? 'Search'} ${AppLocalizations.of(context)?.recipes.toLowerCase() ?? 'recipes'} ${AppLocalizations.of(context)?.search ?? 'by name or ingredient'}...',
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        prefixIcon: _isSearching
            ? Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              )
            : Icon(
                Icons.search_rounded,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                onPressed: _clearSearch,
                icon: Icon(
                  Icons.clear_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              )
            : IconButton(
                onPressed: _performSearch,
                icon: Icon(
                  Icons.restaurant_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
      ),
      onChanged: (value) {
        setState(() {});
      },
    ),
  );
}
