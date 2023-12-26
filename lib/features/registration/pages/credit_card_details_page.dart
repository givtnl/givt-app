import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/features/registration/cubit/stripe_cubit.dart';
import 'package:go_router/go_router.dart';

class CreditCardDetailsPage extends StatelessWidget {
  const CreditCardDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: BlocBuilder<StripeCubit, StripeState>(
          builder: (_, state) {
            final response = state.stripeObject;

            if (state.stripeStatus == StripeObjectStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.stripeStatus == StripeObjectStatus.failure) {
              return const Center(child: Text('Could not connect to Stripe'));
            }

            return Padding(
              padding: const EdgeInsets.only(top: 30),
              child: InAppWebView(
                initialUrlRequest: URLRequest(
                  url: Uri.parse(
                    response.url,
                  ),
                ),
                onWebViewCreated: (controller) {
                  controller.loadUrl(
                    urlRequest: URLRequest(
                      url: Uri.parse(response.url),
                    ),
                  );
                },
                onLoadStart: (controller, url) {
                  if (url == Uri.parse(response.cancelUrl)) {
                    context.goNamed(Pages.home.name);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Registration cancelled'),
                      ),
                    );
                  } else if (url == Uri.parse(response.successUrl)) {
                    context.read<StripeCubit>().stripeRegistrationComplete();
                    context
                        .read<RegistrationBloc>()
                        .add(const RegistrationStripeSuccess());
                    showDialog<void>(
                      context: context,
                      builder: (_) => CupertinoAlertDialog(
                        title: Text('You are registered!'),
                        content: Text(
                            'You can now donate. Set up your family for Givt4Kids?'),
                        actions: [
                          TextButton(
                            onPressed: () => context
                              ..pop()
                              ..goNamed(Pages.home.name),
                            child: Text('Not right now'),
                          ),
                          TextButton(
                            onPressed: () => context
                              ..pop()
                              ..goNamed(Pages.childrenOverview.name),
                            child: Text(
                              "Set up family",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
