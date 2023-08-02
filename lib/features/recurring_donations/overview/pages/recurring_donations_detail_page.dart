import 'package:flutter/material.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';

class RecurringDonationsDetailPage extends StatelessWidget {
  const RecurringDonationsDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(
          'Selected Organisation',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          _buildAppBarItem(
            //state: state,
            context: context,
            icon: const Icon(Icons.info_rounded),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  locals.historyInfoTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildColorExplanationRow(
                  color: const Color(0xFF494871),
                  text: locals.historyAmountAccepted,
                ),
                const SizedBox(height: 20),
                _buildColorExplanationRow(
                  color: AppTheme.givtLightGreen,
                  text: locals.historyAmountCollected,
                ),
                const SizedBox(height: 20),
                _buildColorExplanationRow(
                  color: AppTheme.givtRed,
                  text: locals.historyAmountDenied,
                ),
                const SizedBox(height: 20),
                _buildColorExplanationRow(
                  color: AppTheme.givtLightGray,
                  text: locals.historyAmountCancelled,
                ),
                Visibility(
                  visible: false,
                  //user.isGiftAidEnabled,
                  child: Column(
                    children: [
                      const Divider(color: Colors.white),
                      _buildColorExplanationRow(
                        image: 'assets/images/gift_aid_yellow.png',
                        text: locals.giftOverviewGiftAidBanner(''),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        color: AppTheme.givtGrayf3f3f3,
        child: Column(
          children: [
            Text('Recurring Donations Detail Page'),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarItem({
    // required GivtState state,
    required BuildContext context,
    required Widget child,
    required Icon icon,
    Color? color,
  }) {
    return Visibility(
      visible: true,
      //state.givtGroups.isNotEmpty,
      child: IconButton(
        icon: icon,
        onPressed: () => showModalBottomSheet<void>(
          context: context,
          showDragHandle: true,
          isScrollControlled: true,
          useSafeArea: true,
          backgroundColor: color ?? AppTheme.givtBlue,
          builder: (context) =>
              Container(padding: const EdgeInsets.all(20), child: child),
        ),
      ),
    );
  }

  Row _buildColorExplanationRow({
    required String text,
    Color? color,
    String? image,
  }) =>
      Row(
        children: [
          Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              image: image != null
                  ? DecorationImage(
                      scale: 0.8,
                      image: AssetImage(
                        image,
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          )
        ],
      );
}
