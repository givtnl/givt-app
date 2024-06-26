import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/amount_presets/pages/amount_presets_page_view.dart';
import 'package:givt_app/features/amount_presets/pages/enable_amount_presets_page_view.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

class ChangeAmountPresetsBottomSheet extends StatefulWidget {
  const ChangeAmountPresetsBottomSheet({super.key,});

  @override
  State<ChangeAmountPresetsBottomSheet> createState() =>
      _ChangeAmountPresetsBottomSheetState();
}

class _ChangeAmountPresetsBottomSheetState
    extends State<ChangeAmountPresetsBottomSheet> {
  final animationDuration = const Duration(milliseconds: 200);
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return BottomSheetLayout(
      title: Text(
        locals.amountPresetsTitle,
      ),
      onBackPressed: () {
        if (pageController.page == 0) {
          context.pop();
        } else {
          pageController.previousPage(
            duration: animationDuration,
            curve: Curves.easeOut,
          );
        }
      },
      child: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          EnableAmountPresetsPageView(
            onAmountPresetsChanged: ({bool changed = false}) {
              final auth = context.read<AuthCubit>();
              auth.updatePresets(
                presets: auth.state.presets.copyWith(
                  isEnabled: changed,
                ),
              );
            },
            changeAmountPresets: () => pageController.nextPage(
              duration: animationDuration,
              curve: Curves.easeIn,
            ),
          ),
          AmountPresetsPageView(
            onAmountPresetsChanged: (first, second, third) {
              final auth = context.read<AuthCubit>();
              final presets = auth.state.presets;
              auth
                  .updatePresets(
                    presets: presets.copyWith(
                      presets: presets.presets.map((preset) {
                        switch (preset.id) {
                          case 1:
                            preset = preset.copyWith(
                              amount: first,
                            );
                          case 2:
                            preset = preset.copyWith(
                              amount: second,
                            );
                          case 3:
                            preset = preset.copyWith(
                              amount: third,
                            );
                        }
                        return preset;
                      }).toList(),
                    ),
                  )
                  .whenComplete(
                    () => context.pop(),
                  );
            },
          ),
        ],
      ),
    );
  }
}
