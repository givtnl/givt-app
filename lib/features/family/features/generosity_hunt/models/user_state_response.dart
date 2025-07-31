class UserStateResponse {
  final UserStateItem? item;

  const UserStateResponse({required this.item});

  factory UserStateResponse.fromJson(Map<String, dynamic> json) {
    return UserStateResponse(
      item: json['item'] != null 
          ? UserStateItem.fromJson(json['item'] as Map<String, dynamic>)
          : null,
    );
  }
}

class UserStateItem {
  final String gameGuid;
  final int currentLevel;
  final bool isCompleted;

  const UserStateItem({
    required this.gameGuid,
    required this.currentLevel,
    required this.isCompleted,
  });

  factory UserStateItem.fromJson(Map<String, dynamic> json) {
    return UserStateItem(
      gameGuid: json['gameGuid'] as String? ?? '',
      currentLevel: json['level'] as int? ?? 1,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
} 