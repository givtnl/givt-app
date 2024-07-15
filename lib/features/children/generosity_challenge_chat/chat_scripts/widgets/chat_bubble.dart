import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:givt_app/features/children/generosity_challenge_chat/chat_scripts/widgets/chat_picture.dart';
import 'package:givt_app/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    required this.text,
    required this.mediaPath,
    required this.mediaType,
    required this.avatarPath,
    required this.showAvatar,
    required this.isUser,
    required this.backgroundColor,
    required this.isAssetMedia,
    required this.isStoredFile,
    required this.isAssetAvatar,
    required this.isSameSide,
    required this.isNextSideOpposite,
    required this.contentPadding,
    super.key,
    this.mediaWidth,
    this.mediaHeight,
  });

  const ChatBubble.text({
    required this.text,
    required this.showAvatar,
    required this.avatarPath,
    required this.isUser,
    required this.backgroundColor,
    required this.isSameSide,
    required this.isNextSideOpposite,
    super.key,
    this.contentPadding = const EdgeInsets.all(16),
  })  : mediaPath = '',
        mediaType = ChatBubbleMediaType.none,
        isAssetMedia = false,
        isAssetAvatar = true,
        isStoredFile = false,
        mediaWidth = null,
        mediaHeight = null;

  const ChatBubble.typing({
    required this.isUser,
    required this.avatarPath,
    required this.backgroundColor,
    required this.isSameSide,
    required this.isNextSideOpposite,
    super.key,
    this.contentPadding =
        const EdgeInsets.only(left: 16, right: 16, top: 2, bottom: 2),
  })  : text = '',
        mediaPath = 'assets/lotties/typing.json',
        mediaType = ChatBubbleMediaType.lottie,
        mediaWidth = 50,
        mediaHeight = 50,
        isAssetMedia = true,
        isAssetAvatar = true,
        isStoredFile = false,
        showAvatar = true;

  const ChatBubble.image({
    required this.isUser,
    required this.avatarPath,
    required this.backgroundColor,
    required this.isSameSide,
    required this.isNextSideOpposite,
    required this.mediaPath,
    required this.isAssetMedia,
    required this.isStoredFile,
    required this.showAvatar,
    super.key,
    this.contentPadding = const EdgeInsets.all(16),
    this.mediaWidth,
    this.mediaHeight,
  })  : text = '',
        mediaType = ChatBubbleMediaType.image,
        isAssetAvatar = true;

  static const double _avatarSize = 40;
  static const double _avatarTopPadding = 8;

  static const double _intervalBetweenSameMessages = 12;
  static const double _intervalBetweenNewMessages = 20;
  static const double _cornerRadius = 24;

  final bool isUser;
  final String text;
  final String mediaPath;
  final ChatBubbleMediaType mediaType;
  final double? mediaWidth;
  final double? mediaHeight;
  final String avatarPath;
  final bool showAvatar;
  final Color backgroundColor;
  final bool isAssetMedia;
  final bool isAssetAvatar;
  final bool isStoredFile;
  final bool isSameSide;
  final bool isNextSideOpposite;
  final EdgeInsets contentPadding;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final bubbleMaxWidth = size.width * .7;
    final defaultMediaWidth = bubbleMaxWidth;
    final defaultMediaHeight = defaultMediaWidth * 0.65;
    return Padding(
      padding: EdgeInsets.only(
        top: isSameSide
            ? _intervalBetweenSameMessages
            : _intervalBetweenNewMessages,
        bottom: !isNextSideOpposite && showAvatar
            ? _avatarSize + _avatarTopPadding
            : 0,
      ),
      child: Stack(
        children: [
          Row(
            children: [
              if (isUser) const Spacer(),
              Container(
                color: Colors.transparent,
                constraints: BoxConstraints(
                  maxWidth: bubbleMaxWidth,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(_cornerRadius),
                      topRight: const Radius.circular(_cornerRadius),
                      bottomLeft: Radius.circular(
                        isUser ? _cornerRadius : 0,
                      ),
                      bottomRight: Radius.circular(
                        isUser ? 0 : _cornerRadius,
                      ),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      if (mediaPath.isNotEmpty) {
                        _showImageDialog(
                          context,
                          mediaPath,
                          size.width,
                          size.height,
                        );
                      }
                    },
                    child: Padding(
                      padding: contentPadding,
                      child: mediaPath.isNotEmpty
                          ? _createMediaContent(
                              mediaWidth ?? defaultMediaWidth,
                              mediaHeight ?? defaultMediaHeight,
                            )
                          : _createTextContent(context),
                    ),
                  ),
                ),
              ),
              if (!isUser) const Spacer(),
            ],
          ),
          if (showAvatar)
            Positioned(
              bottom: 0,
              left: isUser ? null : 0,
              right: isUser ? 0 : null,
              child: Transform.translate(
                offset: const Offset(
                  0,
                  _avatarSize + _avatarTopPadding,
                ),
                child: _createAvatar(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _createAvatar() {
    return isAssetAvatar
        ? SvgPicture.asset(
            avatarPath,
            width: _avatarSize,
            height: _avatarSize,
          )
        : SvgPicture.network(
            avatarPath,
            width: _avatarSize,
            height: _avatarSize,
          );
  }

  Widget _createTextContent(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 18,
            fontFamily: 'Rouna',
            fontWeight: FontWeight.w500,
            color: AppTheme.secondary20,
          ),
    );
  }

  Widget _createMediaContent(double width, double height) {
    final Widget child;
    switch (mediaType) {
      case ChatBubbleMediaType.image:
        child = ChatPicture(
          width: width,
          height: height,
          path: mediaPath,
          isAsset: isAssetMedia,
          isStoredFile: isStoredFile,
        );
      case ChatBubbleMediaType.lottie:
        child = isAssetMedia
            ? Lottie.asset(mediaPath, width: width, height: height)
            : Lottie.network(mediaPath, width: width, height: height);
      case ChatBubbleMediaType.none:
        child = const SizedBox.shrink();
    }
    return ClipRRect(
      // - 10 == padding on each side of the bubble
      // serves to make concentric border radiuses
      // see https://graphicdesign.stackexchange.com/questions/8919/how-to-compute-the-radii-radiuses-of-corners-for-concentric-rounded-rects
      borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(_cornerRadius - 10),
        topRight: const Radius.circular(_cornerRadius - 10),
        bottomLeft: Radius.circular(
          isUser ? _cornerRadius - 10 : 0,
        ),
        bottomRight: Radius.circular(
          isUser ? 0 : _cornerRadius - 10,
        ),
      ),
      child: child,
    );
  }

  void _showImageDialog(
    BuildContext context,
    String imageUrl,
    double width,
    double height,
  ) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          backgroundColor: Colors.transparent,
          elevation: 90,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  alignment: Alignment.topRight,
                  onPressed: () => context.pop(),
                  icon: const FaIcon(
                    FontAwesomeIcons.xmark,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: _createMediaContent(
                    width,
                    height,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

enum ChatBubbleMediaType {
  none,
  image,
  lottie,
  ;
}
