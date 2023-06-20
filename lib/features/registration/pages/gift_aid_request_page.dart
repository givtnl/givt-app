import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/widgets/widgets.dart';
import 'package:givt_app/features/registration/bloc/registration_bloc.dart';
import 'package:givt_app/l10n/l10n.dart';

class GiftAidRequestPage extends StatefulWidget {
  const GiftAidRequestPage({super.key});

  @override
  State<GiftAidRequestPage> createState() => _GiftAidRequestPageState();
}

class _GiftAidRequestPageState extends State<GiftAidRequestPage> {
  bool useGiftAid = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locals = context.l10n;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              showDragHandle: true,
              isScrollControlled: true,
              useSafeArea: true,
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              builder: (BuildContext context) => const TermsAndConditionsDialog(
                typeOfTerms: TypeOfTerms.giftAid,
              ),
            ),
            icon: const Icon(Icons.info),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocListener<RegistrationBloc, RegistrationState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) {
            if (state.status == RegistrationStatus.giftAidChanged) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            }
          },
          child: Column(
            children: [
              Align(
                child: Image.asset(
                  'assets/images/givy_gift_aid.png',
                  width: size.width * 0.4,
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    locals.giftAidSetting,
                  ),
                  CupertinoSwitch(
                    onChanged: (bool value) => setState(() {
                      useGiftAid = value;
                    }),
                    value: useGiftAid,
                  ),
                ],
              ),
              const Divider(),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      locals.giftAidInfo,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      locals.giftAidHeaderDisclaimer,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      locals.giftAidBodyDisclaimer,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => context
                    .read<RegistrationBloc>()
                    .add(RegistrationGiftAidChanged(
                      isGiftAidEnabled: useGiftAid,
                    )),
                child: Text(locals.save),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
