# Follow-up Linear issue (draft) — Plan renewal / end date API

**Parent:** [ENG-597](https://linear.app/givt/issue/ENG-597) — Implement new Pricing Page layout  
**Design:** [COR-2444 — New pricing plan layout and manage modal (Figma)](https://www.figma.com/design/dBOnDJTvfqLwJsK5yvXukj/Givt4Kids---Ongoing-Design?node-id=49529-585)  
**Labels:** `Givt Dashboard`, `Backend` (or `API`), `Blocked` / `Dependency`  
**Team:** Same as ENG-597 (Givt4Kids dashboard)

---

## Title

**Expose plan renewal semantics for Plans & Billing current-plan card (Renews vs Ends)**

---

## Problem

ENG-597 requires the current-plan card renewal row to show:

- **"Renews [date]"** when the plan **auto-renews**
- **"Ends [date]"** when the plan **does not** auto-renew

There is **no backend field / contract yet** that reliably distinguishes auto-renew vs end-of-term for the dashboard. Frontend cannot complete this acceptance criterion without API support.

### Interim behaviour (documented on ENG-597)

Until this issue is done, product agreed to show **"Ends [date]"** when a **new contract is scheduled** (scheduled plan change). That is a **workaround**, not the final Renews/Ends rules above.

---

## Proposed scope (backend + contract)

### API / model

Extend the subscription/contract payload used by **Plans & Billing** (organisation or family account context — align with existing billing endpoints) with explicit renewal fields, for example:

| Field | Type | Purpose |
|-------|------|---------|
| `renewalLabel` | enum: `renews` \| `ends` | Which copy prefix the UI should use |
| `renewalDate` | ISO date (org timezone) | Date shown after "Renews" / "Ends" |
| `autoRenews` | boolean | Source of truth for `renewalLabel` when no scheduled change |
| `scheduledContractId` | string? (optional) | Present when a future contract is scheduled |
| `scheduledContractStartDate` | ISO date? | Optional; supports interim "Ends" when change is scheduled |

**Rules (target behaviour):**

1. If the active plan **auto-renews** at period end → `renewalLabel = renews`, `renewalDate` = next renewal date.
2. If the active plan **does not** auto-renew → `renewalLabel = ends`, `renewalDate` = contract end date.
3. If a **scheduled contract/plan change** exists, document whether the row should still use `ends` (interim) or switch to `renews` with the new contract’s date — **confirm with product** and encode in API docs.

### Non-goals

- Manage modal / contracts list UI (separate ENG-597 item / modal work)
- Available-plans tier filtering (frontend-only on ENG-597)

---

## Frontend follow-up (after API ships)

In the Givt4Kids dashboard Plans & Billing page:

- Map `renewalLabel` + `renewalDate` to localized strings: `Renews {date}` / `Ends {date}`.
- Remove interim-only logic that infers "Ends" solely from "scheduled contract" once API provides `renewalLabel`.
- Add tests for: auto-renew active, non-renewing active, scheduled change (per final product rules).

---

## Acceptance criteria

- [ ] Billing/subscription read API returns `renewalLabel` and `renewalDate` for the active plan.
- [ ] `autoRenews` (or equivalent) is documented and matches production billing behaviour.
- [ ] Scheduled plan change is represented without ambiguous client-side guessing.
- [ ] OpenAPI / internal API docs updated; dashboard team notified.
- [ ] ENG-597 renewal-row checkbox can be marked done after frontend wires to new fields.

---

## Links

- ENG-597 — unchecked AC: *Renewal row shows "Renews [date]" when the plan auto-renews, "Ends [date]" when it doesn't*
- Figma current-plan details row label: **Renews** ([node `50804:37112`](https://www.figma.com/design/dBOnDJTvfqLwJsK5yvXukj/Givt4Kids---Ongoing-Design?node-id=50804-37112))

---

## Suggested Linear metadata

- **Priority:** Medium (blocks ENG-597 AC, not whole page layout)
- **Relation:** Blocks ENG-597 (renewal row) or add as sub-issue of ENG-597
