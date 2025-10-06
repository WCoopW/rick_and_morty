import 'package:flutter/material.dart';
import 'package:rick_and_morty/src/feature/initialization/model/app_theme.dart';

/// {@template status_filter_chips}
/// StatusFilterChips widget for filtering characters by status.
/// {@endtemplate}
class StatusFilterChips extends StatelessWidget {
  /// {@macro status_filter_chips}
  const StatusFilterChips({
    required this.selectedStatus,
    required this.onStatusChanged,
    super.key,
  });

  final String? selectedStatus;
  final ValueChanged<String?> onStatusChanged;

  static const List<String> _statuses = ['Alive', 'Dead', 'Unknown'];
  static const double _chipSpacing = 8.0;
  static const double _paddingHorizontal = 16.0;
  static const double _paddingVertical = 8.0;
  static const double _selectedAlpha = 0.3;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _paddingHorizontal,
        vertical: _paddingVertical,
      ),
      child: Wrap(
        spacing: _chipSpacing,
        children: [
          // All characters chip
          FilterChip(
            label: const Text('All'),
            selected: selectedStatus == null,
            onSelected: (selected) {
              onStatusChanged(null);
            },
            selectedColor: AppTheme.lightGreen.withValues(alpha: _selectedAlpha),
            checkmarkColor: AppTheme.lightGreen,
            labelStyle: TextStyle(
              color: selectedStatus == null ? AppTheme.lightGreen : null,
              fontWeight: selectedStatus == null ? FontWeight.bold : null,
            ),
          ),
          // Status chips
          ..._statuses.map((status) => FilterChip(
                label: Text(status),
                selected: selectedStatus == status,
                onSelected: (selected) {
                  onStatusChanged(selected ? status : null);
                },
                selectedColor: _getStatusColor(status).withValues(alpha: _selectedAlpha),
                checkmarkColor: _getStatusColor(status),
                labelStyle: TextStyle(
                  color: selectedStatus == status ? _getStatusColor(status) : null,
                  fontWeight: selectedStatus == status ? FontWeight.bold : null,
                ),
              )),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'alive':
        return Colors.green;
      case 'dead':
        return Colors.red;
      case 'unknown':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
