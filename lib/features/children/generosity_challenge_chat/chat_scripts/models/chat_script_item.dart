import 'package:equatable/equatable.dart';

import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/enums/chat_script_input_answer_type.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/enums/chat_script_item_media_source_type.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/enums/chat_script_item_side.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/enums/chat_script_item_type.dart';

class ChatScriptItem extends Equatable {
  const ChatScriptItem({
    required this.type,
    required this.side,
    required this.text,
    required this.path,
    required this.amplitudeEvent,
    required this.functionName,
    required this.answerText,
    required this.hidden,
    required this.options,
    required this.inputAnswerType,
    required this.mediaSourceType,
    required this.saveKey,
    required this.saveInAmplitude,
    this.next,
    this.postChat,
  });

  factory ChatScriptItem.fromBranchesMap(Map<String, dynamic> branchesMap) {
    final mainBranch = branchesMap['main'] as Map<String, dynamic>;
    final mainItem =
        ChatScriptItem.fromMap(mainBranch, branchesMap: branchesMap);
    final postChatItem = branchesMap['postChat'] != null
        ? ChatScriptItem.fromMap(
            branchesMap['postChat'] as Map<String, dynamic>,
            branchesMap: branchesMap,
          )
        : null;

    return mainItem.copyWith(postChat: postChatItem);
  }

  factory ChatScriptItem.fromMap(
    Map<String, dynamic> map, {
    Map<String, dynamic>? branchesMap,
  }) {
    return ChatScriptItem(
      type: ChatScriptItemType.fromString((map['type'] ?? '').toString()),
      side: ChatScriptItemSide.fromString((map['side'] ?? '').toString()),
      text: (map['text'] ?? '').toString(),
      path: (map['path'] ?? '').toString(),
      amplitudeEvent: (map['amplitudeEvent'] ?? '').toString(),
      functionName: (map['functionName'] ?? '').toString(),
      answerText: (map['answerText'] ?? '').toString(),
      hidden: map['hidden'] != null && map['hidden'] == true,
      options: map['options'] != null
          ? List<ChatScriptItem>.from(
              (map['options'] as List<dynamic>).map<ChatScriptItem>((option) {
                return ChatScriptItem.fromMap(
                  option as Map<String, dynamic>,
                  branchesMap: branchesMap,
                );
              }),
            )
          : [],
      inputAnswerType: ChatScriptInputAnswerType.fromString(
        (map['inputAnswerType'] ?? '').toString(),
      ),
      mediaSourceType: ChatScriptItemMediaSourceType.fromString(
        (map['mediaSourceType'] ?? '').toString(),
      ),
      saveKey: (map['saveKey'] ?? '').toString(),
      saveInAmplitude: map['saveInAmplitude'] == null || map['saveInAmplitude'] == true,
      next: _readNextFromMap(map, branchesMap: branchesMap),
      postChat: map['postChat'] != null
          ? ChatScriptItem.fromMap(
              map['postChat'] as Map<String, dynamic>,
              branchesMap: branchesMap,
            )
          : null,
    );
  }

  const ChatScriptItem.empty()
      : type = ChatScriptItemType.none,
        side = ChatScriptItemSide.none,
        text = '',
        path = '',
        amplitudeEvent = '',
        functionName = '',
        answerText = '',
        hidden = false,
        options = const [],
        inputAnswerType = ChatScriptInputAnswerType.none,
        mediaSourceType = ChatScriptItemMediaSourceType.none,
        saveKey = '',
        saveInAmplitude = true,
        next = null,
        postChat = null;

  factory ChatScriptItem.typing({
    required ChatScriptItemSide side,
  }) {
    return const ChatScriptItem.empty().copyWith(
      side: side,
      type: ChatScriptItemType.typing,
    );
  }

  factory ChatScriptItem.delimiter({
    required String text,
  }) {
    return const ChatScriptItem.empty().copyWith(
      text: text,
      type: ChatScriptItemType.delimiter,
    );
  }

