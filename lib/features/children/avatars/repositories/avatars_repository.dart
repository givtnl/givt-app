import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/children/avatars/models/avatar.dart';

mixin AvatarsRepository {
  Future<List<Avatar>> fetchAvatars();
}

class AvatarsRepositoryImpl with AvatarsRepository {
  AvatarsRepositoryImpl(
    this._apiService,
  );

  final APIService _apiService;

  @override
  Future<List<Avatar>> fetchAvatars() async {
    final response =
        await _apiService.fetchAvatars() as List<Map<String, dynamic>>;

    final result = <Avatar>[];

    for (final avatarMap in response) {
      result.add(Avatar.fromMap(avatarMap));
    }
    return result;
  }
}
