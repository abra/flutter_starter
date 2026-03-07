// Widget tree root: assembles the top-level widget hierarchy.
//
// Kept separate from starter.dart so that the bootstrap layer has no
// knowledge of widgets, and the widget layer has no knowledge of
// initialization logic.

import 'package:flutter/widgets.dart';
import 'package:flutter_starter/app/app_settings_scope.dart';
import 'package:flutter_starter/app/composition.dart';
import 'package:flutter_starter/app/dependency_scope.dart';
import 'package:flutter_starter/app/material_context.dart';

class RootContext extends StatelessWidget {
  const RootContext({required this.compositionResult, super.key});

  final CompositionResult compositionResult;

  @override
  Widget build(BuildContext context) {
    return DependenciesScope(
      dependencies: compositionResult.dependencies,
      child: AppSettingsScope(
        service: compositionResult.dependencies.appSettingsService,
        child: const MaterialContext(),
      ),
    );
  }
}
