enum ChatScriptItemMediaSourceType {
  none,
  asset,
  network;

  static ChatScriptItemMediaSourceType fromString(String value) {
    try {
      return ChatScriptItemMediaSourceType.values.byName(value);
    } catch (error) {
      return ChatScriptItemMediaSourceType.none;
    }
  }
}
