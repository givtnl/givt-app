# Givt App – AI Agent Guide

This file helps AI agents (and developers) work effectively in this codebase.

## Project overview

- **Stack**: Flutter/Dart app (iOS, Android, Web, Windows).
- **Flavors**: `development` and `production`; run via `flutter run --flavor development --target lib/main_development.dart` (see README).
- **L10n**: ARB files in `lib/l10n/arb/`; run `flutter gen-l10n` after adding or changing keys.

## EU vs US / feature locations

The app has **two main variants**; many features exist in both with different implementations:

| Area | EU (default) | US (family) |
|------|----------------|-------------|
| Personal info / account | `lib/features/account_details/` | `lib/features/family/features/account/` |
| Auth / login | `lib/features/auth/` | `lib/features/family/features/auth/` |
| Registration | `lib/features/registration/` | `lib/features/family/features/registration/` |

When a task mentions “EU” or “US” (or “family”), work in the corresponding feature folder. Do not assume one implementation applies to both.

## Design system (FUN)

- **Components**: Use FUN design system; prefix `Fun` (e.g. `FunButton`, `FunModal`, `FunBottomSheet`).
- **Import**: `package:givt_app/features/family/shared/design/components/components.dart` (and `fun_icon.dart` for `FunIcon` when needed).
- **Success confirmation**: Use **`FunIcon.checkmark()`** as the main content of a modal or bottom sheet (big green circle). Use a single “Done” button or **`FunModal` with `autoClose`** for brief confirmations (e.g. support request sent). Do not use a checkmark on the button for “confirm” actions; the icon in the modal is the confirmation.
- **Overlays**: Prefer `FunModal` for dialogs and `FunBottomSheet` for sheets. See `.cursor/rules/fun-design-system.mdc` for theming and typography.

## Support requests (in-app)

- **Do not** open the device mail app for “contact support” flows in the main app.
- Use **`InfraCubit.contactSupportSafely()`** with `message`, `appLanguage`, `email`, `guid` (from `AuthCubit.state.user`). Same pattern as the About Givt / Contact bottom sheet.
- Include any relevant context in the message (e.g. “Requested new email address: …” when the user tried to change email).

## Backend / API

- When the backend returns **distinct error cases** (e.g. invalid email vs email already in use), prefer separate UI states and copy for each case instead of one generic message.
- Email checks: `checkTld(email)` → invalid format/TLD; `checkEmail(email)` returns `'true'` / `'temp'` → email already in use.

## State and rules

- **Bloc/Cubit**: See `.cursor/rules/common-cubit-pattern.mdc` for repositories, events, and UI wiring.
- **Analytics**: See `.cursor/rules/analytics.mdc`; use `AnalyticsEvent` on interactive components; avoid manual `logEvent` when the component already has `analyticsEvent`.

## Where to look

- **Auth / current user**: `AuthCubit` (EU), `FamilyAuthRepository` / family auth (US).
- **Support / infra**: `InfraCubit`, `contactSupportSafely`; used from `lib/shared/bloc/infra/`.
- **L10n**: `lib/l10n/arb/app_en.arb` (template), then regenerate with `flutter gen-l10n`.

## Testing and commands

- Run tests: `flutter test --coverage --test-randomize-ordering-seed random`
- Makefile: see project root for common commands (README and Makefile).
