# New project setup

## 1. Create the project

```bash
flutter create . --org com.example.yourcompany --project-name your_app_name --platforms=android,ios
```

## 2. Replace lib/ and packages/ with the template

```bash
rm -rf lib/ test/
cp -r path/to/flutter_starter/lib .
cp -r path/to/flutter_starter/packages .
cp -r path/to/flutter_starter/.docs .
```

Find-and-replace the package name in all Dart files:

```bash
find lib packages -name "*.dart" -exec sed -i '' 's/flutter_starter/your_app_name/g' {} \;
```

## 3. Update pubspec.yaml

Replace the generated `pubspec.yaml` contents with:

```yaml
name: your_app_name
description: "Your app description"
publish_to: none
version: 1.0.0+1

environment:
  sdk: ^3.11.0

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  monitoring:
    path: packages/monitoring
  component_library:
    path: packages/component_library
  app_settings:
    path: packages/app_settings
  preferences_storage:
    path: packages/preferences_storage
  shared:
    path: packages/shared

  cupertino_icons: ^1.0.8
  flutter_bloc: ^9.1.1
  package_info_plus: ^9.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0

flutter:
  uses-material-design: true
```

Then run:

```bash
flutter pub get
cd packages/app_settings && flutter pub get && cd ../..
cd packages/preferences_storage && flutter pub get && cd ../..
cd packages/component_library && flutter pub get && cd ../..
cd packages/monitoring && flutter pub get && cd ../..
```

## 4. Fix Android namespace

In `android/app/build.gradle.kts`, verify that `namespace` and `applicationId` are not duplicated:

```kotlin
namespace = "com.example.yourcompany.your_app_name"  // ✅ not duplicated
applicationId = "com.example.yourcompany.your_app_name"
```

## 5. Checklist

- [ ] `lib/app/router/app_routes.dart` — add your route constants
- [ ] `lib/app/material_context.dart` — replace `home: const Placeholder()` with your home screen
- [ ] `lib/bootstrap/dependency_container.dart` — add your feature dependencies
- [ ] `lib/bootstrap/composition.dart` — wire your dependencies in `createDependenciesContainer()`
- [ ] `packages/features/` — add your feature packages here
- [ ] `packages/shared/` — add domain models, repository interfaces
