import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/features/give/pages/home_page_qr_flow_handler.dart';
import 'package:givt_app/features/give/widgets/widgets.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({
    required this.initialAmount,
    required this.onPageChanged,
    required this.given,
    required this.retry,
    required this.afterGivingRedirection,
    required this.code,
    this.giveBloc,
    this.qrConfirmWidget,
    super.key,
  });

  final double? initialAmount;
  final bool given;
  final bool retry;
  final String code;
  final String afterGivingRedirection;
  final void Function(int) onPageChanged;
  final GiveBloc? giveBloc;
  final Widget? qrConfirmWidget;

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  late PageController pageController;
  int pageIndex = 0;
  bool isPageAnimationActive = false;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthCubit>().state;
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        HomePageViewLayout(
          child: PageView(
            controller: pageController,
            onPageChanged: onPageChanged,
            children: [
              ChooseAmount(
                initialAmount: (widget.giveBloc?.state.collections[0] ?? 0) > 0
                    ? widget.giveBloc!.state.collections[0]
                    : (widget.code.isEmpty ? widget.initialAmount : null),
                country: Country.fromCode(auth.user.country),
                amountLimit: auth.user.amountLimit,
                hasGiven: widget.given,
                retry: widget.retry,
                arePresetsEnabled: auth.presets.isEnabled,
                presets: auth.presets.presets,
                qrConfirmWidget: widget.qrConfirmWidget,
                onAmountChanged: (firstCollection, secondCollection, thirdCollection) async {
                  final currentState =
                      widget.giveBloc?.state ?? const GiveState();

                  final isQR = HomePageQRFlowHandler.isQRFlow(
                    currentState,
                    widget.code,
                    widget.giveBloc,
                  );

                  LoggingInfo.instance.info(
                    'HomePageView: onAmountChanged - '
                    'isQRFlow: $isQR, '
                    'status: ${currentState.status}, '
                    'hasOrg: ${currentState.organisation.mediumId?.isNotEmpty ?? false}, '
                    'orgName: ${currentState.organisation.organisationName}, '
                    'mediumId: ${currentState.organisation.mediumId}, '
                    'code: ${widget.code.isNotEmpty}, '
                    'codeValue: ${widget.code}, '
                    'hasTransactions: ${currentState.givtTransactions.isNotEmpty}, '
                    'transactionCount: ${currentState.givtTransactions.length}',
                  );

                  if (isQR) {
                    await HomePageQRFlowHandler.handleQRFlow(
                      context,
                      widget.giveBloc!,
                      firstCollection,
                      secondCollection,
                      thirdCollection,
                      widget.code,
                      widget.afterGivingRedirection,
                      () => mounted,
                    );
                  } else {
                    LoggingInfo.instance.info(
                      'HomePageView: Not QR flow, navigating to select giving way',
                    );
                    HomePageQRFlowHandler.navigateToSelectGivingWay(
                      context,
                      firstCollection,
                      secondCollection,
                      thirdCollection,
                      widget.code,
                      widget.afterGivingRedirection,
                    );
                  }
                },
              ),
              const ChooseCategory(),
            ],
          ),
        ),
        ColoredBox(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 15,
              left: 15,
              bottom: 5,
            ),
            child: AnimatedSwitch(
              pageIndex: pageIndex,
              onChanged: onPageChanged,
            ),
          ),
        ),
      ],
    );
  }

  void onPageChanged(int index) {
    if (index == pageIndex || isPageAnimationActive) {
      return;
    }
    setState(() {
      pageIndex = index;
      widget.onPageChanged(index);
    });

    setState(() {
      isPageAnimationActive = true;
    });

    pageController
        .animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        )
        .then(
          (_) {
            setState(() {
              isPageAnimationActive = false;
            });
          },
        );
  }
}
