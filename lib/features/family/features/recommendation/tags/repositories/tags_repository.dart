import 'package:givt_app/features/family/features/recommendation/tags/models/tag.dart';
import 'package:givt_app/features/family/network/api_service.dart';

mixin TagsRepository {
  Future<List<Tag>> fetchTags();
}

class TagsRepositoryImpl with TagsRepository {
  TagsRepositoryImpl(
    this._apiService,
  );

  final FamilyAPIService _apiService;

  @override
  Future<List<Tag>> fetchTags() async {
    final response = await _apiService.fetchTags();
    return response.map((e) => Tag.fromMap(e)).toList();
  }
}
