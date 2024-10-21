import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';

sealed class InterviewUIModel {
  const InterviewUIModel();

  const factory InterviewUIModel.recordAnswer(
      {required String question,
      required String buttonText,
      required GameProfile reporter}) = RecordAnswerUIModel;

  const factory InterviewUIModel.passThePhone({required GameProfile reporter}) =
      PassThePhoneUIModel;
}

class RecordAnswerUIModel extends InterviewUIModel {
  const RecordAnswerUIModel({
    required this.question,
    required this.buttonText,
    required this.reporter,
  });

  final String question;
  final String buttonText;
  final GameProfile reporter;
}

class PassThePhoneUIModel extends InterviewUIModel {
  const PassThePhoneUIModel({
    required this.reporter,
  });

  final GameProfile reporter;
}