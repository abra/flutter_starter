import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_starter/app/dependency_container.dart';
import 'package:flutter_starter/app/router/app_routes.dart';

GoRouter buildRouter({required DependenciesContainer dependencies}) {
  return GoRouter(
    debugLogDiagnostics: true,
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
