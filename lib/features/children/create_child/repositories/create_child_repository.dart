import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/children/create_child/models/child.dart';
import 'package:givt_app/features/children/edit_child/models/edit_child.dart';

mixin CreateChildRepository {
  Future<bool> createChild(Child child);
  Future<bool> editChild(String childGUID, EditChild child);
}

class CreateChildRepositoryImpl with CreateChildRepository {
  CreateChildRepositoryImpl(this.apiService);
  final APIService apiService;

  @override
  Future<bool> createChild(Child child) async {
    final response = await apiService.createChild(child.toJson());
    return response;
  }

  @override
  Future<bool> editChild(String childGUID, EditChild child) async {
    final response = await apiService.editChild(childGUID, child.toJson());
    return response;
  }
}
