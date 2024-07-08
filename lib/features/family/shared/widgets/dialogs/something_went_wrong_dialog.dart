import 'package:flutter/material.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_elevated_secondary_button.dart';
import 'package:givt_app/shared/widgets/buttons/givt_elevated_button.dart';
import 'package:givt_app/shared/widgets/common_icons.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';

class SomethingWentWrongDialog extends StatefulWidget {
  const SomethingWentWrongDialog({
    required this.primaryBtnText,
    required this.onClickPrimaryBtn,
    super.key,
    this.secondaryBtnText,
    this.description,
    this.icon,
    this.iconColor,
    this.circleColor,
    this.showLoading,
    this.primaryBtnLeftIcon,
    this.primaryBtnRightIcon,
    this.primaryBtnLeadingImage,
    this.onClickSecondaryBtn,
  });

  final String primaryBtnText;
  final String? secondaryBtnText;
  final String? description;
  final IconData? icon;
  final Color? iconColor;
  final Color? circleColor;
  final IconData? primaryBtnLeftIcon;
  final IconData? primaryBtnRightIcon;
  final Widget? primaryBtnLeadingImage;
  final bool? showLoading;
  final Future<void> Function() onClickPrimaryBtn;
  final void Function()? onClickSecondaryBtn;

  static void show(BuildContext context,
      {required String primaryBtnText,
      required Future<void> Function() onClickPrimaryBtn,
      String? secondaryBtnText = 'Close',
      String? description = 'Oops, something went wrong',
      IconData? icon,
      Color? iconColor,
      Color? circleColor,
      IconData? primaryLeftIcon,
      IconData? primaryRightIcon,
      Widget? primaryLeadingImage,
      bool? showLoading = false,
      void Function()? onClickSecondaryBtn}) {
    showDialog<void>(
      context: context,
      builder: (context) => SomethingWentWrongDialog(
        primaryBtnText: primaryBtnText,
        onClickPrimaryBtn: onClickPrimaryBtn,
        secondaryBtnText: secondaryBtnText,
        onClickSecondaryBtn: onClickSecondaryBtn,
        primaryBtnLeftIcon: primaryLeftIcon,
        primaryBtnRightIcon: primaryRightIcon,
        primaryBtnLeadingImage: primaryLeadingImage,
        description: description,
        icon: icon,
        iconColor: iconColor,
        circleColor: circleColor,
        showLoading: showLoading,
      ),
    );
  }

  @override
  State<SomethingWentWrongDialog> createState() =>
      _SomethingWentWrongDialogState();
}

class _SomethingWentWrongDialogState extends State<SomethingWentWrongDialog> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.icon == null)
              warningIcon()
            else
              primaryCircleWithIcon(iconData: widget.icon),
            const SizedBox(height: 24),
            if (widget.description != null)
              Text(
                widget.description!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontFamily: 'Raleway',
                      color: AppTheme.givtBlue,
                      letterSpacing: 0.25,
                    ),
              ),
            const SizedBox(height: 16),
            GivtElevatedButton(
              text: widget.primaryBtnText,
              onTap: () async {
                if (true == widget.showLoading) {
                  setState(() {
                    _isLoading = true;
                  });
                }
                await widget.onClickPrimaryBtn.call();
                setState(() {
                  _isLoading = false;
                });
              },
              leftIcon: widget.primaryBtnLeftIcon,
              rightIcon: widget.primaryBtnRightIcon,
              leadingImage: widget.primaryBtnLeadingImage,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 16),
            GivtElevatedSecondaryButton(
              text: widget.secondaryBtnText!,
              onTap: widget.onClickSecondaryBtn ?? () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }
}
