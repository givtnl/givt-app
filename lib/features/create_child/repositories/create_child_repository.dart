import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/create_child/models/child.dart';

mixin CreateChildRepository {
  Future<bool> createChild(Child child);
}

class CreateChildRepositoryImpl with CreateChildRepository {
  CreateChildRepositoryImpl(this.apiService);
  final APIService apiService;

  @override
  Future<bool> createChild(Child child) async {
    final response = await apiService.createChild(child.toJson());
    return response;
  }
}
