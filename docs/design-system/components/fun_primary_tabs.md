# FunPrimaryTabs

FunPrimaryTabs provides a tabbed navigation component for switching between related content sections.

## Usage Guidelines

- Use when content can be logically divided into distinct categories
- Limit to 2-5 tabs for optimal usability
- Keep tab labels concise and clear
- Ensure content adapts appropriately when switching tabs

## Example

```dart
FunPrimaryTabs(
  tabs: [
    FunTab(title: 'Upcoming'),
    FunTab(title: 'History'),
  ],
  children: [
    UpcomingDonationsView(),
    DonationHistoryView(),
  ],
);
```
