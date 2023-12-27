import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/features/children/overview/widgets/no_children_page.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/features/registration/cubit/stripe_cubit.dart';
import 'package:go_router/go_router.dart';

class CreditCardDetailsPage extends StatefulWidget {
  const CreditCardDetailsPage({super.key});

  @override
  State<CreditCardDetailsPage> createState() => _CreditCardDetailsPageState();
}

class _CreditCardDetailsPageState extends State<CreditCardDetailsPage> {
  bool browserIsClosed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<StripeCubit, StripeState>(
        builder: (_, state) {
          final response = state.stripeObject;

          if (state.stripeStatus == StripeObjectStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.stripeStatus == StripeObjectStatus.failure) {
            return const Center(child: Text('Could not connect to Stripe'));
          }

          return browserIsClosed
              ? SafeArea(
                  child: NoChildrenPage(
                    onAddNewChildPressed: () {},
                  ),
                )
              : Padding(
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
                        context
                            .read<StripeCubit>()
                            .stripeRegistrationComplete();
                        context
                            .read<RegistrationBloc>()
                            .add(const RegistrationStripeSuccess());
                        setState(() {
                          browserIsClosed = true;
                        });
                        showDialog<void>(
                          context: context,
                          builder: (_) => CupertinoAlertDialog(
                            title: Text('You are registered!',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    )),
                            content: Text(
                              'You can now donate. Set up your family for Givt4Kids?',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => context
                                  ..pop()
                                  ..goNamed(Pages.home.name),
                                child: Text(
                                  'Not right now',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(fontSize: 17),
                                ),
                              ),
                              TextButton(
                                onPressed: () => context
                                  ..pop()
                                  ..goNamed(Pages.childrenOverview.name),
                                child: Text(
                                  "Set up family",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
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
    );
  }
}
