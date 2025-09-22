import 'package:givt_app/features/eu_profile_selection/models/eu_profile.dart';

class EuProfileSelectionUIModel {
  const EuProfileSelectionUIModel({
    required this.profiles,
    this.selectedProfileId,
    this.isLoading = false,
  });

  final List<EuProfile> profiles;
  final String? selectedProfileId;
  final bool isLoading;

  EuProfileSelectionUIModel copyWith({
    List<EuProfile>? profiles,
    String? selectedProfileId,
    bool? isLoading,
  }) {
    return EuProfileSelectionUIModel(
      profiles: profiles ?? this.profiles,
      selectedProfileId: selectedProfileId ?? this.selectedProfileId,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
