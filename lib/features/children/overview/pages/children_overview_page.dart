import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:givt_app/app/routes/route_utils.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/children/overview/cubit/children_overview_cubit.dart';
import 'package:givt_app/features/children/overview/widgets/child_item.dart';
import 'package:givt_app/features/children/vpc/cubit/vpc_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/util.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ChildrenOverviewPage extends StatefulWidget {
  const ChildrenOverviewPage(
      {required this.showAllowanceDisclaimer, super.key});
  final bool showAllowanceDisclaimer;

  @override
  State<ChildrenOverviewPage> createState() => _ChildrenOverviewPageState();
}

class _ChildrenOverviewPageState extends State<ChildrenOverviewPage> {
  bool localShowAlloance = false;
  @override
  void initState() {
    localShowAlloance = widget.showAllowanceDisclaimer;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locals = AppLocalizations.of(context);

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 35),
        width: double.infinity,
        height: double.infinity,
        // color: Colors.amber,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                BackButton(),
                Expanded(
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/logo_blue.svg',
                      height: size.height * 0.035,
                    ),
                  ),
                ),
                const SizedBox(width: 32.0),
              ],
            ),
            if (localShowAlloance) _buildDisclaimer() else const SizedBox(),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child:
                    BlocConsumer<ChildrenOverviewCubit, ChildrenOverviewState>(
                  listener: (context, state) {
                    log('children overview state changed on $state');
                    if (state is ChildrenOverviewErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            state.errorMessage,
                            textAlign: TextAlign.center,
                          ),
                          backgroundColor: Theme.of(context).errorColor,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is ChildrenOverviewLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ChildrenOverviewUpdatedState) {
                      final user = context.read<AuthCubit>().state.user;
                      final currency = NumberFormat.simpleCurrency(
                        name: Util.getCurrencyName(
                          country: Country.fromCode(user.country),
                        ),
                      );

                      return SingleChildScrollView(
                        child: Column(
                          children: state.profiles
                              .map(
                                (profile) => ChildItem(
                                  name: profile.firstName,
                                  total: profile.wallet.balance,
                                  currencySymbol: currency.currencySymbol,
                                  pending: profile.wallet.pending,
                                ),
                              )
                              .toList(),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 35, right: 35, bottom: 30),
        child: ElevatedButton(
          onPressed: () {
            if (context.read<VPCCubit>().vpcGained) {
              context.goNamed(Pages.createChild.name);
            } else {
              context.goNamed(Pages.giveVPC.name);
            }
          },
          child: Text(
            locals.createChildAddProfileButton,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildDisclaimer() => Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: AppTheme.givtLightYellow,
                border: Border.all(
                  color: AppTheme.givtKidsYellow,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            margin:
                const EdgeInsets.only(bottom: 0, top: 10, left: 20, right: 20),
            child: Row(
              children: [
                const Icon(Icons.info, color: AppTheme.givtBlue, size: 30.0),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: RichText(
                    maxLines: 3,
                    overflow: TextOverflow.visible,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                            text: 'Cannot see the giving allowance? ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.givtBlue)),
                        TextSpan(
                            text:
                                'It can take a couple hours to be processed through our system.',
                            style: TextStyle(color: AppTheme.givtBlue)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 20,
            child: IconButton(
                padding: EdgeInsets.zero,
                alignment: Alignment.topCenter,
                onPressed: () => setState(() {
                      localShowAlloance = false;
                    }),
                icon: SvgPicture.asset(
                  'assets/images/notification_kids_allowance_dismiss.svg',
                  height: 24,
                )),
          ),
        ],
      );
}
