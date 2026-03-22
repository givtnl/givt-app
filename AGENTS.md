# Givt App – AI Agent Guide

This file helps AI agents (and developers) work effectively in this codebase.

## Project overview

- **Stack**: Flutter/Dart app (iOS, Android, Web, Windows).
- **Flavors**: `development` and `production`; run via `flutter run --flavor development --target lib/main_development.dart` (see README).
- **L10n**: ARB files in `lib/l10n/arb/`; run `flutter gen-l10n` after adding or changing keys.

## Flutter baseline best practices (adapted)

These are aligned with Flutter's official AI rules and should be treated as
baseline behavior in this repository:

- **Code quality first**: Keep code clear, simple, and maintainable; avoid
  clever patterns when a straightforward one exists.
- **Null safety and async correctness**: Prefer sound null-safe code, avoid
  unnecessary `!`, and use `async`/`await` with explicit error handling.
- **UI composition**: Favor small, composable widgets over large build methods;
  keep expensive work out of `build()`.
- **Performance defaults**: Use `const` constructors where possible and builder
  patterns (for long lists/grids) for lazy rendering.
- **Architecture**: Keep separation of concerns (presentation/domain/data/core);
  use repositories and constructor injection for dependencies.
- **State management**: Prefer existing project patterns (CommonCubit) and keep
  one-off effects in custom states/events.
- **Tests**: Add or update tests for behavior changes where practical; prefer
  deterministic tests with clear Arrange-Act-Assert structure.
- **Tooling after codegen-sensitive changes**: If l10n/json/codegen inputs are
  changed, run the corresponding generation step (for example `flutter gen-l10n`
  or `dart run build_runner build --delete-conflicting-outputs`).

Project-specific rules in `.cursor/rules/` still take precedence where they are
stricter (FUN design system, analytics requirements, versioning policy, etc.).

## EU vs US / feature locations

The app has **two main variants**; many features exist in both with different implementations:

| Area | EU (default) | US (family) |
|------|----------------|-------------|
| Personal info / account | `lib/features/account_details/` | `lib/features/family/features/account/` |
| Auth / login | `lib/features/auth/` | `lib/features/family/features/auth/` |
| Registration | `lib/features/registration/` | `lib/features/family/features/registration/` |

When a task mentions “EU” or “US” (or “family”), work in the corresponding feature folder. Do not assume one implementation applies to both.

## Design system (FUN)

- **Use FUN for UI**: Use the FUN design system for all new and refactored UI; keep components consistent.
- **Component prefix**: All FUN components use the `Fun` prefix (e.g. `FunButton`, `FunPrimaryTabs`, `FunBottomSheet`).
- **Imports**: Import from `package:givt_app/features/family/shared/design/components/components.dart` (and `fun_icon.dart` for `FunIcon` when needed).
- **Component categories**:
  - Actions: `FunButton`, `FunTile`
  - Content: `FunCard`
  - Navigation: `FunTopAppBar`, `FunPrimaryTabs`, `FunNavigationBar`
  - Overlays: `FunBottomSheet`, `FunModal`
  - Inputs: `FunCounter`
- **Typography**: Use specialized text components like `TitleMediumText`, `BodyMediumText`, etc.
- **Theming**: Use the FUN color palette (`FunTheme.of(context)` / `FamilyAppTheme`) and ensure responsive design across screen sizes.
- **Success confirmation**: Use **`FunIcon.checkmark()`** as the main content of a modal or bottom sheet (big green circle). Use a single “Done” button or **`FunModal` with `autoClose`** for brief confirmations (e.g. support request sent). Do not use a checkmark on the button for “confirm” actions; the icon in the modal is the confirmation.
- **Refactoring**: When touching existing UI, consider refactoring to FUN components. See `.cursor/rules/fun-design-system.mdc` for more detail.

## Support requests (in-app)

- **Do not** open the device mail app for “contact support” flows in the main app.
- Use **`InfraCubit.contactSupportSafely()`** with `message`, `appLanguage`, `email`, `guid` (from `AuthCubit.state.user`). Same pattern as the About Givt / Contact bottom sheet.
- Include any relevant context in the message (e.g. “Requested new email address: …” when the user tried to change email).

## Backend / API

- When the backend returns **distinct error cases** (e.g. invalid email vs email already in use), prefer separate UI states and copy for each case instead of one generic message.
- Email checks: `checkTld(email)` → invalid format/TLD; `checkEmail(email)` returns `'true'` / `'temp'` → email already in use.

## State and rules

- **Bloc/Cubit (CommonCubit pattern)**:
  - Extend `CommonCubit<UIModel, CustomState>` where `UIModel` is the main UI state model and `CustomState` is for custom events/actions.
  - Use `BaseState` for the initial state: `super(const BaseState.loading())`.
  - Inject repositories via the constructor; store them as `final` private fields with underscore prefixes and group related repositories together.
  - Keep complex state in private fields; implement `_emitData()` to update UI state and `_createUIModel()` to construct the UI model.
  - Use `emitData()` for regular state updates and `emitCustom()` for one-off actions/events.
  - Set up repository streams in `init()` and use `listen()` for reactive updates.
  - Keep each cubit focused on a single feature; use clear method names, proper cleanup, and separate UI-model creation from business logic.
  - See `.cursor/rules/common-cubit-pattern.mdc` for full details.
- **Analytics**:
  - Use `AnalyticsEvent` with `AnalyticsEventName` enum values (PostHog source of truth).
  - Pass `analyticsEvent` into interactive components (e.g. `FunButton`, tiles, summary rows); do not manually call `AnalyticsHelper.logEvent` when the component already supports analytics.
  - Only use predefined event names in `AnalyticsEventName`; add new event types to the enum rather than inline strings, following the `componentNameActionVerb` naming style.
  - Use established parameter keys from `AnalyticsHelper`; never log sensitive or personally identifiable data.
  - See `.cursor/rules/analytics.mdc` for detailed rules.

## Rules overview

- **Rule location**: Detailed, always-on rules for this project live in `.cursor/rules/`.
- **Key rules to know**:
  - `.cursor/rules/fun-design-system.mdc`: FUN design system components, theming, and confirmation patterns.
  - `.cursor/rules/analytics.mdc`: Analytics event usage, naming, and integration with FUN components.
  - `.cursor/rules/versioning.mdc`: Version bump policy for the Givt app (ensure `develop` has a higher version than `main`, and choose patch vs minor appropriately).
  - `.cursor/rules/flutter-core-best-practices.mdc`: Adapted Flutter baseline guidance for maintainability, async safety, architecture, and testing.

## Where to look

- **Auth / current user**: `AuthCubit` (EU), `FamilyAuthRepository` / family auth (US).
- **Support / infra**: `InfraCubit`, `contactSupportSafely`; used from `lib/shared/bloc/infra/`.
- **L10n**: `lib/l10n/arb/app_en.arb` (template), then regenerate with `flutter gen-l10n`.

## Testing and commands

- Run tests: `flutter test --coverage --test-randomize-ordering-seed random`
- Makefile: see project root for common commands (README and Makefile).
