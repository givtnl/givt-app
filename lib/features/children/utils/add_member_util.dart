import 'dart:async';

import 'package:flutter/material.dart';
import 'package:givt_app/core/enums/amplitude_events.dart';
import 'package:givt_app/features/children/add_member/pages/add_member_counter_page.dart';
import 'package:givt_app/features/children/add_member/pages/family_member_form_page.dart';
import 'package:givt_app/shared/widgets/extensions/route_extensions.dart';
import 'package:givt_app/utils/analytics_helper.dart';

class AddMemberUtil {
  static Future<void> addMemberPushPages(BuildContext context) async {
    final dynamic result = await Navigator.push(
      context,
      const AddMemberCounterPage(
        initialAmount: 1,
      ).toRoute(context),
    );
    if (result != null && result is int && context.mounted) {
      unawaited(
        AnalyticsHelper.logEvent(
          eventName: AmplitudeEvents.numberOfMembersSelected,
          eventProperties: {
            'nrOfMembers': result,
          },
        ),
      );
      await Navigator.push(
        context,
        FamilyMemberFormPage(
          index: 1,
          totalCount: result,
          membersToCombine: [],
        ).toRoute(context),
      );
    }
  }
}
