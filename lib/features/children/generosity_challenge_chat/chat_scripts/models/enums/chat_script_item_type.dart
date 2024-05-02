enum ChatScriptItemType {
  none,
  textMessage,
  imageMessage,
  lottieMessage,
  // audioMessage,
  inputAnswer,
  buttonAnswer,
  buttonGroupAnswer,
  typing,
  delimiter;

  static ChatScriptItemType fromString(String value) {
    return ChatScriptItemType.values.byName(value);
  }
}
