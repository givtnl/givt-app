import 'package:givt_app/features/family/features/profiles/models/profile.dart';

class GameSummaryItem {
  const GameSummaryItem({
    required this.id,
    required this.date,
    required this.players,
  });

  factory GameSummaryItem.fromMap(
      Map<String, dynamic> map, List<Profile> profiles) {
    final id = map['id'] as String;
    final date =
        DateTime.tryParse(map['createdDate'] as String) ?? DateTime.now();
    final playerGuids =
        (map['profiles'] as List<dynamic>).map((e) => e as String).toList();
    final players =
        profiles.where((element) => playerGuids.contains(element.id)).toList();
    return GameSummaryItem(
      id: id,
      date: date,
      players: players,
    );
  }

  final String id;
  final DateTime date;
  final List<Profile> players;
}
