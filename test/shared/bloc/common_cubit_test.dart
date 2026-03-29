import 'package:flutter_test/flutter_test.dart';
import 'package:givt_app/shared/bloc/base_state.dart';
import 'package:givt_app/shared/bloc/common_cubit.dart';

class _TestCubit extends CommonCubit<int, String> {
  _TestCubit() : super(const BaseState.initial());
}

void main() {
  group('CommonCubit closed-safe emits', () {
    test('emitClear does not throw after close', () async {
      final cubit = _TestCubit();
      await cubit.close();
      expect(cubit.emitClear, returnsNormally);
    });

    test('emitWithClear does not throw after close', () async {
      final cubit = _TestCubit();
      await cubit.close();
      expect(
        () => cubit.emitWithClear(const BaseState<int, String>.data(1)),
        returnsNormally,
      );
    });
  });
}
