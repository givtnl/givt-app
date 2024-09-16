import 'dart:async';

import 'package:flutter/material.dart';
import 'package:givt_app/features/children/add_member/pages/add_member_counter_page.dart';
import 'package:givt_app/shared/widgets/extensions/route_extensions.dart';

class AddMemberUtil {
  static Future<void> addMemberPushPages(BuildContext context) async {
    await Navigator.push(
      context,
      const AddMemberCounterPage(
        initialAmount: 1,
      ).toRoute(context),
    );
  }
}