  static ChatScriptItem? _readNextFromMap(
    Map<String, dynamic> map, {
    Map<String, dynamic>? branchesMap,
  }) {
    if (map['next'] != null) {
      final nextMap = map['next'] as Map<String, dynamic>;
      final branchName = (nextMap['branch'] ?? '').toString();
      if (branchName.isNotEmpty) {
        final branchMap = branchesMap![branchName] as Map<String, dynamic>;
        return ChatScriptItem.fromMap(branchMap, branchesMap: branchesMap);
      } else {
        return ChatScriptItem.fromMap(nextMap, branchesMap: branchesMap);
      }
    }
    return null;
  }

  ChatScriptItem addHead({
    required ChatScriptItem head,
  }) {
    return head.copyWith(next: this);
  }

  ChatScriptItem replaceHead({
    required ChatScriptItem head,
  }) {
    return head.copyWith(next: next ?? const ChatScriptItem.empty());
  }

  bool get isBubble =>
      type == ChatScriptItemType.textMessage ||
      type == ChatScriptItemType.imageMessage ||
      type == ChatScriptItemType.lottieMessage;

  bool get isCondition =>
      type == ChatScriptItemType.buttonAnswer ||
      type == ChatScriptItemType.inputAnswer ||
      type == ChatScriptItemType.buttonGroupAnswer;

  bool get isImage => type == ChatScriptItemType.imageMessage;
  bool get isText => type == ChatScriptItemType.textMessage;

  bool get isTyping => type == ChatScriptItemType.typing;
  bool get isDelimiter => type == ChatScriptItemType.delimiter;
  bool get isUserSide => side == ChatScriptItemSide.user;

  bool get isHidden => hidden;
  bool get hasFunction => functionName.isNotEmpty;
  bool get shallBeSaved => saveKey.isNotEmpty;

  final ChatScriptItemType type;
  final ChatScriptItemSide side;
  final String text;
  final String path;
  final String amplitudeEvent;
  final String functionName;
  final String answerText;
  final bool hidden;
  final List<ChatScriptItem> options;
  final ChatScriptInputAnswerType inputAnswerType;
  final ChatScriptItemMediaSourceType mediaSourceType;
  final String saveKey;
  final bool saveInAmplitude;
  final ChatScriptItem? next;
  final ChatScriptItem? postChat;

  ChatScriptItem copyWith({
    ChatScriptItemType? type,
    ChatScriptItemSide? side,
    String? text,
    String? path,
    String? amplitudeEvent,
    String? functionName,
    String? answerText,
    bool? hidden,
    List<ChatScriptItem>? options,
    ChatScriptInputAnswerType? inputAnswerType,
    ChatScriptItemMediaSourceType? mediaSourceType,
    String? saveKey,
    bool? saveInAmplitude,
    ChatScriptItem? next,
    ChatScriptItem? postChat,
  }) {
    return ChatScriptItem(
      type: type ?? this.type,
      side: side ?? this.side,
      text: text ?? this.text,
      path: path ?? this.path,
      amplitudeEvent: amplitudeEvent ?? this.amplitudeEvent,
      functionName: functionName ?? this.functionName,
      answerText: answerText ?? this.answerText,
      hidden: hidden ?? this.hidden,
      options: options ?? this.options,
      inputAnswerType: inputAnswerType ?? this.inputAnswerType,
      mediaSourceType: mediaSourceType ?? this.mediaSourceType,
      saveKey: saveKey ?? this.saveKey,
      saveInAmplitude: saveInAmplitude ?? this.saveInAmplitude,
      next: next ?? this.next,
      postChat: postChat ?? this.postChat,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'side': side.name,
      'text': text,
      'path': path,
      'amplitudeEvent': amplitudeEvent,
      'functionName': functionName,
      'answerText': answerText,
      'hidden': hidden,
      'options': options.isNotEmpty
          ? options.map((option) => option.toMap()).toList()
          : null,
      'inputAnswerType': inputAnswerType.name,
      'mediaSourceType': mediaSourceType.name,
      'saveKey': saveKey,
      'saveInAmplitude': saveInAmplitude,
      if (next != null) 'next': next!.toMap(),
      if (postChat != null) 'postChat': postChat!.toMap(),
    };
  }

  @override
  List<Object?> get props {
    return [
      type,
      side,
      text,
      path,
      amplitudeEvent,
      functionName,
      answerText,
      hidden,
      options,
      inputAnswerType,
      mediaSourceType,
      saveKey,
      saveInAmplitude,
      next,
      postChat,
    ];
  }
}
