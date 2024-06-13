import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/family/app/pages.dart';
import 'package:givt_app/features/family/features/coin_flow/widgets/search_coin_animated_widget.dart';
import 'package:givt_app/features/family/features/giving_flow/organisation_details/cubit/organisation_details_cubit.dart';
import 'package:givt_app/features/family/features/scan_nfc/cubit/scan_nfc_cubit.dart';
import 'package:givt_app/features/family/features/scan_nfc/widgets/android_nfc_found_bottomsheet.dart';
import 'package:givt_app/features/family/features/scan_nfc/widgets/android_nfc_not_available_sheet.dart';
import 'package:givt_app/features/family/features/scan_nfc/widgets/android_nfc_scanning_bottomsheet.dart';
import 'package:givt_app/features/family/features/scan_nfc/widgets/start_scan_nfc_button.dart';
import 'package:givt_app/features/family/shared/widgets/givt_back_button.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';

class NFCScanPage extends StatefulWidget {
  const NFCScanPage({super.key,});

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
    return BlocConsumer<ScanNfcCubit, ScanNfcState>(
      listener: (context, state) {
        final scanNfcCubit = context.read<ScanNfcCubit>();
        if (state.scanNFCStatus == ScanNFCStatus.scanning &&
            Platform.isAndroid) {
          showModalBottomSheet<void>(
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
                        return ScanningNfcAnimation(scanNfcCubit: scanNfcCubit);
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
          context.pop();
          showModalBottomSheet<void>(
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
          context
              .read<OrganisationDetailsCubit>()
              .getOrganisationDetails(state.mediumId);
          // Android needs the delay to show the success bottom sheet animation
          // iOS needs this delay to allow for the bottomsheet to close
          Future.delayed(ScanNfcCubit.animationDuration, () {

            context.pushReplacementNamed(FamilyPages.chooseAmountSlider.name);

            AnalyticsHelper.logEvent(
              eventName: AmplitudeEvents.inAppCoinScannedSuccessfully,
              eventProperties: {
                AnalyticsHelper.mediumIdKey: state.mediumId,
              },
            );
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: GivtBackButton(
              onPressedExt: () {
                context.read<ScanNfcCubit>().cancelScanning();
              },
            ),
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
    );
  }
}
