# Maestro E2E tests (Givt app)

Mobile end-to-end tests using [Maestro](https://docs.maestro.dev/). Flows hit the **development** backend (`dev-backend.givtapp.net` / `dev-backend.givt.app`) — no local API required.

For Maestro syntax, patterns, and CI setup, see `.agents/skills/maestro-mobile-testing/SKILL.md`.

## App target

All flows use the iOS test bundle:

```yaml
appId: net.givtapp.ios.test
```

Install the **development** flavor on a simulator or device before running tests (`flutter run --flavor development --target lib/main_development.dart` with dart-defines from `.vscode/launch.json`).

## Folder layout

```
test/Maestro/
├── EU/                          # Main Givt app (EU / UK)
│   ├── _shared/                 # Cross-feature subflows (re-auth, dismiss sheet)
│   ├── Account_Settings/        # Account settings feature (ENG-666)
│   ├── NL_*.yml                 # Netherlands registration / giving subflows
│   ├── UK_*.yml                 # UK subflows
│   ├── E2E_*_NewUser_*.yml      # Full-journey orchestrators (region root)
│   └── EU_*.yml                 # Region-wide utilities (delete account, cancel donation)
└── US/                          # Givt4Kids / family app
    ├── Manage_Family/             # Family account settings (legacy layout — align with EU when touched)
    └── …
```

### Regions

| Folder | App variant | Notes |
|--------|-------------|--------|
| `EU/` | Main Givt (NL, UK, …) | Account settings via home menu → Personal info |
| `US/` | Givt4Kids / family | Different navigation (e.g. Manage Family → parent profile) |

### When to use a subfolder vs region root

**Use a feature subfolder** (e.g. `Account_Settings/`) when you have:

- Several flows for the same screen or journey (roughly 4+ files)
- Feature-specific subflows (e.g. `NL_Opening.yml`)
- Feature-scoped E2E tests

**Keep at region root** when:

- The flow is a **top-level journey** stitching multiple features (`E2E_NL_NewUser_DoDonation.yml`)
- It is a **shared utility** used by many features (`EU_delete_account.yml`)
- You only have **1–2 files** for that area (e.g. registration/giving subflows today)

**Use `_shared/`** for subflows reused across features within a region (login re-auth, dismiss bottom sheet).

## File naming

PascalCase, matching existing files like `NL_CreateNewAccount.yml`:

| Pattern | Example | Purpose |
|---------|---------|---------|
| `{Country}_{Action}.yml` | `NL_ChangePassword.yml` | Single-country subflow or focused test |
| `E2E_{Country}_{Story}.yml` | `E2E_NL_Login.yml` | End-to-end test for one story |
| `EU_{Action}.yml` | `EU_delete_account.yml` | Region-wide, not country-specific |
| `UK_*` / `NL_*` | `NL_GiveViaList_Successful.yml` | Country-specific steps |

Each file should set a descriptive `name:` in the YAML header (shown in Maestro output).

## Subflows and paths

Reference subflows with **relative paths** from the calling file:

```yaml
# From Account_Settings/NL_MaxAmount.yml
- runFlow: NL_LoginWithAccount.yml          # same folder
- runFlow: ../_shared/Login_AuthNeeded.yml  # parent → _shared
- runFlow: ../NL_CreateNewAccount.yml      # parent → region root
```

Put **default `env` credentials** on login subflows (e.g. `NL_LoginWithAccount.yml`) so individual tests work when run standalone — not only from E2E parents.

## Selectors

**Prefer semantics IDs** (`id:` in Maestro) over visible text — the app is localized and label text can collide (e.g. "Password" on login vs change-password settings).

In Flutter, expose IDs via `Semantics(identifier: …)` or the `semanticsIdentifier` parameter on FUN components (`FunButton`, list items, etc.).

### Common semantics IDs (EU account settings)

| ID | Element |
|----|---------|
| `homeMenu` | Home drawer menu button |
| `homeQuestionMark` | Home FAQ question mark button |
| `menuPersonalInfo` | Drawer → Personal info |
| `accountSettingsScreen` | Account settings page |
| `accountSettingsRowChangePassword` | Change password row |
| `accountSettingsRowBiometric` | Face ID / Touch ID row |
| `accountSettingsRowMaxAmount` | Maximum amount row |
| `accountSettingsRowAmountPresets` | Amount presets row |
| `accountSettingsRowPlatformContribution` | Platform contribution row |
| `Email-Input`, `Email-Continue-Button` | Email signup / login |
| `Login-Bottomsheet-Password-Input`, `Login-Bottomsheet-Submit-Button` | Re-auth login sheet |
| `xmark` | Close bottom sheet |
| `backButton` | Back navigation |

Add new IDs when introducing testable UI; avoid relying on translated strings for critical steps.

## Re-authentication

Sensitive actions may show a login bottom sheet. Run re-auth **conditionally** — never tap `"Password"` blindly (that can hit the wrong row on settings):

```yaml
- runFlow:
    when:
      visible:
        id: "Login-Bottomsheet-Password-Input"
    file: ../_shared/Login_AuthNeeded.yml
```

Shared implementation: `EU/_shared/Login_AuthNeeded.yml`.

## Test accounts

| Account | Use |
|---------|-----|
| `donna+maestronl@givtapp.net` / `Test123` | NL login-based flows (default in `NL_LoginWithAccount.yml`) |

Registration E2E flows need a **fresh email** or account cleanup via `EU_delete_account.yml` — reusing an existing email fails at "Finish registration".

## Running tests

```bash
# All EU account settings tests
maestro test test/Maestro/EU/Account_Settings/

# Single flow
maestro test test/Maestro/EU/Account_Settings/E2E_NL_Login.yml

# Debug step-by-step
maestro test --debug test/Maestro/EU/Account_Settings/NL_ChangePassword.yml
```

Requires a booted iOS simulator (or device) with the test app installed.

## Checklist for new flows

1. Place the file in the correct region (`EU/` or `US/`) and feature folder if applicable.
2. Follow naming: `{Country}_{Action}.yml` or `E2E_{Country}_{Story}.yml`.
3. Use `id:` selectors; add `semanticsIdentifier` in Dart when missing.
4. Extract repeated steps into `_shared/` or feature subflows.
5. Use conditional re-auth for login bottom sheets.
6. Set `env` defaults on login subflows so tests run standalone.
7. Run locally before opening a PR.
