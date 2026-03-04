# New project setup

## Quick start

```bash
# 1. Copy flutter_starter to your new project directory
cp -r flutter_starter/ myapp/ && cd myapp/

# 2. Create the Flutter project (generates pubspec.yaml, android/, ios/)
flutter create . --org com.example.yourcompany --project-name myapp --platforms=android,ios

# 3. Run the setup script
bash setup.sh myapp

# 4. Run
flutter run
```

`setup.sh` handles the rest automatically:
- Replaces `flutter_starter` → `myapp` in all Dart files
- Patches `pubspec.yaml` with required dependencies
- Runs `flutter pub get` in root and all packages

---

## After setup — checklist

- [ ] `lib/app/router/app_routes.dart` — add your route constants
- [ ] `lib/app/material_context.dart` — replace `home: const Placeholder()` with your home screen
- [ ] `lib/bootstrap/dependency_container.dart` — add your feature dependencies
- [ ] `lib/bootstrap/composition.dart` — wire dependencies in `createDependenciesContainer()`
- [ ] `android/app/build.gradle.kts` — verify `namespace` / `applicationId` are not duplicated
- [ ] `packages/features/` — add your feature packages here
- [ ] `packages/shared/` — add domain models and repository interfaces

---

## Manual setup (if needed)

If `setup.sh` doesn't work for your environment, do it manually:

### 1. Replace package name

```bash
find lib packages -name "*.dart" -exec sed -i '' 's/flutter_starter/your_app_name/g' {} \;
```

### 2. Replace pubspec.yaml contents

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

### 3. Run pub get

```bash
flutter pub get
cd packages/app_settings && flutter pub get && cd ../..
cd packages/preferences_storage && flutter pub get && cd ../..
cd packages/component_library && flutter pub get && cd ../..
cd packages/monitoring && flutter pub get && cd ../..
```
