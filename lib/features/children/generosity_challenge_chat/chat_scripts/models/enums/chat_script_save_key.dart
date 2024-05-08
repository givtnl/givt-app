enum ChatScriptSaveKey {
  none(value: ''),
  lastName(value: 'lastName'),
  firstName(value: 'firstName'),
  email(value: 'email'),
  password(value: 'password'),
  ;

  const ChatScriptSaveKey({required this.value});
  final String value;

  bool get isSupported => this != ChatScriptSaveKey.none;

  static ChatScriptSaveKey fromString(String value) {
    try {
      return ChatScriptSaveKey.values.byName(value);
    } catch (error) {
      return ChatScriptSaveKey.none;
    }
  }
}
