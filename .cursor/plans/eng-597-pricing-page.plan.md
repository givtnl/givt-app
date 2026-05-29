# ENG-597 — Pricing page layout (Plans & Billing)

**Status:** Partial — layout/items marked done in Linear; **renewal row** and **available plans** AC still open on dashboard codebase (not in `givt-app`).

**Design:** [COR-2444 (Figma)](https://www.figma.com/design/dBOnDJTvfqLwJsK5yvXukj/Givt4Kids---Ongoing-Design?node-id=49529-585)

## Repo note

This issue is labeled **Givt Dashboard** (Angular/web). Implementation is **not** in `givtnl/givt-app` (Flutter). Use the Givt4Kids dashboard repository where Plans & Billing settings live.

## Remaining acceptance criteria (dashboard)

| Area | Item | Notes |
|------|------|--------|
| Current plan | Renews vs Ends row | **Blocked** — see follow-up draft [eng-597-follow-up-renewal-api.issue.md](./eng-597-follow-up-renewal-api.issue.md). Interim: show **Ends** when a new contract is scheduled. |
| Available plans | Current + higher tiers only | e.g. Free → Free, Basic, Plus |
| Available plans | Hide section on Plus (top tier) | Page: current plan → invoices |
| Available plans | Current plan: disabled "Current plan" button | |
| Available plans | Higher tiers: "Upgrade to [Plan]" | Opens plan-change flow |

## Completed (per Linear)

- Page order: current plan → available plans → invoices
- Subtitle removed; "Get in contact" unchanged
- Contracts section removed from page (moved to Manage modal)
- Dynamic feature tiles on current-plan card
- View invoices anchor scroll; Manage opens modal
