import 'package:givt_app/features/family/features/gratitude-summary/presentation/models/summary_uimodel.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';

class SummaryItem {

  SummaryItem({
    required this.conversations,
    required this.audio,
  });

  factory SummaryItem.fromMap(Map<String, dynamic> map) {
    final conversations = map['conversations'] as List<Map<String, dynamic>>;
    final audio = map['audio'] as String;
    return SummaryItem(
        conversations: conversations.map(Conversation.fromMap).toList(),
      audio: audio,
    );
  }
  final List<Conversation> conversations;
  final String audio;

  SummaryUIModel toUIModel() {
    return SummaryUIModel(
      conversations: conversations.map((e) => e.toUIModel()).toList(),
      audioLink: audio,
    );
  }
}

class Conversation {

  Conversation({
    required this.sentence,
    required this.profile,
  });

  factory Conversation.fromMap(Map<String, dynamic> map) {
    final sentence = map['sentence'] as String;
    final profile = Profile.fromMap(map['profile'] as Map<String, dynamic>);
    return Conversation(
      sentence: sentence,
      profile: profile,
    );
  }
  final String sentence;
  final Profile profile;
  
  ConversationUIModel toUIModel() {
    return ConversationUIModel(
      sentence: sentence,
      profilePicture: profile.pictureURL,
      profileName: profile.firstName,
    );
  }
}
