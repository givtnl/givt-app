enum ChatScriptItemSide {
  none, //delimiter
  user, //family member
  interlocutor; //mayor

  static ChatScriptItemSide fromString(String value) {
    return ChatScriptItemSide.values.byName(value);
  }

  static bool isOpposite(ChatScriptItemSide first, ChatScriptItemSide second) =>
      first != none && second != none && first != second;
}
