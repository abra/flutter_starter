import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_starter/app/dependency_container.dart';

abstract final class AppRoutes {
  static const home = '/';
}

GoRouter buildRouter({required DependenciesContainer dependencies}) {
  return GoRouter(
    debugLogDiagnostics: dependencies.config.isDev,
    initialLocation: AppRoutes.home,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) =>
            const Placeholder(), // TODO: Replace with your home screen
      ),
    ],
  );
}
