# Project coding standards

## Design System (FUN)
- Use the FUN design system for all (new or when refactoring) UI components.
- Ensure consistency across all components.
- Always use the appropriate FUN component instead of creating custom UI elements.
- All FUN components use the prefix 'Fun' (e.g., `FunButton`, `FunPrimaryTabs`, `FunBottomSheet`).
- Import components from `package:givt_app/features/family/shared/design/components/components.dart`.
- Follow the component organization convention:
  - Actions: `FunButton`, `FunTile`
  - Content: `FunCard`
  - Navigation: `FunTopAppBar`, `FunPrimaryTabs`, `FunNavigationBar`
  - Overlays: `FunBottomSheet`
  - Inputs: `FunCounter`
- For typography, use the specialized text components (`TitleMediumText`, `BodyMediumText`, etc.).
- Use the FUN color palette and theming constants from `FamilyAppTheme`.
- Test components on various screen sizes to ensure responsiveness.
- When modifying existing UI, consider refactoring to use FUN design system components.
- For more detailed guidelines, see: [FUN Design System](../docs/design-system/fun.md)

## Analytics (Amplitude)
- Always include analytics events for user interactions using the established patterns.
- Use the `AnalyticsEvent` class to create analytics events with `AmplitudeEvents` enum values.
- All interactive components (particularly buttons) should include an `analyticsEvent` parameter.
- For FUN components like `FunButton`, the `analyticsEvent` parameter is required.
- Use only predefined event names from the `AmplitudeEvents` enum - never create custom event strings.
- When adding new event types, add them to the `AmplitudeEvents` enum, not as inline strings.
- Follow the naming pattern of existing events in the enum (e.g., `componentNameActionVerb`).
- For event parameters, use established key names when applicable (see constants in `AnalyticsHelper`).
- Never log sensitive user data or personally identifiable information.
