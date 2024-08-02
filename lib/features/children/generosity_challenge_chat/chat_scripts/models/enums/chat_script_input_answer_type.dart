enum ChatScriptInputAnswerType {
  none,
  text,
  email,
  phone,
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
