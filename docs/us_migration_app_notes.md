# US adult app (EU shell) — migration notes

## App behaviour (post-change)

- US and EU users share the same navigation shell (`Pages.home`, EU registration, account screens).
- US API base URL is still selected from the user’s country (see `RequestHelper` / `EmailSignupCubit`).
- US payments use **Stripe** during registration (`PersonalInfoPage` → `CreditCardDetails`) and from **Personal info edit** (card row when `Country.isCreditCard`).
- US donations in the unified give flow open **`confirm-G4F.html`** from `GivingPage` when `Country.isCreditCard` is true (same in-app browser as EU, but G4F confirm page + `shouldShowCreditCard` in the web payload). EU/UK use `confirm.html`.
- **Backend:** Unified flow calls `submitGivts` first and passes `transactionIds` in the confirm `msg` payload. Legacy G4F parent flow used `createTransaction` without `transactionIds`. Confirm with backend that `confirm-G4F.html` accepts the unified payload before release.
- Givt4Kids routes are no longer registered (`FamilyAppRoutes.routes` is empty). Legacy deep links that pointed at family route names fall back to **home** (see `NotificationService`).

## Legacy US / G4K users

Coordinate with backend and support for:

1. **Incomplete family registration** (e.g. only one profile, or “add members” never finished): the app no longer routes to add-member flows; users should be guided to complete **adult** registration (personal info + Stripe) or be migrated server-side.
2. **Push / email links** that still use old family route names: invalid names now redirect to **home**; update campaigns to use `Pages.*` route names where possible.
3. **Data cleanup**: profiles, missions, and wallet state that existed only for G4K may need server-side migration or read-only handling so APIs do not error for migrated accounts.
