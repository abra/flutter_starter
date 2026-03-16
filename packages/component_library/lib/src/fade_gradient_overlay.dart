import 'package:flutter/material.dart';

/// Gradient fade pinned to the bottom of a [Stack].
///
/// Fades from transparent to scaffold background. Wraps itself in
/// [Positioned] + [IgnorePointer] so it sits above scrollable content
/// without blocking taps.
///
/// ```dart
/// Stack(
///   children: [
///     // scrollable content...
///     FadeGradientOverlay(height: 80),
///     // toolbar...
///   ],
/// )
/// ```
class FadeGradientOverlay extends StatelessWidget {
  const FadeGradientOverlay({required this.height, super.key});

  final double height;

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).scaffoldBackgroundColor;
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: height,
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [bg.withValues(alpha: 0), bg],
            ),
          ),
        ),
      ),
    );
  }
}
