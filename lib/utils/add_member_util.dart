import 'dart:async';

import 'package:flutter/material.dart';
import 'package:givt_app/features/family/features/add_member/pages/add_family_counter_page.dart';
import 'package:givt_app/features/family/features/add_member/pages/add_member_counter_page.dart';
import 'package:givt_app/shared/widgets/extensions/route_extensions.dart';

class AddMemberUtil {
  static Future<void> addMemberPushPages(
    BuildContext context, {
    bool showTopUp = false,
    bool existingFamily = false,
  }) async {
    await Navigator.push(
      context,
      AddMemberCounterPage(
        initialAmount: 1,
        showTopUp: showTopUp,
        existingFamily: existingFamily,
      ).toRoute(context),
    );
  }

  static Future<void> addFamilyPushPages(BuildContext context) async {
    await Navigator.push(
      context,
      const AddFamilyCounterPage(
        existingFamily: false,
      ).toRoute(context),
    );
  }
}
