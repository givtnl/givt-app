import 'package:flutter/material.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/utils/app_theme.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

class SuccessOfflineDonationPage extends StatelessWidget {
  const SuccessOfflineDonationPage({
    required this.organisationName,
    super.key,
  });

  final String organisationName;

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.goNamed(Pages.home.name),
          icon: const Icon(Icons.close),
          color: Colors.transparent,
        ),
        title: Image.asset(
          'assets/images/logo.png',
          height: size.height * 0.04,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Spacer(),
            _buildText(locals, context),
            const Spacer(),
            Container(
              alignment: Alignment.bottomRight,
              child: Image.asset(
                'assets/images/givy_gave.png',
                scale: size.aspectRatio * 4,
              ),
            ),
            _buildButtons(context, locals),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context, AppLocalizations locals) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => context.goNamed(Pages.home.name),
          child: Text(locals.ready),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => Share.share(
            '${locals.shareTheGivtText(organisationName)} ${locals.joinGivt}',
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.givtBlue,
          ),
          child: Text(locals.shareTheGivtButton),
        ),
      ],
    );
  }

  Widget _buildText(AppLocalizations locals, BuildContext context) {
    return Column(
      children: [
        Text(
          locals.yesSuccess,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Text(
          locals.offlineGegevenGivtMessageWithOrg(organisationName),
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 16,
                wordSpacing: 1.5,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
