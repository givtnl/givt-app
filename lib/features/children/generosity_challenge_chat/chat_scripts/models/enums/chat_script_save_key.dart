enum ChatScriptSaveKey {
  none(value: ''),
  lastName(value: 'lastName'),
  firstName(value: 'firstName'),
  email(value: 'email'),
  password(value: 'password'),

  parent2FirstName(value: 'parent2FirstName'),
  child1FirstName(value: 'child1FirstName'),
  child2FirstName(value: 'child2FirstName'),
  child3FirstName(value: 'child3FirstName'),
  child4FirstName(value: 'child4FirstName'),

  familyValue1Key(value: 'familyValue1Key'),
  familyValue1Value(value: 'familyValue1Value'),
  familyValue2Key(value: 'familyValue2Key'),
  familyValue2Value(value: 'familyValue2Value'),
  familyValue3Key(value: 'familyValue3Key'),
  familyValue3Value(value: 'familyValue3Value'),
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
