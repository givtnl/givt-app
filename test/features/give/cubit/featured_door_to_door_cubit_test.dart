import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/core/network/api_service.dart';
import 'package:givt_app/core/network/network_info.dart';
import 'package:givt_app/core/network/request_helper.dart';
import 'package:givt_app/features/give/cubit/featured_door_to_door_cubit.dart';
import 'package:givt_app/shared/models/featured_collect_group.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeNetworkInfo with NetworkInfo {
  _FakeNetworkInfo({required this.isConnected});

  @override
  bool isConnected;

  final _controller = StreamController<bool>.broadcast();

  /// Replays the current status, matching [NetworkInfoImpl].
  @override
  Stream<bool> hasInternetConnectionStream() {
    return Stream<bool>.multi((controller) {
      controller.add(isConnected);
      final subscription = _controller.stream.listen(
        controller.add,
        onError: controller.addError,
        onDone: controller.close,
      );
      controller
        ..onPause = subscription.pause
        ..onResume = subscription.resume
        ..onCancel = subscription.cancel;
    }).distinct();
  }

  void emitConnected(bool connected) {
    isConnected = connected;
    _controller.add(connected);
  }

  Future<void> dispose() => _controller.close();
}

class _FakeApiService extends APIService {
  _FakeApiService(
    RequestHelper requestHelper,
    this._fetch,
  ) : super(requestHelper);

  final Future<FeaturedCollectGroup?> Function() _fetch;
  int calls = 0;

  @override
  Future<FeaturedCollectGroup?> getFeaturedDoorToDoorCollectGroup() {
    calls++;
    return _fetch();
  }
}

Future<void> _settle() => Future<void>.delayed(Duration.zero);

void main() {
  const featured = FeaturedCollectGroup(
    nameSpace: 'givt.nl.cancsoc',
    logoUrl: 'https://example.com/logo.png',
  );

  group('FeaturedDoorToDoorCubit', () {
    late _FakeNetworkInfo networkInfo;
    late RequestHelper requestHelper;

    setUp(() async {
      networkInfo = _FakeNetworkInfo(isConnected: true);
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final preferences = await SharedPreferences.getInstance();
      requestHelper = RequestHelper(
        networkInfo,
        preferences,
        apiURL: 'api.example.com',
      );
    });

    tearDown(() async {
      await networkInfo.dispose();
    });

    test('loads featured group when fetch returns an item', () async {
      final cubit = FeaturedDoorToDoorCubit(
        _FakeApiService(requestHelper, () async => featured),
        networkInfo,
      );

      await _settle();

      expect(cubit.state.isVisible, isTrue);
      expect(cubit.state.featured, featured);
      await cubit.close();
    });

    test('hides when fetch returns null', () async {
      final cubit = FeaturedDoorToDoorCubit(
        _FakeApiService(requestHelper, () async => null),
        networkInfo,
      );

      await _settle();

      expect(cubit.state.isVisible, isFalse);
      expect(cubit.state.featured, isNull);
      await cubit.close();
    });

    test('hides when nameSpace is blank', () async {
      final cubit = FeaturedDoorToDoorCubit(
        _FakeApiService(
          requestHelper,
          () async => const FeaturedCollectGroup(
            nameSpace: '  ',
            logoUrl: 'https://example.com/logo.png',
          ),
        ),
        networkInfo,
      );

      await _settle();

      expect(cubit.state.isVisible, isFalse);
      await cubit.close();
    });

    test('hides when fetch throws', () async {
      final cubit = FeaturedDoorToDoorCubit(
        _FakeApiService(requestHelper, () async {
          throw Exception('network');
        }),
        networkInfo,
      );

      await _settle();

      expect(cubit.state.isVisible, isFalse);
      await cubit.close();
    });

    test('hides when offline without fetching', () async {
      networkInfo.isConnected = false;
      final api = _FakeApiService(requestHelper, () async => featured);
      final cubit = FeaturedDoorToDoorCubit(api, networkInfo);

      await _settle();

      expect(api.calls, 0);
      expect(cubit.state.isVisible, isFalse);
      await cubit.close();
    });

    test('hides when connectivity drops', () async {
      final cubit = FeaturedDoorToDoorCubit(
        _FakeApiService(requestHelper, () async => featured),
        networkInfo,
      );
      await _settle();
      expect(cubit.state.isVisible, isTrue);

      networkInfo.emitConnected(false);
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.isVisible, isFalse);
      await cubit.close();
    });

    test('ignores in-flight fetch after connectivity drops', () async {
      final inFlight = Completer<FeaturedCollectGroup?>();
      final cubit = FeaturedDoorToDoorCubit(
        _FakeApiService(requestHelper, () => inFlight.future),
        networkInfo,
      );

      networkInfo.emitConnected(false);
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state.isVisible, isFalse);

      inFlight.complete(featured);
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state.isVisible, isFalse);
      await cubit.close();
    });

    test('older fetch cannot overwrite a newer result', () async {
      final fetches = <Completer<FeaturedCollectGroup?>>[];
      final cubit = FeaturedDoorToDoorCubit(
        _FakeApiService(requestHelper, () {
          final completer = Completer<FeaturedCollectGroup?>();
          fetches.add(completer);
          return completer.future;
        }),
        networkInfo,
      );

      await _settle();
      expect(fetches, hasLength(1));
      unawaited(cubit.load());
      await _settle();
      expect(fetches, hasLength(2));

      fetches[1].complete(featured);
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state.isVisible, isTrue);

      fetches[0].complete(null);
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state.isVisible, isTrue);
      await cubit.close();
    });
  });
}
