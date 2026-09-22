import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/core/network/network_info.dart';
import 'package:givt_app/features/give/cubit/featured_door_to_door_cubit.dart';
import 'package:givt_app/shared/models/featured_collect_group.dart';

class _FakeNetworkInfo with NetworkInfo {
  _FakeNetworkInfo({required this.isConnected});

  @override
  bool isConnected;

  final _controller = StreamController<bool>.broadcast();

  @override
  Stream<bool> hasInternetConnectionStream() => _controller.stream;

  void emitConnected(bool connected) {
    isConnected = connected;
    _controller.add(connected);
  }

  Future<void> dispose() => _controller.close();
}

void main() {
  const featured = FeaturedCollectGroup(
    nameSpace: 'givt.nl.cancsoc',
    logoUrl: 'https://example.com/logo.png',
  );

  group('FeaturedDoorToDoorCubit', () {
    late _FakeNetworkInfo networkInfo;

    setUp(() {
      networkInfo = _FakeNetworkInfo(isConnected: true);
    });

    tearDown(() async {
      await networkInfo.dispose();
    });

    test('loads featured group when fetch returns an item', () async {
      final cubit = FeaturedDoorToDoorCubit(
        fetchFeatured: () async => featured,
        networkInfo: networkInfo,
      );

      await cubit.load();

      expect(cubit.state.isVisible, isTrue);
      expect(cubit.state.featured, featured);
      await cubit.close();
    });

    test('hides when fetch returns null', () async {
      final cubit = FeaturedDoorToDoorCubit(
        fetchFeatured: () async => null,
        networkInfo: networkInfo,
      );

      await cubit.load();

      expect(cubit.state.isVisible, isFalse);
      expect(cubit.state.featured, isNull);
      await cubit.close();
    });

    test('hides when nameSpace is blank', () async {
      final cubit = FeaturedDoorToDoorCubit(
        fetchFeatured: () async => const FeaturedCollectGroup(
          nameSpace: '  ',
          logoUrl: 'https://example.com/logo.png',
        ),
        networkInfo: networkInfo,
      );

      await cubit.load();

      expect(cubit.state.isVisible, isFalse);
      await cubit.close();
    });

    test('hides when fetch throws', () async {
      final cubit = FeaturedDoorToDoorCubit(
        fetchFeatured: () async {
          throw Exception('network');
        },
        networkInfo: networkInfo,
      );

      await cubit.load();

      expect(cubit.state.isVisible, isFalse);
      await cubit.close();
    });

    test('hides when offline', () async {
      networkInfo.isConnected = false;
      final cubit = FeaturedDoorToDoorCubit(
        fetchFeatured: () async => featured,
        networkInfo: networkInfo,
      );

      await cubit.load();

      expect(cubit.state.isVisible, isFalse);
      await cubit.close();
    });

    test('hides when connectivity drops', () async {
      final cubit = FeaturedDoorToDoorCubit(
        fetchFeatured: () async => featured,
        networkInfo: networkInfo,
      );
      await cubit.load();
      expect(cubit.state.isVisible, isTrue);

      networkInfo.emitConnected(false);
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.isVisible, isFalse);
      await cubit.close();
    });
  });
}
