class ParentSummaryUIModel {

  ParentSummaryUIModel({
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
    required this.profilePicture,
    required this.profileName,
  });
  final String sentence;
  final String profilePicture;
  final String profileName;
}
