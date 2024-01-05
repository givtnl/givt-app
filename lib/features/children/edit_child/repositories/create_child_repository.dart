import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/children/edit_child/models/edit_child.dart';

mixin EditChildRepository {
  Future<bool> editChild(String childGUID, EditChild child);
}

class EditChildRepositoryImpl with EditChildRepository {
  EditChildRepositoryImpl(this.apiService);
  final APIService apiService;

  @override
  Future<bool> editChild(String childGUID, EditChild child) async {
    final response = await apiService.editChild(childGUID, child.toJson());
    return response;
  }
}
