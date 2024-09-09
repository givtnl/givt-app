import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/core/enums/country.dart';
import 'package:givt_app/features/auth/cubit/auth_cubit.dart';
import 'package:givt_app/l10n/l10n.dart';
import 'package:givt_app/shared/widgets/widgets.dart';

class FAQBottomSheet extends StatelessWidget {
  const FAQBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final locals = context.l10n;
    final userCountry = context.read<AuthCubit>().state.user.country;
    final isUs = userCountry == Country.us.countryCode;
    final isUk = Country.unitedKingdomCodes().contains(userCountry);
    return BottomSheetLayout(
      title: Text(
        locals.needHelpTitle,
        style: const TextStyle(
          fontSize: 22,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backButtonColor: Colors.white,
      child: Column(
        children: [
          Text(
            locals.findAnswersToYourQuestions,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
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
                  // _buildQuestionTile(
                  //   question: locals.faQuestAnonymity,
                  //   answer: locals.faQanswerAnonymity,
                  // ),
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
            ),
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
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.2),
          ),
        ),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(5),
        title: Text(
          question,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        collapsedIconColor: Colors.white,
        iconColor: Colors.white,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
            child: Text(
              answer,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
