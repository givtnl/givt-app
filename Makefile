.PHONY: lint
lint:
	dart format lib test
	flutter analyze

.PHONY: run_dev
run_dev:
	flutter run --flavor development --target lib/main_development.dart

.PHONY: run_prod
run_prod:
	flutter run --flavor production --target lib/main_production.dart

.PHONY: run_staging
run_staging:
	flutter run --flavor staging --target lib/main_staging.dart

.PHONY: get
get:
	flutter pub get

.PHONY: test
test:
	flutter test --coverage --test-randomize-ordering-seed random

.PHONY: melos
melos:
	flutter pub global run melos exec -c 6 flutter pub get


