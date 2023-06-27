import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/give/widgets/choose_amount.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/bloc/remote_data_source_sync/remote_data_source_sync_bloc.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/shared/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({required this.code, super.key});

  final String code;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locals = AppLocalizations.of(context);
    final auth = context.read<AuthCubit>().state as AuthSuccess;
    log('HomePage: $code');
    return Scaffold(
      appBar: AppBar(
        title: Text(locals.amount),
        actions: [
          IconButton(
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              showDragHandle: true,
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              builder: (_) => const FAQBottomSheet(),
            ),
            icon: const Icon(
              Icons.question_mark_outlined,
              size: 26,
            ),
          ),
        ],
      ),
      drawer: const CustomNavigationDrawer(),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            BlocConsumer<RemoteDataSourceSyncBloc, RemoteDataSourceSyncState>(
              listener: (context, state) {
                if (state is RemoteDataSourceSyncSuccess && kDebugMode) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Synced successfully'),
                    ),
                  );
                }
                if (state is RemoteDataSourceSyncInProgress) {
                  if (!auth.user.needRegistration || auth.user.mandateSigned) {
                    return;
                  }
                  _buildNeedsRegistrationDialog(context);
                }
              },
              builder: (context, state) {
                return ChooseAmount(
                  country: auth.user.country,
                  amountLimit: auth.user.amountLimit,
                  onAmountChanged:
                      (firstCollection, secondCollection, thirdCollection) {
                    context.goNamed(
                      Pages.selectGivingWay.name,
                      extra: {
                        'firstCollection': firstCollection,
                        'secondCollection': secondCollection,
                        'thirdCollection': thirdCollection,
                        'code': code,
                      },
                    );
                    return true;
                  },
                );
              },
            ),
            ColoredBox(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 15,
                  left: 15,
                  bottom: 10,
                ),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: size.width * 0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _buildNeedsRegistrationDialog(
    BuildContext context,
  ) {
    final user = (context.read<AuthCubit>().state as AuthSuccess).user;
    return showDialog<void>(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text(context.l10n.importantReminder),
        content: Text(context.l10n.finalizeRegistrationPopupText),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(context.l10n.askMeLater),
          ),
          TextButton(
            onPressed: () {
              if (user.needRegistration) {
                context.goNamed(
                  Pages.registration.name,
                  queryParameters: {
                    'email': user.email,
                  },
                );
                return;
              }
              context.goNamed('mandate-explanation');
            },
            child: Text(
              context.l10n.finalizeRegistration,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
