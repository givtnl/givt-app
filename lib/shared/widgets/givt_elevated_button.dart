import 'package:flutter/material.dart';
import 'package:givt_app/shared/widgets/action_container.dart';
import 'package:givt_app/utils/utils.dart';

class GivtElevatedButton extends StatelessWidget {
  const GivtElevatedButton({
    required this.onTap,
    required this.text,
    super.key,
    this.isDisabled = false,
    this.isLoading = false,
    this.leftIcon,
    this.rightIcon,
    this.leadingImage,
    this.widthMultiplier = .9,
  });

  final VoidCallback? onTap;
  final bool isDisabled;
  final String text;
  final bool isLoading;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final Widget? leadingImage;
  final double widthMultiplier;

  @override
  Widget build(BuildContext context) {
    return ActionContainer(
      onTap: () => onTap,
      borderColor: AppTheme.givtGreen40,
      isDisabled: isDisabled,
      borderSize: 0.01,
      child: Container(
        height: 58,
        width: MediaQuery.sizeOf(context).width * widthMultiplier,
        decoration: BoxDecoration(
          color: isDisabled ? AppTheme.givtGraycece : AppTheme.givtLightGreen,
        ),
        child: getChild(context),
      ),
    );
  }

  Widget getChild(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (leftIcon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(
              leftIcon,
              size: 24,
              color: AppTheme.givtGreen40,
            ),
          ),
          Text(
            text,
            style: isDisabled == true
                ? Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Rouna',
                    )
                : Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.givtGreen40,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Rouna',
                    ),
          ),
        ],
      );
    }
    if (rightIcon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: isDisabled == true
                ? Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Rouna',
                    )
                : Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppTheme.givtGreen40,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Rouna',
                    ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Icon(
              rightIcon,
              size: 24,
              color: AppTheme.givtGreen40,
            ),
          ),
        ],
      );
    }
    if (leadingImage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            leadingImage!,
            Text(
              text,
              style: isDisabled == true
                  ? Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Rouna',
                      )
                  : Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.givtGreen40,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Rouna',
                      ),
            ),
            // all leading images must be 32 pixels wide
            // this centers the text
            const SizedBox(width: 32),
          ],
        ),
      );
    }
    return Center(
      child: Text(
        text,
        style: isDisabled == true
            ? Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Theme.of(context).colorScheme.outline)
            : Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.givtGreen40,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Rouna',
                ),
      ),
    );
  }
}
