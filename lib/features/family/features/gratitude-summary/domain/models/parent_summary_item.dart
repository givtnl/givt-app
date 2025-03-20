import 'package:givt_app/features/family/features/gratitude-summary/presentation/models/parent_summary_uimodel.dart';
import 'package:givt_app/features/family/features/profiles/models/profile.dart';

class ParentSummaryItem {
  ParentSummaryItem({
    this.conversations = const [],
    this.audio,
    this.date,
  });

  factory ParentSummaryItem.fromMap(Map<String, dynamic> map) {
    final conversations = map['conversations'] as List<dynamic>?;
    final audio = map['audio'] as String?;
    final date = DateTime.tryParse(map['date'] as String? ?? '');
    return ParentSummaryItem(
      conversations: conversations
              ?.map((e) => Conversation.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      audio: audio,
      date: date,
    );
  }

  final List<Conversation> conversations;
  final String? audio;
  final DateTime? date;

  bool isEmpty() => conversations.isEmpty;

  SummaryUIModel toUIModel() {
    return SummaryUIModel(
      conversations: conversations.map((e) => e.toUIModel()).toList(),
      audioLink: audio,
      date: date?.toLocal(),
    );
  }
}

class Conversation {
  Conversation({
    required this.sentence,
    required this.profile,
  });

  factory Conversation.fromMap(Map<String, dynamic> map) {
    final sentence = map['sentence'] as String? ?? '';
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
      profile: profile,
    );
  }
}
