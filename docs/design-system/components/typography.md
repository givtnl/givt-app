# Typography

The FUN design system uses a consistent typography scale with specialized components for each text style. Always use these components instead of raw Text widgets to ensure consistency across the application.

## Text Components

### Display

For the largest text elements:

- `DisplayLargeText` - Largest display text
- `DisplayMediumText` - Medium display text
- `DisplaySmallText` - Smaller display text

### Headline

For section headers and important titles:

- `HeadlineLargeText` - Primary headings
- `HeadlineMediumText` - Secondary headings
- `HeadlineSmallText` - Tertiary headings

### Title

For content titles and subsection headers:

- `TitleLargeText` - Major content titles
- `TitleMediumText` - Moderate content titles
- `TitleSmallText` - Minor content titles

### Body

For regular content text:

- `BodyLargeText` - Primary content text
- `BodyMediumText` - Standard content text
- `BodySmallText` - Supporting content text

### Label

For interface labels and smaller text elements:

- `LabelLargeText` - Primary labels
- `LabelMediumText` - Standard labels
- `LabelSmallText` - Small labels
- `LabelThinText` - Light-weight labels
- `LabelBadgeText` - Special badge texts

## Usage Guidelines

- Each text component accepts color variations through factory constructors
- Default to the standard component without color specification when following the default theme
- Use specific color variants only when necessary for emphasis or distinction

## Example

```dart
// Standard usage
BodyMediumText('This is regular text content')

// With specific color variant
BodyMediumText.primary30('This text has primary30 color')

// With additional properties
BodyMediumText(
  'Multi-line text with custom properties',
  textAlign: TextAlign.center,
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
)
```
