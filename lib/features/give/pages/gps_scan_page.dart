import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/give/bloc/bloc.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';

class GPSScanPage extends StatefulWidget {
  const GPSScanPage({super.key});

  @override
  State<GPSScanPage> createState() => _GPSScanPageState();
}

class _GPSScanPageState extends State<GPSScanPage> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(locals.selectLocationContext),
      ),
      body: Center(
        child: BlocConsumer<GiveBloc, GiveState>(
          listener: (context, state) {},
          builder: (context, state) {
            var orgName = state.organisation.organisationName;
            orgName ??= '';
            return Column(
              children: [
                const SizedBox(height: 50),
                Text(
                  locals.searchingEventText,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    'assets/images/givy_lookout.png',
                    width: 200,
                    height: 200,
                  ),
                ),
                Expanded(child: Container()),
                Visibility(
                  visible: _isVisible,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                      onPressed: () {
                        if (orgName!.isNotEmpty) {
                          context.read<GiveBloc>().add(
                                GiveToLastOrganisation(
                                  (context.read<AuthCubit>().state
                                          as AuthSuccess)
                                      .user
                                      .guid,
                                ),
                              );
                          return;
                        }
                        context.goNamed(
                          Pages.giveByList.name,
                          extra: context.read<GiveBloc>(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.givtBlue,
                      ),
                      child: Text(
                        orgName.isEmpty
                            ? locals.giveDifferently
                            : locals.giveToNearestBeacon(
                                state.organisation.organisationName!,
                              ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: _isVisible && orgName.isNotEmpty,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 10,
                    ),
                    child: TextButton(
                      onPressed: () => context.goNamed(
                        Pages.giveByList.name,
                        extra: context.read<GiveBloc>(),
                      ),
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      child: Text(locals.giveDifferently),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
