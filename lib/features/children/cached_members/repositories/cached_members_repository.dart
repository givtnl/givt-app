import 'dart:async';
import 'dart:convert';

import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/features/children/add_member/models/member.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin CachedMembersRepository {
  Future<void> saveToCache(List<Member> members);

  Future<List<Member>> loadFromCache();

  Future<void> clearCache();

  bool isCacheExist();

  Stream<List<Member>> onCachedMembersChanged();
}

class CachedMembersRepositoryImpl with CachedMembersRepository {
  CachedMembersRepositoryImpl(
    this.apiService,
    this.sharedPreferences,
  );

  final StreamController<List<Member>> _cachedMembersStreamController =
      StreamController<List<Member>>.broadcast();
  static const String _cachedMembersKey = 'cachedMembers';

  final APIService apiService;
  final SharedPreferences sharedPreferences;

  @override
  Future<void> saveToCache(List<Member> members) async {
    final membersJsonList = members.map((member) => member.toJson()).toList();

    await sharedPreferences.setString(
      _cachedMembersKey,
      jsonEncode(membersJsonList),
    );

    _cachedMembersStreamController.add(members);
  }

  @override
  Future<List<Member>> loadFromCache() async {
    final encodedString = sharedPreferences.getString(_cachedMembersKey) ?? '';
    if (encodedString.isNotEmpty) {
      final result = (jsonDecode(encodedString) as List<dynamic>)
          .map<Member>(
            (member) => Member.fromJson(member as Map<String, dynamic>),
          )
          .toList();
      return result;
    } else {
      return [];
    }
  }

  @override
  Future<void> clearCache() async {
    await sharedPreferences.remove(_cachedMembersKey);
    _cachedMembersStreamController.add([]);
  }

  @override
  bool isCacheExist() {
    return sharedPreferences.containsKey(_cachedMembersKey);
  }

  @override
  Stream<List<Member>> onCachedMembersChanged() =>
      _cachedMembersStreamController.stream;
}
