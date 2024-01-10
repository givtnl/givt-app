import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/overview/bloc/givt_bloc.dart';
import 'package:givt_app/features/overview/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/shared/widgets/donation_type_sheet.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:givt_app/utils/util.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticky_headers/sticky_headers.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  OverlayEntry? overlayEntry;
  bool disposed = false;

  @override
  void initState() {
    super.initState();
    initOverlay();
  }

  Future<void> initOverlay() async {
    final prefs = getIt<SharedPreferences>();

    if (prefs.getBool(Util.cancelFeatureOverlayKey) ?? false) {
      return;
    }

    overlayEntry = OverlayEntry(
      builder: (context) => FeatureOverlay(
        onDismiss: () {
          disposed = true;
          overlayEntry!
            ..remove()
            ..dispose();
        },
      ),
    );
  }

  @override
  void dispose() {
    if (overlayEntry != null) {
      if (overlayEntry!.mounted) {
        overlayEntry!.remove();
        overlayEntry!.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return BlocConsumer<GivtBloc, GivtState>(
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
        if (state is GivtDownloadedSuccess) {
          showDialog<void>(
            context: context,
            builder: (_) => WarningDialog(
              title: locals.success,
              content: locals.giftsOverviewSent,
              onConfirm: () => context.pop(),
            ),
          );
        }

        if (state is GivtUnknown) {
          showDialog<void>(
            context: context,
            builder: (_) => WarningDialog(
              title: locals.errorOccurred,
              content: locals.errorContactGivt,
              onConfirm: () => context.pop(),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is GivtLoading) {
          return _buildLoadingScaffold();
        }
        if (state.givts.isEmpty) {
          return _buildEmptyScaffold(context);
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (overlayEntry == null || disposed) {
            return;
          }

          Overlay.of(context).insert(overlayEntry!);
        });
        return _buildFilledScaffold(
          context,
          state,
        );
      },
    );
  }

  Widget _buildFilledScaffold(
    BuildContext context,
    GivtState state,
  ) {
    final locals = context.l10n;
    final user = context.read<AuthCubit>().state.user;
    final monthSections =
        state.givtGroups.where((element) => element.givts.isEmpty).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(locals.historyTitle),
        leading: const BackButton(),
        actions: [
          _buildAppBarItem(
            context: context,
            state: state,
            color: Colors.white,
            icon: const Icon(Icons.download),
            child: DownloadYearOverviewSheet(
              state: state,
              givtbloc: context.read<GivtBloc>(),
            ),
          ),
          _buildAppBarItem(
            state: state,
            context: context,
            icon: const Icon(Icons.info_rounded),
            child: const DonationTypeExplanationSheet(),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _getSectionCount(state),
        itemBuilder: (_, int index) {
          return StickyHeader(
            key: Key(monthSections[index].timeStamp!.toString()),
            header: Column(
              children: [
                Visibility(
                  visible: user.isGiftAidEnabled,
                  child: _buildHeader(
                    context: context,
                    amount:
                        state.givtAided[monthSections[index].timeStamp!.year] ??
                            0,
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
                  context: context,
                  timesStamp: monthSections[index].timeStamp,
                  amount: monthSections[index].amount,
                  country: user.country,
                ),
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

                if (givtGroup.timeStamp!.year !=
                    monthSections[index].timeStamp!.year) {
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
                        if (givtGroup.status == 1 || givtGroup.status == 2) {
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
                                  content: locals.cantCancelAlreadyProcessed,
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
      ),
    );
  }

  Widget _buildEmptyScaffold(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  context.l10n.historyIsEmpty,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Image.asset(
                  'assets/images/givy_money.png',
                  height: MediaQuery.sizeOf(context).height * 0.3,
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildLoadingScaffold() => const Scaffold(
        body: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      );

  Widget _buildHeader({
    required BuildContext context,
    required String country,
    required double amount,
    DateTime? timesStamp,
    Color? color,
    String? giftAidTitle,
  }) {
    final currencySymbol = Util.getCurrencySymbol(countryCode: country);
    final headerTitle = timesStamp == null
        ? giftAidTitle
        : "${Util.getMonthName(
            timesStamp.toIso8601String(),
            Util.getLanguageTageFromLocale(context),
          )} '${DateFormat('yy').format(timesStamp)}";
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
            '$currencySymbol ${Util.formatNumberComma(amount, Country.fromCode(country))}',
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

  Widget _buildAppBarItem({
    required GivtState state,
    required BuildContext context,
    required Widget child,
    required Icon icon,
    Color? color,
  }) {
    return Visibility(
      visible: state.givtGroups.isNotEmpty,
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
