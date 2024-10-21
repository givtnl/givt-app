import 'package:givt_app/core/logging/logging.dart';
import 'package:givt_app/features/family/features/avatars/models/avatar.dart';
import 'package:givt_app/features/family/network/api_service.dart';

mixin AvatarsRepository {
  Future<List<Avatar>> fetchAvatars();
}

class AvatarsRepositoryImpl with AvatarsRepository {
  AvatarsRepositoryImpl(
    this._apiService,
  ) {
    _init();
  }

  final FamilyAPIService _apiService;

  List<Avatar>? _avatars;

  Future<void> _init() async {
    try {
      _avatars = await fetchAvatars();
    } catch (e, s) {
      LoggingInfo.instance.logExceptionForDebug(e, stacktrace: s);
    }
  }

  @override
  Future<List<Avatar>> fetchAvatars() async {
    if (true == _avatars?.isNotEmpty) {
      return _avatars!;
    }
    final response = await _apiService.fetchAvatars();

    final result = <Avatar>[];

    for (final avatarMap in response) {
      result.add(Avatar.fromMap(avatarMap as Map<String, dynamic>));
    }
    return result;
  }
}
