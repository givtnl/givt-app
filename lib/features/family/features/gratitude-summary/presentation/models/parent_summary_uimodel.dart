class ParentSummaryUIModel {

  ParentSummaryUIModel({
    required this.conversations,
    required this.audioLink,
  });
  final List<ConversationUIModel> conversations;
  final String audioLink;
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
