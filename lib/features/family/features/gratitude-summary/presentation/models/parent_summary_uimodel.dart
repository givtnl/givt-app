import 'package:givt_app/features/family/features/profiles/models/profile.dart';

class SummaryUIModel {
  SummaryUIModel({
    required this.conversations,
    this.audioLink,
    this.date,
  });
  final List<ConversationUIModel> conversations;
  final String? audioLink;
  final DateTime? date;
}

class ConversationUIModel {
  ConversationUIModel({
    required this.sentence,
    required this.profile,
  });
  final String sentence;
  final Profile profile;
}
