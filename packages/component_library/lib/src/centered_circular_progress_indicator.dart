import 'package:flutter/material.dart';

/// [CircularProgressIndicator] wrapped in [Center].
class CenteredCircularProgressIndicator extends StatelessWidget {
  const CenteredCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}
