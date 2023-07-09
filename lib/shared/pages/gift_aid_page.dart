import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/auth/widgets/widgets.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';

class GiftAidPage extends StatefulWidget {
  const GiftAidPage({
    required this.onGiftAidChanged,
    super.key,
  });

  final void Function(bool) onGiftAidChanged;

  @override
  State<GiftAidPage> createState() => _GiftAidPageState();
}

class _GiftAidPageState extends State<GiftAidPage> {
  bool useGiftAid = false;

  @override
  void initState() {
    super.initState();
    useGiftAid =
        (context.read<AuthCubit>().state as AuthSuccess).user.isGiftAidEnabled;
  }

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
              backgroundColor: AppTheme.givtBlue,
              builder: (_) => const TermsAndConditionsDialog(
                typeOfTerms: TypeOfTerms.giftAid,
              ),
            ),
            icon: const Icon(Icons.info),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          bottom: 30,
          left: 20,
          right: 20,
          top: 20,
        ),
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
              onPressed: () => widget.onGiftAidChanged(
                useGiftAid,
              ),
              child: Text(locals.save),
            ),
          ],
        ),
      ),
    );
  }
}
