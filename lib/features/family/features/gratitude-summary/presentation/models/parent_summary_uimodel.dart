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
    required this.avatar,
    required this.profileName,
  });
  final String sentence;
  final String avatar;
  final String profileName;
}
