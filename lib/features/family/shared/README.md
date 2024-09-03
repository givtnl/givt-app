# Shared README

## Design

Everything related to the FUN Design System in Figma.

https://www.figma.com/design/TpvZkfxdBBBlGmTD7QyxJ3/FUN-Design-System?node-id=47909-2&node-type=CANVAS&t=3S7LFtEtrq3bKbWH-0

Convention:
- `Fun` prefix for all the components
- Name from component in Figma
- Folder name is the grouped name in Figma

So for example for the `Card` component in Figma: 
Name is `FunCard` and we put it in the folder called `content`.

### Theme

Here we have everything related to the FUN theming: colors, sizes etc.

- `FunTextStyles`: contains all the FUN text styles. These are used in the Theme object.

### Illustrations

Here we have the FUN illustrations, icons etc.
For a default icon you should use the `FunIcon` widget. Some icons are already defined via factory constructors.

### Content

- Card => `FunCard`

## Widgets

All the widgets that are shared between the different applications that do not pertain to a Design System.

### Texts

Within the texts folder we have a text widget per material design defined text style. 
These components derive their style from the app Theme.