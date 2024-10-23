import 'package:givt_app/features/family/features/avatars/models/avatar.dart';
import 'package:givt_app/features/family/network/family_api_service.dart';

mixin AvatarsRepository {
  Future<List<Avatar>> fetchAvatars();
}

class AvatarsRepositoryImpl with AvatarsRepository {
  AvatarsRepositoryImpl(
    this._apiService,
  );

  final FamilyAPIService _apiService;

  @override
  Future<List<Avatar>> fetchAvatars() async {
    final response = await _apiService.fetchAvatars();

    final result = <Avatar>[];

    for (final avatarMap in response) {
      result.add(Avatar.fromMap(avatarMap as Map<String, dynamic>));
    }
    return result;
  }
}
