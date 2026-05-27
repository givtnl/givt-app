import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/app/routes/routes.dart';
import 'package:givt_app/core/enums/enums.dart';
import 'package:givt_app/features/account_details/manage_gift_aid/cubit/manage_gift_aid_cubit.dart';
import 'package:givt_app/features/account_details/manage_gift_aid/models/manage_gift_aid_ui_model.dart';
import 'package:givt_app/features/account_details/manage_gift_aid/widgets/gift_aid_deactivate_dialog.dart';
import 'package:givt_app/features/account_details/manage_gift_aid/widgets/manage_gift_aid_impact_section.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/components.dart';
import 'package:givt_app/features/family/shared/design/theme/fun_theme.dart';
import 'package:givt_app/features/family/shared/widgets/loading/custom_progress_indicator.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/registration/widgets/about_gift_aid_bottom_sheet.dart';
import 'package:givt_app/l10n/arb/app_localizations.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/models/analytics_event.dart';
import 'package:givt_app/shared/widgets/base/base_state_consumer.dart';
import 'package:givt_app/shared/widgets/fun_scaffold.dart';
import 'package:givt_app/utils/analytics_helper.dart';
import 'package:go_router/go_router.dart';

class ManageGiftAidPage extends StatefulWidget {
  const ManageGiftAidPage({super.key});

  @override
  State<ManageGiftAidPage> createState() => _ManageGiftAidPageState();
}

