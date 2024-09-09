import 'package:givt_app/features/family/features/reflect/domain/models/game_profile.dart';

class RecordAnswerUIModel {
  const RecordAnswerUIModel({
    required this.question,
    required this.buttonText,
    required this.reporter,
  });

  final String question;
  final String buttonText;
  final GameProfile reporter;
}
