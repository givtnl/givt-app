## UI Models
- UI models should be placed in the presentation layer under a `models` directory
- Each feature should have its own UI models that represent the state needed for the UI
- UI models should be immutable and use the `copyWith` pattern for updates
- UI models should extend `Equatable` for proper equality comparison
- UI models should be separated from business logic and data models 