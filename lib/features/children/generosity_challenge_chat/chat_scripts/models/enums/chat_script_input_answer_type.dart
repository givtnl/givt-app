enum ChatScriptInputAnswerType {
  none,
  text,
  email,
  password,
  number,
  ;

  static ChatScriptInputAnswerType fromString(String value) {
    try {
      return ChatScriptInputAnswerType.values.byName(value);
    } catch (error) {
      return ChatScriptInputAnswerType.none;
    }
  }
}
