# New project setup

## 1. Create the project

```bash
flutter create . --org com.example.yourcompany --project-name your_app_name --platforms=android,ios
```

## 2. Replace lib/ with the template

```bash
rm -rf lib/ test/
cp -r path/to/flutter_starter/lib .
cp -r path/to/flutter_starter/packages .
```

Find-and-replace the package name in all dart files:

```bash
find lib -name "*.dart" -exec sed -i '' 's/flutter_starter/your_app_name/g' {} \;
```

## 3. Add dependencies to pubspec.yaml

```yaml
dependencies:
  flutter_bloc: ^9.1.1
  shared_preferences: ^2.5.4
  package_info_plus: ^9.0.0
```

Then run:

```bash
flutter pub get
```

## 4. Checklist

- [ ] `lib/app/routing.dart` — replace route constants with your routes
- [ ] `lib/app/material_context.dart` — replace `home: const Placeholder()` with your home screen
- [ ] `packages/features/` — add your feature packages here
- [ ] `lib/bootstrap/fakes.dart` — replace `Fake*` with real implementations as packages are added
