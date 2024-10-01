import 'package:collection/collection.dart';
import 'package:givt_app/features/auth/repositories/auth_repository.dart';
import 'package:givt_app/features/family/features/home_screen/presentation/models/navigation_bar_home_custom.dart';
import 'package:givt_app/features/family/features/profiles/repository/profiles_repository.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class NavigationBarHomeCubit
    extends CommonCubit<String?, NavigationBarHomeCustom> {
  NavigationBarHomeCubit(this._profilesRepository, this._authRepository)
      : super(const BaseState.initial());

  final ProfilesRepository _profilesRepository;
  final AuthRepository _authRepository;

  String? profilePictureUrl;

  void onDidChangeDependencies() {
    _getProfilePictureUrl();
  }

  Future<void> _getProfilePictureUrl() async {
    try {
      final profiles = await _profilesRepository.getProfiles();
      final session = await _authRepository.getStoredSession();
      final profile = profiles
          .firstWhereOrNull((element) => element.id == session?.userGUID);
      profilePictureUrl = profile?.pictureURL;
      _emitData();
    } catch (e, s) {
      _emitData();
    }
  }

  void _emitData() => emitData(profilePictureUrl);
}
