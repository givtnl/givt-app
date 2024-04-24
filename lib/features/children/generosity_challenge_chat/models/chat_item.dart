import 'package:equatable/equatable.dart';

class ChatItem extends Equatable {
  ChatItem({required this.testString, required this.testNum});

  final String testString;
  final int testNum;

  ChatItem copyWith({
    String? testString,
    int? testNum,
  }) {
    return ChatItem(
      testString: testString ?? this.testString,
      testNum: testNum ?? this.testNum,
    );
  }

  @override
  List<Object> get props => [testString, testNum];
}
