import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/overview/bloc/givt_bloc.dart';
import 'package:givt_app/features/overview/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';
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
        listener: (context, state) {
          if (state is GivtNoInternet) {
            showDialog<void>(
              context: context,
              builder: (_) => WarningDialog(
                title: locals.noInternetConnectionTitle,
                content: locals.noInternet,
                onConfirm: () => context.pop(),
              ),
            );
          }
          if (state is GivtError) {
            if (state.message == 'already_processed') {
              showDialog<void>(
                context: context,
                builder: (_) => WarningDialog(
                  title: locals.cancelFailed,
                  content: locals.cantCancelAlreadyProcessed,
                  onConfirm: () => context.pop(),
                ),
              );
              return;
            }
            showDialog<void>(
              context: context,
              builder: (_) => WarningDialog(
                title: locals.cancelFailed,
                content: locals.cantCancelGiftAfter15Minutes,
                onConfirm: () => context.pop(),
              ),
            );
          }
          
        },
        builder: (context, state) {
          if (state is GivtLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final monthSections = state.givtGroups
              .where((element) => element.givts.isEmpty)
              .toList();
          return ListView.builder(
            itemCount: _getSectionCount(state),
            itemBuilder: (_, int index) {
              return StickyHeader(
                key: Key(monthSections[index].timeStamp!.toString()),
                header: Column(
                  children: [
                    Visibility(
                      visible: user.isGiftAidEnabled,
                      child: _buildHeader(
                        amount: state
                            .givtAided[monthSections[index].timeStamp!.year]!,
                        country: user.country,
                        color: AppTheme.givtYellow,
                        giftAidTitle: locals.giftOverviewGiftAidBanner(
                          "'${DateFormat('yy').format(
                            monthSections[index].timeStamp!,
                          )}",
                        ),
                      ),
                    ),
                    _buildHeader(
                      timesStamp: monthSections[index].timeStamp,
                      amount: monthSections[index].amount,
                      country: user.country,
                    )
                  ],
                ),
                content: Column(
                  children: state.givtGroups.map((givtGroup) {
                    if (givtGroup.givts.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    if (givtGroup.timeStamp!.month !=
                        monthSections[index].timeStamp!.month) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      children: [
                        GivtListItem(
                          givtGroup: givtGroup,
                          onDismiss: (direction) {
                            context.read<GivtBloc>().add(
                                  GiveDelete(
                                    timestamp: givtGroup.timeStamp!,
                                  ),
                                );
                          },
                          confirmDismiss: (direction) async {
                            if (givtGroup.status == 1 ||
                                givtGroup.status == 2) {
                              return Future.value(
                                await showDialog<bool>(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (_) => ConfirmationDialog(
                                    title: locals.cancelGiftAlertTitle,
                                    content: locals.cancelGiftAlertMessage,
                                    onConfirm: () => context.pop(true),
                                    onCancel: () => context.pop(false),
                                    confirmText: locals.yes,
                                    cancelText: locals.no,
                                  ),
                                ),
                              );
                            }

                            return Future.value(
                              await showDialog<bool>(
                                    context: context,
                                    builder: (_) => WarningDialog(
                                      title: locals.cancelFailed,
                                      content:
                                          locals.cantCancelAlreadyProcessed,
                                      onConfirm: () => context.pop(false),
                                    ),
                                  ) ??
                                  false,
                            );
                          },
                        ),
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
        : '${DateFormat('MMMM').format(timesStamp)} \'${DateFormat('yy').format(timesStamp)}';
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
