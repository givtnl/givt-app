enum ChatScriptItemMediaSourceType {
  none,
  asset,
  storedFile,
  network;

  static ChatScriptItemMediaSourceType fromString(String value) {
    try {
      return ChatScriptItemMediaSourceType.values.byName(value);
    } catch (error) {
      return ChatScriptItemMediaSourceType.none;
    }
  }
}
