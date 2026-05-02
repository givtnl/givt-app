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

## Registration mandate flow (EU / UK, main app)

- **Intro**: [`MandateExplanationPage`](lib/features/registration/pages/mandate_explanation_page.dart) — SEPA vs UK Direct Debit intro; continues to sign step.
- **Confirm & sign**: [`SignMandatePage`](lib/features/registration/pages/sign_mandate_page.dart) — single screen; rows and footer depend on `Country.unitedKingdomCodes()`. Reuses account **change** bottom sheets from [`personal_info_edit_sheets.dart`](lib/features/account_details/personal_info_edit_sheets.dart). Widget pieces live under [`lib/features/registration/widgets/`](lib/features/registration/widgets/) (`SignMandateDetailRow`, `SignMandateUkDdFooter`).
- **Errors**: mandate failures can route to [`FlowGenericErrorPage`](lib/shared/pages/flow_generic_error_page.dart) via [`Pages.flowGenericError`](lib/app/routes/pages.dart).

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
- **`FunScaffold` padding**: `FunScaffold` (`lib/shared/widgets/fun_scaffold.dart`) wraps `body` in `SafeArea` with default **`minimumPadding` LTRB `24 / 24 / 24 / 40`**. Do not duplicate that inset with an outer `Padding` or scroll-view padding on `body`; only add spacing between inner widgets or override `minimumPadding` / `withSafeArea` when you need full-bleed content. See class dartdoc on `FunScaffold` for detail.
- **Refactoring**: When touching existing UI, consider refactoring to FUN components. See `.cursor/rules/fun-design-system.mdc` for more detail.

## Support requests (in-app)

- **Do not** open the device mail app for “contact support” flows in the main app.
- Use **`InfraCubit.contactSupportSafely()`** with `message`, `appLanguage`, `email`, `guid` (from `AuthCubit.state.user`). Same pattern as the About Givt / Contact bottom sheet.
- Include any relevant context in the message (e.g. “Requested new email address: …” when the user tried to change email).

## Shared flow error screen (reusable)

- **Purpose**: Full-screen error with **Try again**, **Contact support** (opens the localized About Givt / contact bottom sheet), and **Go to home**.
- **UI**: [`FlowGenericErrorPage`](lib/shared/pages/flow_generic_error_page.dart); pass [`FlowGenericErrorExtra`](lib/shared/pages/flow_generic_error_extra.dart) as `GoRouterState.extra` (includes **`screenTitle`** for the app bar, plus **`title` / `message`** for the body, **`errorReason`** for support metadata, and **`onTryAgain` / `onGoHome`** callbacks — often capture `RegistrationBloc` or similar before `pushNamed` so callbacks work without the bloc in the subtree).
- **Route**: [`Pages.flowGenericError`](lib/app/routes/pages.dart) (registered under the home shell in [`app_router.dart`](lib/app/routes/app_router.dart)).
- **Support metadata**: When opening contact from this screen, pass `AboutGivtBottomSheet.show` `metadata` with at least **`Flow`** (e.g. `Onboarding`) and **`Error reason`** (a short technical code such as `failure`, `conflict`). These are appended to the support email body by [`InfraCubit`](lib/shared/bloc/infra/infra_cubit.dart).

## Backend / API

- When the backend returns **distinct error cases** (e.g. invalid email vs email already in use), prefer separate UI states and copy for each case instead of one generic message.
- Email checks: `checkTld(email)` → invalid format/TLD; `checkEmail(email)` returns `'true'` / `'temp'` → email already in use.

## Text & Localization

- **Phrasing & terminology**: All user-facing text must follow the guidelines in `docs/language.md`, which defines the correct terminology (e.g., "Give" vs "Donate"), tone of voice, capitalization rules, and language-specific phrasing conventions across all supported languages (English, Dutch, German, Spanish).
- **Adding new text**: When adding new text to the UI:
  1. First define the text entry in `lib/l10n/arb/app_en.arb` (the English template).
  2. Follow the phrasing rules from `docs/language.md` for consistency.
  3. Add translations for all supported languages in the corresponding ARB files (`app_nl.arb`, `app_de.arb`, `app_es.arb`, etc.).
  4. Run `flutter gen-l10n` to regenerate the localization code.
- **Language notes**: Avoid hardcoding text strings in Dart; always use the localized strings generated from ARB files. This ensures consistency and makes maintenance easier.

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
- **Language & phrasing**: `docs/language.md` for terminology, tone of voice, and translation guidelines.

## Testing and commands

- Run tests: `flutter test --coverage --test-randomize-ordering-seed random`
- Makefile: see project root for common commands (README and Makefile).
