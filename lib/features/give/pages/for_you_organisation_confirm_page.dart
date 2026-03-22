import 'dart:async';

import 'package:flutter/material.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon_givy.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_app_theme.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_theme.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/label_large_text.dart';
import 'package:givt_app/features/family/shared/widgets/texts/title_large_text.dart';
import 'package:givt_app/features/give/models/for_you_flow_context.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/models/collect_group.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:go_router/go_router.dart';

/// Confirmation after resolving an organisation via location, QR, or beacon.
class ForYouOrganisationConfirmPage extends StatefulWidget {
  const ForYouOrganisationConfirmPage({
    required this.flowContext,
    super.key,
  });

  final ForYouFlowContext flowContext;

  @override
  State<ForYouOrganisationConfirmPage> createState() =>
      _ForYouOrganisationConfirmPageState();
}

class _ForYouOrganisationConfirmPageState
    extends State<ForYouOrganisationConfirmPage> {
  static const _autoAdvanceSeconds = 3;

  int _countdown = _autoAdvanceSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final organisation = widget.flowContext.selectedOrganisation;
    if (organisation != null && organisation.nameSpace.isNotEmpty) {
      _startCountdown();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_countdown <= 1) {
        timer.cancel();
        _navigateForward();
      } else {
        setState(() => _countdown--);
      }
    });
  }

  void _navigateForward() {
    _timer?.cancel();
    if (!mounted) return;
    context.goNamed(
      Pages.forYouGiving.name,
      extra: widget.flowContext.toMap(),
    );
  }

  void _goToList() {
    _timer?.cancel();
    context.goNamed(
      Pages.forYouList.name,
      extra: ForYouFlowContext(source: widget.flowContext.source).toMap(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final organisation = widget.flowContext.selectedOrganisation;
    final theme = FunTheme.of(context);

    if (organisation == null || organisation.nameSpace.isEmpty) {
      return Scaffold(
        backgroundColor: theme.primary40,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GivtBackButtonFlat(
            color: theme.primary99,
            onPressed: () async => _goToList(),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: TitleLargeText(
              context.l10n.somethingWentWrong,
              color: theme.primary99,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return FunScaffold(
      backgroundColor: theme.primary80,
      appBar: FunTopAppBar(
        color: Colors.transparent,
        leading: GivtBackButtonFlat(
          color: theme.primary99,
          onPressed: () async => _goToList(),
        ),
      ),
      body: Column(
        children: [
          const Spacer(),
          _HeroIllustration(theme: theme),
          const SizedBox(height: 28),
          TitleLargeText(
            context.l10n.forYouOrganisationConfirmHeadline,
            textAlign: TextAlign.center,
            color: theme.primary99,
          ),
          const SizedBox(height: 24),
          _OrganisationPill(organisation: organisation),
          const Spacer(),
          FunButton(
            variant: FunButtonVariant.secondary,
            text: '${context.l10n.buttonContinue} ($_countdown)',
            analyticsEvent: AnalyticsEvent(
              AnalyticsEventName.forYouOrganisationConfirmGiveTapped,
            ),
            onTap: _navigateForward,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _HeroIllustration extends StatelessWidget {
  const _HeroIllustration({required this.theme});

  final FunAppTheme theme;

  @override
  Widget build(BuildContext context) {
    return FunIconGivy.phoneWink(circleSize: 140);
  }
}

class _OrganisationPill extends StatelessWidget {
  const _OrganisationPill({required this.organisation});

  final CollectGroup organisation;

  @override
  Widget build(BuildContext context) {
    final theme = FunTheme.of(context);
    // Use the same glyphs as before (getIconByType); wrap in FunIcon for FUN
    // styling. getFunIconByType uses different symbols for some types (e.g.
    // globe vs heart for charities).
    final collectGroupIcon = FunIcon(
      iconData: CollectGroupType.getIconByType(organisation.type),
      circleColor: theme.primary99,
      iconColor: theme.primary40,
      circleSize: 56,
      iconSize: 28,
      padding: EdgeInsets.zero,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        decoration: BoxDecoration(
          color: theme.primary30,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: theme.primary80,
            width: theme.borderWidthThin,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(12, 12, 16, 12),
        child: Row(
          children: [
            collectGroupIcon,
            const SizedBox(width: 12),
            Expanded(
              child: LabelLargeText(
                organisation.orgName,
                color: theme.primary99,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
