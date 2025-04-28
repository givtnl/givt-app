# FunTile

FunTile provides a consistent container for content blocks.

## Usage Guidelines

- Use for grouping related information
- Maintain consistent padding within tiles
- Can contain text, icons, and interactive elements
- Supports various states (default, pressed, disabled)

## Example

```dart
FunTile(
  leading: Icon(Icons.favorite),
  title: 'Donation',
  subtitle: 'Monthly recurring',
  trailing: Icon(Icons.chevron_right),
  onTap: () => handleTap(),
);
```
