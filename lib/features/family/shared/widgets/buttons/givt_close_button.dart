import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/family/utils/family_app_theme.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/action_container.dart';
import 'package:go_router/go_router.dart';

@Deprecated(
  'Only used in OrganisationDetailBottomsheet, will be migrated to FunBottomSheet soon',
)
class GivtCloseButton extends StatelessWidget {
  const GivtCloseButton({
    super.key,
    this.isDisabled = false,
  });

  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return ActionContainer(
      borderColor: Theme.of(context).colorScheme.primaryContainer,
      baseBorderSize: 4,
      isDisabled: isDisabled,
      onTap: () => context.pop(),
      analyticsEvent: AnalyticsEvent(
        AmplitudeEvents.bottomsheetCloseButtonClicked,
      ),
      child: Container(
        width: 40,
        height: 40,
        color: isDisabled ? FamilyAppTheme.disabledTileBorder : Colors.white,
        child: Icon(
          FontAwesomeIcons.xmark,
          size: 20,
          color: Theme.of(context)
              .colorScheme
              .onPrimaryContainer
              .withOpacity(isDisabled ? 0.5 : 1),
        ),
      ),
    );
  }
}
