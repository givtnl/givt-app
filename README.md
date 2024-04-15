# Givt App
<a href="https://play.google.com/store/apps/details?id=net.givtapp.droid2&hl=us" target="_blank"><img alt="Get it on Google Play" src="https://imgur.com/YQzmZi9.png" width="153" height="46"></a> <a href="https://mobileapp.bitwarden.com/HDicnzz.png" width="154" height="46"></a> <a href="https://apps.apple.com/nl/app/givt/id1181435988" target="_blank"><img src="https://imgur.com/GdGqPMY.png" width="135" height="40"></a>


[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]

---
## Prerequisites

To get started with this project please install [rbenv][rbenv_repo] to ensure the correct podfiles are generated.

---
## Getting Started 🚀

This project contains 3 flavors:

- development
- staging
- production

## Dependencies

The project has custom packages and by getting [melos](https://melos.invertase.dev/~melos-latest/getting-started) and running ```melos install``` will install all dependencies for the packages

To run the desired flavor either use the launch configuration in VSCode/Android Studio or use the following commands:

```sh
# Development
$ flutter run --flavor development --target lib/main_development.dart

# Staging
$ flutter run --flavor staging --target lib/main_staging.dart

# Production
$ flutter run --flavor production --target lib/main_production.dart
```

_\*Givt App works on iOS, Android, Web, and Windows._

---

## Running Tests 🧪

To run all unit and widget tests use the following command:

```sh
$ flutter test --coverage --test-randomize-ordering-seed random
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
$ open coverage/index.html
```

---

### Makefile support

Alternatively, we have a `Makefile` to help with these commands, as well as other frequent commands:

```sh
# Run Development Flavor
make run_dev

# Run Staging Flavor
make run_staging

# Run Production Flavor
make run_prod

# Run Linter
make lint

# Gets Packages
make get

# Installs Custom Packages
make melos

# Runs All Tests
make test
```

## Working with Translations 🌐

This project relies on [flutter_localizations][flutter_localizations_link] and follows the [official internationalization guide for Flutter][internationalization_link].

### Adding Strings

1. To add a new string, open the `app_en.arb` file at `lib/l10n/arb/app_en.arb`.

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

2. Then add a new key/value and description

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    },
    "helloWorld": "Hello World",
    "@helloWorld": {
        "description": "Hello World Text"
    }
}
```

3. Use the new string

```dart
import 'package:givt_app/l10n/l10n.dart';

@override
Widget build(BuildContext context) {
  final l10n = context.l10n;
  return Text(l10n.helloWorld);
}
```

### Adding Supported Locales

Update the `CFBundleLocalizations` array in the `Info.plist` at `ios/Runner/Info.plist` to include the new locale.

```xml
    ...

    <key>CFBundleLocalizations</key>
	<array>
		<string>en</string>
		<string>es</string>
	</array>

    ...
```

### Adding Translations

1. For each supported locale, add a new ARB file in `lib/l10n/arb`.

```
├── l10n
│   ├── arb
│   │   ├── app_en.arb
│   │   └── app_es.arb
```

2. Add the translated strings to each `.arb` file:

[coverage_badge]: coverage_badge.svg
[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli
[rbenv_repo]: https://github.com/rbenv/rbenv#installation
