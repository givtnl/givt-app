import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/overview/bloc/givt_bloc.dart';
import 'package:givt_app/features/overview/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:sticky_headers/sticky_headers.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
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
              backgroundColor: Theme.of(context).colorScheme.tertiary,
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
                      color: AppTheme.givtPurple,
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
          final sections = state.givtGroups
              .where((element) => element.givts.isEmpty)
              .toList();
          return ListView.builder(
            itemCount: _getSectionCount(state),
            itemBuilder: (context, int index) {
              return StickyHeader(
                header: _buildHeader(
                  timesStamp: sections[index].timeStamp!,
                  amount: sections[index].amount,
                  country: (context.read<AuthCubit>().state as AuthSuccess)
                      .user
                      .country,
                ),
                content: Column(
                  children: state.givtGroups.map((givtGroup) {
                    if (givtGroup.givts.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    if (givtGroup.timeStamp!.month !=
                        sections[index].timeStamp!.month) {
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
            },
          );
        },
      ),
    );
  }

  Container _buildHeader({
    required DateTime timesStamp,
    required double amount,
    required String country,
  }) {
    final currency = NumberFormat.simpleCurrency(
      name: country == Country.us.countryCode
          ? 'USD'
          : Country.unitedKingdomCodes().contains(country)
              ? 'GBP'
              : 'EUR',
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      color: AppTheme.givtLightPurple,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${DateFormat('MMMM').format(timesStamp)} \'${DateFormat('yy').format(timesStamp)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '${currency.currencySymbol} $amount',
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
    required Color color,
    required String text,
  }) =>
      Row(
        children: [
          Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
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
    var daysCount = 0;
    for (final group in state.givtGroups) {
      if (group.givts.isEmpty) {
        daysCount++;
      }
    }
    return daysCount;
  }
}
