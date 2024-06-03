import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/unregister_account/cubit/unregister_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/dialogs/dialogs.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';

class UnregisterPage extends StatefulWidget {
  const UnregisterPage({super.key,});

  @override
  State<UnregisterPage> createState() => _UnregisterPageState();
}

class _UnregisterPageState extends State<UnregisterPage> {
  bool _acceptedTerms = false;
  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    return BlocConsumer<UnregisterCubit, UnregisterState>(
      listener: (context, state) {
        if (state is UnregisterNoInternet) {
          showDialog<void>(
            context: context,
            builder: (_) => WarningDialog(
              title: locals.noInternetConnectionTitle,
              content: locals.noInternet,
              onConfirm: () => context.pop(),
            ),
          );
        }
        if (state is UnregisterFailure) {
          showDialog<void>(
            context: context,
            builder: (_) => WarningDialog(
              title: locals.unregisterErrorTitle,
              content: locals.unregisterButton,
              onConfirm: () => context.pop(),
            ),
          ).whenComplete(
            () => context.pop(),
          );
        }
        if (state is UnregisterSuccess) {
          context.read<AuthCubit>().logout();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: state is UnregisterGivy
              ? null
              : AppBar(
                  title: Text(
                    locals.unregister,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
          body: Padding(
            padding: const EdgeInsets.only(
              bottom: 30,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: state is UnregisterGivy
                ? _buildSuccess(context)
                : _buildTerms(context, state is UnregisterLoading),
          ),
        );
      },
    );
  }

  Widget _buildSuccess(
    BuildContext context,
  ) {
    final locals = context.l10n;
    final size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          locals.unregisterSad,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 50,
        ),
        Center(
          child: Image.asset(
            'assets/images/givy_sad.png',
            height: size.height * 0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildTerms(
    BuildContext context,
    bool isLoading,
  ) {
    final locals = context.l10n;
    final size = MediaQuery.of(context).size;
    final email = context.read<AuthCubit>().state.user.email;
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Text(
          locals.unregisterInfo,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        Row(
          children: [
            Checkbox(
              value: _acceptedTerms,
              onChanged: (value) {
                setState(() {
                  _acceptedTerms = value!;
                });
              },
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: locals.unregisterUnderstood,
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
              textAlign: TextAlign.start,
            ),
          ],
        ),
        if (isLoading)
          const Center(
            child: CircularProgressIndicator(),
          )
        else
          SizedBox(
            width: size.width,
            child: ElevatedButton(
              onPressed: _acceptedTerms
                  ? () => context.read<UnregisterCubit>().unregister(
                        email: email,
                      )
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.givtRed,
                disabledBackgroundColor: Colors.grey,
              ),
              child: Text(locals.unregisterButton),
            ),
          ),
      ],
    );
  }
}
