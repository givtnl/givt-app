// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:widgetbook/widgetbook.dart' as _i1;
import 'package:widgetbook_workspace/fun_bottomsheet.dart' as _i3;
import 'package:widgetbook_workspace/fun_button.dart' as _i2;

final directories = <_i1.WidgetbookNode>[
  _i1.WidgetbookFolder(
    name: 'features',
    children: [
      _i1.WidgetbookFolder(
        name: 'family',
        children: [
          _i1.WidgetbookFolder(
            name: 'shared',
            children: [
              _i1.WidgetbookFolder(
                name: 'design',
                children: [
                  _i1.WidgetbookFolder(
                    name: 'components',
                    children: [
                      _i1.WidgetbookFolder(
                        name: 'actions',
                        children: [
                          _i1.WidgetbookComponent(
                            name: 'FunButton',
                            useCases: [
                              _i1.WidgetbookUseCase(
                                name: 'Primary',
                                builder: _i2.funButtonPrimary,
                                designLink:
                                    'https://www.figma.com/design/TpvZkfxdBBBlGmTD7QyxJ3/FUN-Design-System?node-id=54585-30129&t=8tRS5nTy6XaUkJEM-1',
                              ),
                              _i1.WidgetbookUseCase(
                                name: 'Secondary',
                                builder: _i2.funButtonSecondary,
                                designLink:
                                    'https://www.figma.com/design/TpvZkfxdBBBlGmTD7QyxJ3/FUN-Design-System?node-id=54585-30129&t=8tRS5nTy6XaUkJEM-1',
                              ),
                              _i1.WidgetbookUseCase(
                                name: 'Tertiary',
                                builder: _i2.funButtonTertiary,
                                designLink:
                                    'https://www.figma.com/design/TpvZkfxdBBBlGmTD7QyxJ3/FUN-Design-System?node-id=54585-30129&t=8tRS5nTy6XaUkJEM-1',
                              ),
                            ],
                          )
                        ],
                      ),
                      _i1.WidgetbookFolder(
                        name: 'overlays',
                        children: [
                          _i1.WidgetbookLeafComponent(
                            name: 'FunBottomSheet',
                            useCase: _i1.WidgetbookUseCase(
                              name: 'Primary',
                              builder: _i3.funBottomSheetPrimary,
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              )
            ],
          )
        ],
      )
    ],
  )
];
