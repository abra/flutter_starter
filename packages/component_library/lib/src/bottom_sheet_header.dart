import 'package:flutter/material.dart';

/// Title + close button row for bottom sheets.
///
/// ```dart
/// BottomSheetHeader(
///   title: 'Settings',
///   onClose: () => Navigator.of(context).pop(),
/// )
/// ```
class BottomSheetHeader extends StatelessWidget {
  const BottomSheetHeader({
    required this.title,
    required this.onClose,
    super.key,
  });

  final String title;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: onClose,
        ),
      ],
    );
  }
}
