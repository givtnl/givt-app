This repository’s full coding standards, design system rules, analytics conventions, and state management patterns are documented in `AGENTS.md` at the project root.

GitHub Copilot and similar tools should:

- **Read and respect `AGENTS.md`** before suggesting or generating code.
- **Prefer the guidance in `AGENTS.md`** over generic best practices when there is any conflict.

## Analytics (PostHog)
- Always include analytics events for user interactions using the established patterns.
- Use the `AnalyticsEvent` class to create analytics events with `AnalyticsEventName` enum values.
- All interactive components (particularly buttons) should include an `analyticsEvent` parameter.
- For FUN components like `FunButton`, the `analyticsEvent` parameter is required.
- Use only predefined event names from the `AnalyticsEventName` enum - never create custom event strings.
- When adding new event types, add them to the `AnalyticsEventName` enum, not as inline strings.
- Follow the naming pattern of existing events in the enum (e.g., `componentNameActionVerb`).
- For event parameters, use established key names when applicable (see constants in `AnalyticsHelper`).
- Never log sensitive user data or personally identifiable information.
