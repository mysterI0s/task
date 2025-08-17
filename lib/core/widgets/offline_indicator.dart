import 'dart:async';

import 'package:flutter/material.dart';
import 'package:task/core/localization/app_localizations.dart';
import 'package:task/core/storage/cache_manager.dart';

class OfflineIndicator extends StatefulWidget {
  const OfflineIndicator({super.key});

  @override
  State<OfflineIndicator> createState() => _OfflineIndicatorState();
}

class _OfflineIndicatorState extends State<OfflineIndicator> {
  bool _isVisible = false;
  bool _isExpanded = false;
  Timer? _hideTimer;
  Timer? _expandTimer;
  Timer? _checkTimer;

  @override
  void initState() {
    super.initState();
    _checkAndShowIndicator();

    // Check every 5 minutes for cache status changes
    _checkTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      _checkAndShowIndicator();
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _expandTimer?.cancel();
    _checkTimer?.cancel();
    super.dispose();
  }

  void _checkAndShowIndicator() {
    final isCacheValid = CacheManager.isCacheValid();
    final cacheAge = CacheManager.getCacheAge();

    // Only show if cache is expired or very old (more than 30 minutes)
    // and we haven't already shown it recently
    if (!isCacheValid || (cacheAge != null && cacheAge.inMinutes > 30)) {
      if (!_isVisible) {
        setState(() {
          _isVisible = true;
          _isExpanded = false;
        });

        // Auto-hide after 3 minutes
        _hideTimer?.cancel();
        _hideTimer = Timer(const Duration(minutes: 3), () {
          if (mounted) {
            setState(() {
              _isVisible = false;
              _isExpanded = false;
            });
          }
        });

        // Auto-expand after 10 seconds to show more details
        _expandTimer?.cancel();
        _expandTimer = Timer(const Duration(seconds: 10), () {
          if (mounted && _isVisible) {
            setState(() {
              _isExpanded = true;
            });
          }
        });
      }
    } else {
      // If cache is valid and not too old, hide the indicator
      if (_isVisible) {
        setState(() {
          _isVisible = false;
          _isExpanded = false;
        });
        _hideTimer?.cancel();
        _expandTimer?.cancel();
      }
    }
  }

  void _dismissIndicator() {
    setState(() {
      _isVisible = false;
      _isExpanded = false;
    });
    _hideTimer?.cancel();
    _expandTimer?.cancel();
  }

  void _refreshIndicator() {
    _checkAndShowIndicator();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) {
      return const SizedBox.shrink();
    }

    final isCacheValid = CacheManager.isCacheValid();
    final cacheAge = CacheManager.getCacheAge();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _isExpanded ? 80 : 50,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isCacheValid
              ? Colors.orange.withValues(alpha: 0.1)
              : Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isCacheValid ? Colors.orange : Colors.red),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  isCacheValid ? Icons.warning_amber : Icons.cloud_off,
                  color: isCacheValid ? Colors.orange : Colors.red,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isCacheValid
                        ? AppLocalizations.of(context)?.offlineDataExpired ??
                              'Offline Data Expired'
                        : AppLocalizations.of(context)?.offlineDataAvailable ??
                              'Offline Data Available',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: isCacheValid ? Colors.orange : Colors.red,
                    ),
                  ),
                ),
                if (cacheAge != null)
                  Text(
                    '${cacheAge.inMinutes}m ${AppLocalizations.of(context)?.ago ?? 'ago'}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                IconButton(
                  onPressed: _refreshIndicator,
                  icon: const Icon(Icons.refresh, size: 18),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                  tooltip: 'Refresh status',
                ),
                IconButton(
                  onPressed: _dismissIndicator,
                  icon: const Icon(Icons.close, size: 18),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 24,
                    minHeight: 24,
                  ),
                  tooltip: 'Dismiss',
                ),
              ],
            ),
            if (_isExpanded) ...[
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)?.pullToRefreshToGetLatestData ??
                    'Pull to refresh to get latest data',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class OfflineStatusChip extends StatelessWidget {
  const OfflineStatusChip({super.key});

  @override
  Widget build(BuildContext context) {
    final isCacheValid = CacheManager.isCacheValid();
    final cacheAge = CacheManager.getCacheAge();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isCacheValid
            ? Colors.green.withValues(alpha: 0.2)
            : Colors.orange.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCacheValid ? Colors.green : Colors.orange,
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCacheValid ? Icons.cloud_done : Icons.cloud_off,
            color: isCacheValid ? Colors.green : Colors.orange,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            isCacheValid
                ? AppLocalizations.of(context)?.offline ?? 'Offline'
                : AppLocalizations.of(context)?.expired ?? 'Expired',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isCacheValid ? Colors.green : Colors.orange,
            ),
          ),
          if (cacheAge != null) ...[
            const SizedBox(width: 4),
            Text(
              '(${cacheAge.inMinutes}m)',
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
          ],
        ],
      ),
    );
  }
}
