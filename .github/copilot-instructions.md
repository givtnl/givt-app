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

## State Management (CommonCubit)
- Extend `CommonCubit<UIModel, CustomState>` where:
  - `UIModel` is the main UI state model
  - `CustomState` is for custom events/actions
- Use `BaseState` for initial state: `super(const BaseState.loading())`
- Inject all required repositories through constructor
- Make repositories final private fields with underscore prefix
- Group related repositories together
- Use private fields for complex state objects
- Implement `_emitData()` method to update UI state
- Create a `_createUIModel()` method to construct the UI state
- Use `emitData()` for regular state updates
- Use `emitCustom()` for custom events/actions
- Set up repository streams in `init()` method
- Use `listen()` for reactive updates
- Keep cubit focused on a single feature
- Use clear, descriptive method names
- Implement proper cleanup in dispose if needed
- Handle loading and error states
- Use private methods for internal logic
- Keep UI model creation separate from business logic

Example:
```dart
class FeatureCubit extends CommonCubit<FeatureUIModel, FeatureCustom> {
  FeatureCubit(
    this._repository,
    this._otherRepository,
  ) : super(const BaseState.loading());

  final Repository _repository;
  final OtherRepository _otherRepository;

  Future<void> init() async {
    _repository.onDataChanged().listen(_onDataChanged);
    _emitData();
  }

  void _onDataChanged(Data data) {
    _emitData();
  }

  void _emitData() {
    emitData(_createUIModel());
  }

  FeatureUIModel _createUIModel() {
    return FeatureUIModel(
      // ... model properties
    );
  }
}
```
