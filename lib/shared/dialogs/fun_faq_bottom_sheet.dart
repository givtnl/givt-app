import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/features/family/shared/design/components/overlays/fun_bottom_sheet.dart';
import 'package:givt_app/features/family/shared/widgets/texts/texts.dart';
import 'package:givt_app/features/family/utils/fun_theme_legacy.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:go_router/go_router.dart';

class FunFAQBottomSheet extends StatelessWidget {
  const FunFAQBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final userCountry = context.read<AuthCubit>().state.user.country;
    final isUs = userCountry == Country.us.countryCode;
    final isUk = Country.unitedKingdomCodes().contains(userCountry);

    return FunBottomSheet(
      title: locals.needHelpTitle,
      closeAction: () => context.pop(),
      content: Column(
        children: [
          BodyMediumText(
            locals.findAnswersToYourQuestions,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          _buildQuestionTile(
            question: locals.feedbackTitle,
            answer: isUs ? locals.faQantwoord0Us : locals.faQantwoord0,
          ),
          _buildQuestionTile(
            question: locals.faqHowDoesGivingWork,
            answer: locals.answerHowDoesGivingWork,
          ),
          _buildQuestionTile(
            question: locals.faqQuestion14,
            answer: locals.faqAnswer14,
          ),
          _buildQuestionTile(
            question: locals.faqWhyBluetoothEnabledQ,
            answer: locals.faqWhyBluetoothEnabledA,
          ),
          _buildQuestionTile(
            question: locals.faqHowDoesManualGivingWork,
            answer: locals.answerHowDoesManualGivingWork,
          ),
          _buildQuestionTile(
            question: locals.kerkdienstGemistQuestion,
            answer: locals.kerkdienstGemistAnswer,
          ),
          _buildQuestionTile(
            question: locals.faqVraag16,
            answer: locals.faqAntwoord16,
          ),
          if (isUk)
            _buildQuestionTile(
              question: locals.faqQuestion12,
              answer: locals.faqAnswer12Gb,
            ),
          if (!isUs && !isUk)
            _buildQuestionTile(
              question: locals.faqQuestion12,
              answer: locals.faqAnswer12,
            ),
          _buildQuestionTile(
            question: locals.faQvraag9,
            answer: locals.faQantwoord9,
          ),
          if (isUk)
            _buildQuestionTile(
              question: locals.faQvraag15Gb,
              answer: locals.faQantwoord15Gb,
            ),
          if (!isUs && !isUk)
            _buildQuestionTile(
              question: locals.faQvraag15,
              answer: locals.faQantwoord15,
            ),
          if (isUk)
            _buildQuestionTile(
              question: locals.questionHowDoesRegisteringWorks,
              answer: locals.answerHowDoesRegistrationWorkGb,
            ),
          if (!isUs && !isUk)
            _buildQuestionTile(
              question: locals.questionHowDoesRegisteringWorks,
              answer: locals.answerHowDoesRegistrationWork,
            ),
          _buildQuestionTile(
            question: locals.faQvraag1,
            answer: locals.faQantwoord1,
          ),
          _buildQuestionTile(
            question: locals.faQvraag2,
            answer: locals.faQantwoord2,
          ),
          _buildQuestionTile(
            question: locals.faQvraag3,
            answer: locals.faQantwoord3,
          ),
          _buildQuestionTile(
            question: locals.faQvraag4,
            answer: locals.faQantwoord4,
          ),
          if (isUk)
            _buildQuestionTile(
              question: locals.faQvraag5,
              answer: locals.faQantwoord5Gb,
            ),
          if (!isUs && !isUk)
            _buildQuestionTile(
              question: locals.faQvraag5,
              answer: locals.faQantwoord5,
            ),
          _buildQuestionTile(
            question: locals.faQvraag6,
            answer: locals.faQantwoord6,
          ),
          if (isUk)
            _buildQuestionTile(
              question: locals.faQvraag7,
              answer: locals.faQantwoord7Gb,
            ),
          if (!isUk && !isUs)
            _buildQuestionTile(
              question: locals.faQvraag7,
              answer: locals.faQantwoord7,
            ),
          _buildQuestionTile(
            question: locals.faQvraag8,
            answer: locals.faQantwoord8,
          ),
          _buildQuestionTile(
            question: locals.faqVraag10,
            answer: locals.faqAntwoord10,
          ),
          _buildQuestionTile(
            question: locals.faqQuestion11,
            answer: locals.faqAnswer11,
          ),
          _buildQuestionTile(
            question: locals.questionWhyAreMyDataStored,
            answer: locals.answerWhyAreMyDataStored,
          ),
          if (isUk)
            _buildQuestionTile(
              question: locals.faqVraagDdi,
              answer: locals.faqAntwoordDdi,
            ),
          _buildQuestionTile(
            question: locals.termsTitle,
            answer: isUs
                ? locals.termsTextUs
                : isUk
                    ? locals.termsTextGb
                    : locals.termsText,
          ),
          _buildQuestionTile(
            question: locals.privacyTitle,
            answer: isUs
                ? locals.policyTextUs
                : isUk
                    ? locals.policyTextGb
                    : locals.policyText,
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionTile({
    required String question,
    required String answer,
  }) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: FamilyAppTheme.neutralVariant90,
          ),
        ),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(vertical: 8),
        title: LabelLargeText(
          question,
          color: FamilyAppTheme.primary20,
        ),
        collapsedIconColor: FamilyAppTheme.primary20,
        iconColor: FamilyAppTheme.primary20,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
            child: BodySmallText(
              answer,
              color: FamilyAppTheme.primary20,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  void show(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      builder: (context) => this,
    );
  }
}

