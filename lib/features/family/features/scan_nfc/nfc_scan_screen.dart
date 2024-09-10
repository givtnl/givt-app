import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/injection/injection.dart';
import 'package:givt_app/app/routes/pages.dart';
import 'package:givt_app/core/config/app_config.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/app/family_pages.dart';
import 'package:givt_app/features/family/features/coin_flow/widgets/search_coin_animated_widget.dart';
import 'package:givt_app/features/family/features/flows/cubit/flow_type.dart';
import 'package:givt_app/features/family/features/flows/cubit/flows_cubit.dart';
import 'package:givt_app/features/family/features/giving_flow/organisation_details/cubit/organisation_details_cubit.dart';
import 'package:givt_app/features/family/features/scan_nfc/cubit/scan_nfc_cubit.dart';
import 'package:givt_app/features/family/features/scan_nfc/widgets/android_nfc_found_bottomsheet.dart';
import 'package:givt_app/features/family/features/scan_nfc/widgets/android_nfc_not_available_sheet.dart';
import 'package:givt_app/features/family/features/scan_nfc/widgets/android_nfc_scanning_bottomsheet.dart';
import 'package:givt_app/features/family/features/scan_nfc/widgets/start_scan_nfc_button.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/widgets/buttons/givt_back_button.dart';
import 'package:givt_app/features/family/shared/widgets/dialogs/something_went_wrong_dialog.dart';
import 'package:givt_app/features/family/utils/utils.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class NFCScanPage extends StatefulWidget {
  const NFCScanPage({
    super.key,
    this.isFromGenerosityChallenge = false,
  });

  final bool isFromGenerosityChallenge;

  @override
  State<NFCScanPage> createState() => _NFCScanPageState();
}

