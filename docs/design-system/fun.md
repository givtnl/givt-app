# FUN Design System

The FUN design system provides a cohesive and consistent user experience across the Givt application. This document outlines the core components and guidelines for implementing the FUN design system in your development work.

## Core Principles

- **Consistency**: Maintain visual and behavioral consistency across all screens
- **Accessibility**: Ensure components are usable by people with varying abilities
- **Simplicity**: Keep interfaces clean and intuitive
- **Brand Alignment**: All components should reflect Givt's brand identity

## Components

This section provides an overview of the core components in the FUN design system. Each component has its own dedicated documentation with detailed usage guidelines and examples.

### Layout Components

- [FunScaffold](./components/fun_scaffold.md) - Foundation for all screens in the application
- [FunPrimaryTabs](./components/fun_primary_tabs.md) - Tabbed navigation for related content sections

### Interactive Components

- [FunButton](./components/fun_button.md) - Primary action component for user interactions
- [FunTile](./components/fun_tile.md) - Container for interactive content blocks
- [FunBottomSheet](./components/fun_bottom_sheet.md) - Bottom sheet for additional content or actions

### Typography

The FUN design system includes a comprehensive typography system with specialized text components. For detailed information, see the [Typography documentation](./components/typography.md).

### Colors and Theming

The design system uses a carefully selected color palette to ensure visual consistency across the application. For detailed information, see the [Colors documentation](./components/colors.md).

## Implementation Notes

- Always import the FUN components from the shared design system package
- Do not create custom variations of these components
- For use cases not covered by existing components, discuss with the design team
- Keep accessibility in mind when implementing these components

## Best Practices

1. **Consistency First**: Always choose a FUN component over creating custom UI
2. **Mobile Considerations**: Test on various screen sizes
3. **Performance**: Be mindful of component reuse and optimization
4. **Feedback**: Provide clear user feedback for all interactions
5. **Accessibility**: Support various user needs including screen readers and keyboard navigation

## Component Documentation

Each component in the FUN design system has its own dedicated documentation:

- **Layout Components**
  - [FunScaffold](./components/fun_scaffold.md)
  - [FunPrimaryTabs](./components/fun_primary_tabs.md)

- **Interactive Components**
  - [FunButton](./components/fun_button.md)
  - [FunTile](./components/fun_tile.md)
  - [FunBottomSheet](./components/fun_bottom_sheet.md)

- **Foundation**
  - [Typography](./components/typography.md)
  - [Colors](./components/colors.md)
