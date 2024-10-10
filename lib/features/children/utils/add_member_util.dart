import 'dart:async';

import 'package:flutter/material.dart';
import 'package:givt_app/features/children/add_member/pages/add_member_counter_page.dart';
import 'package:givt_app/shared/widgets/extensions/route_extensions.dart';

class AddMemberUtil {
  static Future<void> addMemberPushPages(BuildContext context, {bool showTopUp = false, bool canPop = true}) async {
    await Navigator.push(
      context,
      AddMemberCounterPage(
        initialAmount: 1,
        showTopUp: showTopUp,
        canPop: canPop,
      ).toRoute(context),
    );
  }
}