class _ManageGiftAidPageState extends State<ManageGiftAidPage> {
  bool _declarationChecked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthCubit>();
      final country = auth.state.user.country;
      if (!Country.unitedKingdomCodes().contains(country)) {
        context.pop();
        return;
      }
      context.read<ManageGiftAidCubit>().init(
        user: auth.state.user,
        // ignore: unnecessary_lambdas -- AuthCubit.refreshUser has named params
        refreshUser: () => auth.refreshUser(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final auth = context.watch<AuthCubit>();
    final country = auth.state.user.country;

    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (p, c) => p.user.isGiftAidEnabled != c.user.isGiftAidEnabled,
      listener: (context, state) {
        context.read<ManageGiftAidCubit>().syncUser(state.user);
      },
      child: BaseStateConsumer<ManageGiftAidUIModel, void>(
        cubit: context.read<ManageGiftAidCubit>(),
        onLoading: (context) => FunScaffold(
          appBar: FunTopAppBar(
            variant: FunTopAppBarVariant.white,
            title: locals.manageGiftAidTitle,
            leading: IconButton(
              icon: const FaIcon(FontAwesomeIcons.arrowLeft),
              onPressed: () => context.pop(),
            ),
          ),
          body: const Center(child: CustomCircularProgressIndicator()),
        ),
        onError: (context, message) => FunScaffold(
          appBar: FunTopAppBar(
            variant: FunTopAppBarVariant.white,
            title: locals.manageGiftAidTitle,
            leading: IconButton(
              icon: const FaIcon(FontAwesomeIcons.arrowLeft),
              onPressed: () => context.pop(),
            ),
          ),
          body: Center(child: BodyMediumText(message ?? '')),
        ),
        onData: (context, ui) {
          return FunScaffold(
            appBar: FunTopAppBar(
              variant: FunTopAppBarVariant.white,
              title: locals.manageGiftAidTitle,
              leading: IconButton(
                icon: const FaIcon(FontAwesomeIcons.arrowLeft),
                onPressed: () => context.pop(),
              ),
              actions: [
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.circleInfo),
                  onPressed: () {
                    AnalyticsHelper.logEvent(
                      eventName: AnalyticsEventName.manageGiftAidInfoClicked,
                    );
                    AboutGiftAidBottomSheet.show(context);
                  },
                ),
              ],
            ),
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TitleMediumText(
                              locals.manageGiftAidSectionTitle,
                            ),
                          ),
                          FunTag(
                            text: ui.isGiftAidEnabled
                                ? locals.manageGiftAidStatusActive
                                : locals.manageGiftAidStatusInactive,
                            variant: FunTagVariant.primary,
                            iconData: FontAwesomeIcons.solidFaceSmile,
                            iconSize: 12,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildIntro(context, locals),
                      const SizedBox(height: 24),
                      ManageGiftAidImpactSection(
                        scenario: ui.scenario,
                        displayYear: '${ui.displayYear}',
                        totalGiven: ui.totalGiven,
                        extraOrPotential: ui.extraOrPotentialAmount,
                        totalImpact: ui.totalImpactAmount,
                        isExpanded: ui.impactAccordionExpanded,
                        onHeaderTap: () => context
                            .read<ManageGiftAidCubit>()
                            .toggleImpactAccordion(),
                        countryCode: country,
                        locals: locals,
                      ),
                    ],
                  ),
                ),
                if (ui.isGiftAidEnabled)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 24),
                        const Expanded(child: SizedBox.shrink()),
                        FunButton(
                          variant: FunButtonVariant.secondary,
                          fullBorder: true,
                          onTap: () {
                            showGiftAidDeactivateDialog(
                              context: context,
                              onKeepActive: () {},
                              onTurnOff: () async {
                                final ok = await context
                                    .read<ManageGiftAidCubit>()
                                    .setGiftAidEnabled(enabled: false);
                                if (!context.mounted || !ok) return;
                                await context.pushNamed(
                                  Pages.giftAidDeactivatedSuccess.name,
                                );
                              },
                            );
                          },
                          text: locals.manageGiftAidDeactivate,
                          analyticsEvent: AnalyticsEvent(
                            AnalyticsEventName.manageGiftAidDeactivateClicked,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (!ui.isGiftAidEnabled)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 24),
                        const Expanded(child: SizedBox.shrink()),
                        _DeclarationBlock(
                          checked: _declarationChecked,
                          onChanged: ({bool? value}) => setState(
                            () => _declarationChecked = value ?? false,
                          ),
                          locals: locals,
                        ),
                        const SizedBox(height: 16),
                        FunButton(
                          onTap: _declarationChecked
                              ? () async {
                                  final ok = await context
                                      .read<ManageGiftAidCubit>()
                                      .setGiftAidEnabled(enabled: true);
                                  if (!context.mounted || !ok) return;
                                  await context.pushNamed(
                                    Pages.giftAidActivatedSuccess.name,
                                  );
                                  if (!context.mounted) return;
                                  context.read<ManageGiftAidCubit>().syncUser(
                                    context.read<AuthCubit>().state.user,
                                  );
                                  await context
                                      .read<ManageGiftAidCubit>()
                                      .reload();
                                }
                              : null,
                          isDisabled: !_declarationChecked,
                          text: locals.giftAidActivateButton,
                          analyticsEvent: AnalyticsEvent(
                            AnalyticsEventName
                                .manageGiftAidActivateForTaxYearClicked,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildIntro(BuildContext context, AppLocalizations locals) {
    final theme = FunTheme.of(context);
    final baseStyle = TextStyle(
      fontSize: 15,
      height: 1.4,
      color: theme.primary40,
    );
    return Text.rich(
      TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: locals.manageGiftAidIntroLead),
          TextSpan(
            text: locals.manageGiftAidIntroEmphasis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: locals.manageGiftAidIntroTail),
        ],
      ),
    );
  }
}

class _DeclarationBlock extends StatelessWidget {
  const _DeclarationBlock({
    required this.checked,
    required this.onChanged,
    required this.locals,
  });

  final bool checked;
  final void Function({bool? value}) onChanged;
  final AppLocalizations locals;

  @override
  Widget build(BuildContext context) {
    final theme = FunTheme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: checked,
            onChanged: (v) => onChanged(value: v),
            side: BorderSide(color: theme.neutralVariant60, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 28),
                child: BodySmallText(
                  locals.giftAidDeclarationText,
                  color: theme.primary30,
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  icon: FaIcon(
                    FontAwesomeIcons.circleInfo,
                    size: 16,
                    color: theme.primary20,
                  ),
                  onPressed: () {
                    AnalyticsHelper.logEvent(
                      eventName: AnalyticsEventName.manageGiftAidInfoClicked,
                    );
                    AboutGiftAidBottomSheet.show(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
