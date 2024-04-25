enum ChatScriptItemType {
  textMessage,
  imageMessage,
  // lottieMessage,
  // audioMessage,
  gifMessage,
  inputAnswer,
  buttonAnswer,
  buttonGroupAnswer;

  static ChatScriptItemType fromString(String value) {
    return ChatScriptItemType.values.byName(value);
  }
}
