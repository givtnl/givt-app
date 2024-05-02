import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/cubit/chat_scripts_cubit.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/chat_script_item.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/enums/chat_script_item_media_source_type.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/models/enums/chat_script_item_side.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/widgets/chat_bubble.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/widgets/chat_delimiter.dart';

class ChatHistory extends StatefulWidget {
  const ChatHistory({super.key});

  @override
  State<ChatHistory> createState() => _ChatHistoryState();
}

class _ChatHistoryState extends State<ChatHistory> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _scrollToEnd() async {
    await Future.delayed(const Duration(milliseconds: 100), () {});
    await _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatScriptsCubit, ChatScriptsState>(
      builder: (BuildContext context, ChatScriptsState state) {
        return Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 190),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: _convertToWidgets(
                _convertToList(state.chatHistory),
                state,
              ),
            ),
          ),
        );
      },
    );
  }

  List<ChatScriptItem> _convertToList(ChatScriptItem chatHistory) {
    final result = <ChatScriptItem>[];
    ChatScriptItem? currentItem;

    for (currentItem = chatHistory;
        currentItem != null && currentItem != const ChatScriptItem.empty();
        currentItem = currentItem.next) {
      result.add(currentItem.copyWith(next: const ChatScriptItem.empty()));
    }

    return result.reversed.toList();
  }

  List<Widget> _convertToWidgets(
    List<ChatScriptItem> historyItems,
    ChatScriptsState state,
  ) {
    final result = <Widget>[];

    for (var i = 0; i < historyItems.length; i++) {
      final item = historyItems[i];
      final isUserSide = item.isUserSide;
      final avatarPath = isUserSide
          ? state.chatActorsSettings.userAvatar
          : state.chatActorsSettings.interlocutorAvatar;
      final backgroundColor = isUserSide
          ? state.chatActorsSettings.interlocutorBubbleColor
          : state.chatActorsSettings.userBubbleColor;

      //compare with previous item's side
      final isSameSide = i - 1 >= 0 && item.side == historyItems[i - 1].side;

      //check is next item's side opposite
      final isNextSideOpposite = i + 1 < historyItems.length &&
          ChatScriptItemSide.isOpposite(item.side, historyItems[i + 1].side);

      //either last or before not the same side
      final showAvatar = i == historyItems.length - 1 ||
          i + 1 < historyItems.length && item.side != historyItems[i + 1].side;

      if (item.isTyping) {
        result.add(
          ChatBubble.typing(
            isUser: isUserSide,
            avatarPath: avatarPath,
            backgroundColor: backgroundColor,
            isSameSide: isSameSide,
            isNextSideOpposite: isNextSideOpposite,
          ),
        );
      } else if (item.isDelimiter) {
        result.add(ChatDelimiter(text: item.text));
      } else if (item.isText) {
        result.add(
          ChatBubble.text(
            text: item.text,
            showAvatar: showAvatar,
            avatarPath: avatarPath,
            isUser: isUserSide,
            backgroundColor: backgroundColor,
            isSameSide: isSameSide,
            isNextSideOpposite: isNextSideOpposite,
          ),
        );
      } else if (item.isImage) {
        result.add(
          ChatBubble.image(
            showAvatar: showAvatar,
            avatarPath: avatarPath,
            isUser: isUserSide,
            backgroundColor: backgroundColor,
            isSameSide: isSameSide,
            isNextSideOpposite: isNextSideOpposite,
            mediaPath: item.path,
            isAssetMedia:
                item.mediaSourceType == ChatScriptItemMediaSourceType.asset,
          ),
        );
      }
    }
    _scrollToEnd();
    return result;
  }
}
