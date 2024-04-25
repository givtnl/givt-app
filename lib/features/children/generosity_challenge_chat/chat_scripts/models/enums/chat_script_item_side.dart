enum ChatScriptItemSide {
  user, //family member
  interlocutor; //mayor

  static ChatScriptItemSide fromString(String value) {
    return ChatScriptItemSide.values.byName(value);
  }
}
