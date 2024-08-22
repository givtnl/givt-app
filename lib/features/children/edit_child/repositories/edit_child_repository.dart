import 'dart:async';

import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/children/edit_child/models/edit_child.dart';

mixin EditChildRepository {
  Future<bool> editChild(String childGUID, EditChild child);

  Future<bool> editChildAllowance(String childGUID, int allowance);

  Future<bool> topUpChild(String childGUID, int amount);

  Future<bool> cancelAllowance(String childGUID);

  Stream<String> childChangedStream();
}

class EditChildRepositoryImpl with EditChildRepository {
  EditChildRepositoryImpl(this.apiService);

  final APIService apiService;

  final StreamController<String> _childGUIDController =
      StreamController.broadcast();

  @override
  Future<bool> editChild(String childGUID, EditChild child) async {
    final response = await apiService.editChild(childGUID, child.toJson());
    _childGUIDController.add(childGUID);
    return response;
  }

  @override
  Future<bool> editChildAllowance(String childGUID, int allowance) async {
    final response = await apiService.editChildAllowance(childGUID, allowance);
    _addChildGuidEventAfterOneSecond(childGUID);
    return response;
  }

  @override
  Future<bool> topUpChild(String childGUID, int amount) async {
    final response = await apiService.topUpChild(childGUID, amount);
    _addChildGuidEventAfterOneSecond(childGUID);
    return response;
  }

  // The reason we are not immediately adding this event to the stream is
  // because money-related calls require an update from Stripe for the BE
  // which takes a bit of time
  void _addChildGuidEventAfterOneSecond(String childGUID) {
    Future.delayed(const Duration(seconds: 1), () {
      _childGUIDController.add(childGUID);
    });
  }

  @override
  Future<bool> cancelAllowance(String childGUID) async {
    final response = await apiService.cancelAllowance(childGUID);
    _addChildGuidEventAfterOneSecond(childGUID);
    return response;
  }

  @override
  Stream<String> childChangedStream() => _childGUIDController.stream;
}
