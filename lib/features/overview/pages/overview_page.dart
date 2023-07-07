import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/overview/bloc/givt_bloc.dart';
import 'package:givt_app/features/overview/models/givt_group.dart';
import 'package:givt_app/features/overview/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/user_ext.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:sticky_headers/sticky_headers.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final user = context.read<AuthCubit>().state.user;
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_rounded),
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              showDragHandle: true,
              isScrollControlled: true,
              useSafeArea: true,
              backgroundColor: AppTheme.givtBlue,
              builder: (context) => Container(
                padding: const EdgeInsets.all(20),
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
                ),
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<GivtBloc, GivtState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is GivtLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final monthSections = state.givtGroups
              .where((element) => element.givts.isEmpty)
              .toList();
          final isUKUser = Country.unitedKingdomCodes().contains(user.country);
          return ListView.builder(
            itemCount: isUKUser
                ? state.givtAided.entries.length
                : _getSectionCount(state),
            itemBuilder: (_, int index) {
              return StickyHeader(
                header: isUKUser
                    ? _buildHeader(
                        amount: state.givtAided.entries.elementAt(index).value,
                        country: user.country,
                        color: AppTheme.givtYellow,
                        giftAidTitle: locals.giftOverviewGiftAidBanner(
                          "'${DateFormat('yy').format(
                            DateTime(
                              state.givtAided.entries.elementAt(index).key,
                            ),
                          )}",
                        ),
                      )
                    : const SizedBox.shrink(),
                content: Column(
                  children: isUKUser
                      ? monthSections.map((monthSection) {
                          return _buildSection(monthSection, user, state);
                        }).toList()
                      : [
                          _buildSection(monthSections[index], user, state),
                        ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSection(GivtGroup monthSection, UserExt user, GivtState state) {
    return StickyHeader(
      key: Key(monthSection.timeStamp!.toString()),
      header: _buildHeader(
        timesStamp: monthSection.timeStamp,
        amount: monthSection.amount,
        country: user.country,
      ),
      content: Column(
        children: state.givtGroups.map((givtGroup) {
          if (givtGroup.givts.isEmpty) {
            return const SizedBox.shrink();
          }
          if (givtGroup.timeStamp!.month != monthSection.timeStamp!.month) {
            return const SizedBox.shrink();
          }
          return Column(
            children: [
              GivtListItem(givtGroup: givtGroup),
              const Divider(
                height: 0,
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Container _buildHeader({
    required String country,
    required double amount,
    DateTime? timesStamp,
    Color? color,
    String? giftAidTitle,
  }) {
    final currency = NumberFormat.simpleCurrency(
      name: country == Country.us.countryCode
          ? 'USD'
          : Country.unitedKingdomCodes().contains(country)
              ? 'GBP'
              : 'EUR',
    );
    final headerTitle = timesStamp == null
        ? giftAidTitle
        : '${DateFormat('MMMM').format(timesStamp!)} \'${DateFormat('yy').format(timesStamp)}';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      color: color ?? AppTheme.givtLightPurple,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            headerTitle!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '${currency.currencySymbol} ${amount.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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

  int _getSectionCount(GivtState state) {
    var monthsCount = 0;
    for (final group in state.givtGroups) {
      if (group.givts.isEmpty) {
        monthsCount++;
      }
    }
    return monthsCount;
  }
}