class _NFCScanPageState extends State<NFCScanPage> {
  @override
  void initState() {
    super.initState();
    // Prescanning delay is to improve the UI animation (not be jarring)
    context.read<ScanNfcCubit>().readTag(
          prescanningDelay:
              Duration(milliseconds: Platform.isAndroid ? 100 : 0),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = const FamilyAppTheme().toThemeData();
    return Theme(
      data: theme,
      child: BlocConsumer<ScanNfcCubit, ScanNfcState>(
        listener: (context, state) async {
          final scanNfcCubit = context.read<ScanNfcCubit>();
          if (state.scanNFCStatus == ScanNFCStatus.error) {
            _showNotAGivtCoinDialog(context);
          } else if (state.scanNFCStatus == ScanNFCStatus.scanning &&
              Platform.isAndroid) {
            await showModalBottomSheet<void>(
              context: context,
              isDismissible: false,
              enableDrag: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              builder: (BuildContext context) {
                return BlocProvider.value(
                  value: scanNfcCubit,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: BlocBuilder<ScanNfcCubit, ScanNfcState>(
                      builder: (context, state) {
                        if (state.scanNFCStatus == ScanNFCStatus.scanned) {
                          return BlocBuilder<OrganisationDetailsCubit,
                              OrganisationDetailsState>(
                            builder: (context, state) {
                              return const FoundNfcAnimation();
                            },
                          );
                        } else {
                          return ScanningNfcAnimation(
                            scanNfcCubit: scanNfcCubit,
                          );
                        }
                      },
                    ),
                  ),
                );
              },
            );
          }
          if (state.scanNFCStatus == ScanNFCStatus.nfcNotAvailable &&
              Platform.isAndroid) {
            if (!context.mounted) {
              return;
            }
            context.pop();
            await showModalBottomSheet<void>(
              context: context,
              isDismissible: false,
              isScrollControlled: true,
              enableDrag: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              builder: (BuildContext context) {
                return BlocProvider.value(
                  value: scanNfcCubit,
                  child: BlocBuilder<ScanNfcCubit, ScanNfcState>(
                    builder: (context, state) {
                      return NfcNotAvailableSheet(scanNfcCubit: scanNfcCubit);
                    },
                  ),
                );
              },
            );
          }
          if (state.scanNFCStatus == ScanNFCStatus.scanned) {
            await _handleScanned(context, state);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: FunTopAppBar(
              leading: GivtBackButton(
                onPressedExt: () {
                  context.read<FlowsCubit>().resetFlow();
                  context.read<ScanNfcCubit>().cancelScanning();
                },
              ),
              title: '',
            ),
            body: SafeArea(
              child: Center(
                child: Flex(
                  direction: Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Text(
                        'Ready to make a difference?',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Text(
                      "Grab your coin and \nlet's begin!",
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(flex: 2),
                    const SearchCoinAnimatedWidget(),
                    const SizedBox(height: 20),
                    if (state.scanNFCStatus == ScanNFCStatus.error)
                      const Text('Error scanning the coin')
                    else
                      const Text(''),
                    const Spacer(flex: 3),
                  ],
                ),
              ),
            ),
            floatingActionButton: state.scanNFCStatus == ScanNFCStatus.ready
                ? const StartScanNfcButton()
                : null,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
        },
      ),
    );
  }

  Future<bool> _handleScanned(BuildContext context, ScanNfcState state) async {
    final success = await context
        .read<OrganisationDetailsCubit>()
        .getOrganisationDetails(state.mediumId);

    if (success) {
      _handleScanSuccess(context, state);
    } else {
      _showGenericErrorDialog(context);
    }
    return success;
  }

  void _handleScanSuccess(BuildContext context, ScanNfcState state) {
    // Android needs the delay to show the success bottom sheet animation
    // iOS needs this delay to allow for the bottomsheet to close
    Future.delayed(ScanNfcCubit.animationDuration, () {
      // check for flow
      final flow = context.read<FlowsCubit>().state.flowType;
      if (flow == FlowType.inAppGenerosityCoin) {
        // navigate to webflow
        final isTestApp = getIt<AppConfig>().isTestApp;
        if (isTestApp) {
          context.go(
            '${Pages.redirectToBrowser.path}?uri=https://dev-coin.givt.app/?mediumId=${state.mediumId}',
          );
        } else {
          context.go(
            '${Pages.redirectToBrowser.path}?uri=https://coin.givt.app/?mediumId=${state.mediumId}',
          );
        }
        return;
      }
      context.pushReplacementNamed(FamilyPages.familyChooseAmountSlider.name);

      AnalyticsHelper.logEvent(
        eventName: AmplitudeEvents.inAppCoinScannedSuccessfully,
        eventProperties: {
          AnalyticsHelper.mediumIdKey: state.mediumId,
        },
      );
    });
  }

  void _showNotAGivtCoinDialog(BuildContext context) {
    SomethingWentWrongDialog.show(
      context,
      onClickPrimaryBtn: () async =>
          _handleNotAGivtCoinTryAgainClicked(context),
      onClickSecondaryBtn: () {
        _navigateToHome(context);
      },
      icon: FontAwesomeIcons.question,
      secondaryBtnText: 'Go back home',
      primaryBtnText: 'Try again',
      description: 'Uh-oh! We don’t think that was a Givt coin',
      primaryLeftIcon: FontAwesomeIcons.arrowsRotate,
      amplitudeEvent: AmplitudeEvents.notAGivtCoinNFCErrorGoBackHomeClicked,
    );
    unawaited(
      AnalyticsHelper.logEvent(
        eventName: AmplitudeEvents.notAGivtCoinNFCErrorShown,
      ),
    );
  }

  void _navigateToHome(BuildContext context) {
    if (widget.isFromGenerosityChallenge) {
      context.goNamed(FamilyPages.generosityChallenge.name);
    } else {
      context.goNamed(FamilyPages.wallet.name);
    }
  }

  void _handleNotAGivtCoinTryAgainClicked(BuildContext context) {
    if (Platform.isAndroid) {
      //pop bottom sheet
      context.pop();
    }
    // pop this dialog
    context.pop();
    context.read<ScanNfcCubit>().readTag();
    unawaited(
      AnalyticsHelper.logEvent(
        eventName: AmplitudeEvents.notAGivtCoinNFCErrorTryAgainClicked,
      ),
    );
  }

  void _showGenericErrorDialog(BuildContext context) {
    SomethingWentWrongDialog.show(
      context,
      showLoadingState: true,
      onClickPrimaryBtn: () async =>
          _handleGenericErrorTryAgainClicked(context),
      onClickSecondaryBtn: () {
        _navigateToHome(context);
      },
      secondaryBtnText: 'Go back home',
      primaryBtnText: 'Try again',
      primaryLeftIcon: FontAwesomeIcons.arrowsRotate,
      amplitudeEvent:
          AmplitudeEvents.coinMediumIdNotRecognizedGoBackHomeClicked,
    );
    unawaited(
      AnalyticsHelper.logEvent(
        eventName: AmplitudeEvents.coinMediumIdNotRecognized,
      ),
    );
  }

  Future<void> _handleGenericErrorTryAgainClicked(BuildContext context) async {
    final state = context.read<ScanNfcCubit>().state;
    final success = await context
        .read<OrganisationDetailsCubit>()
        .getOrganisationDetails(state.mediumId);

    if (success) {
      _handleScanSuccess(context, state);
    }
    unawaited(
      AnalyticsHelper.logEvent(
        eventName: AmplitudeEvents.coinMediumIdNotRecognizedTryAgainClicked,
      ),
    );
  }
}
