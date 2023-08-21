import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';

class DonationTypeExplanationSheet extends StatelessWidget {
  const DonationTypeExplanationSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final user = context.read<AuthCubit>().state.user;
    return Column(
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
          visible: user.isGiftAidEnabled,
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
