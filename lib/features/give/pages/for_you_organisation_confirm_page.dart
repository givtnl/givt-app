import 'dart:async';

import 'package:flutter/material.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/analytics_event_name.dart';
import 'package:givt_app/core/enums/collect_group_type.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/illustrations/fun_icon_givy.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_theme.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button_flat.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
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

  @override
  Widget build(BuildContext context) {
    final organisation = widget.flowContext.selectedOrganisation;

    if (organisation == null || organisation.nameSpace.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: const GivtBackButtonFlat(),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: TitleLargeText(
              context.l10n.somethingWentWrong,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return FunScaffold(
      appBar: const FunTopAppBar(
        variant: FunTopAppBarVariant.white,
        leading: GivtBackButtonFlat(),
      ),
      body: Column(
        children: [
          const Spacer(),
          const _HeroIllustration(),
          const SizedBox(height: 28),
          TitleLargeText(
            context.l10n.forYouOrganisationConfirmHeadline,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _OrganisationPill(organisation: organisation),
          const Spacer(),
          FunButton(
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
  const _HeroIllustration();

  @override
  Widget build(BuildContext context) {
    return FunIconGivy.love(circleSize: 140);
  }
}

class _OrganisationPill extends StatelessWidget {
  const _OrganisationPill({required this.organisation});

  final CollectGroup organisation;

  @override
  Widget build(BuildContext context) {
    final typeIcon = CollectGroupType.getFunIconByType(organisation.type)
        .copyWith(
          padding: EdgeInsets.zero,
          circleSize: 48,
          iconSize: 22,
        );

    return Row(
      children: [
        typeIcon,
        const SizedBox(width: 16),
        Expanded(
          child: HeadlineLargeText(
            organisation.orgName,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
