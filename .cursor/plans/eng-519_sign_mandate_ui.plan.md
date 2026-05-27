# ENG-519 — Sign mandate (single plan)

**Status:** Implemented in-repo (UK + EU unified confirm screen, shared error page, BACS intro merged into mandate explanation).

**Design reference:** [ENG-519](https://linear.app/givt/issue/ENG-519) — Figma “Givt4Kids Ongoing Design”.

**Key files**

| Piece | Location |
|-------|----------|
| Unified confirm | [`lib/features/registration/pages/sign_mandate_page.dart`](lib/features/registration/pages/sign_mandate_page.dart) |
| Intro (SEPA + BACS) | [`lib/features/registration/pages/mandate_explanation_page.dart`](lib/features/registration/pages/mandate_explanation_page.dart) |
| Personal info sheets | [`lib/features/account_details/personal_info_edit_sheets.dart`](lib/features/account_details/personal_info_edit_sheets.dart) + [`personal_info_edit_feedback_listener.dart`](lib/features/account_details/widgets/personal_info_edit_feedback_listener.dart) |
| Shared error | [`lib/shared/pages/flow_generic_error_page.dart`](lib/shared/pages/flow_generic_error_page.dart), [`flow_generic_error_extra.dart`](lib/shared/pages/flow_generic_error_extra.dart) |
| Route | `Pages.flowGenericError` in [`app_router.dart`](lib/app/routes/app_router.dart) |

**Principles:** One implementation with country-based bank rows and l10n; no duplicate sign mandate pages; support metadata `Flow` / `Error reason` for contact.
