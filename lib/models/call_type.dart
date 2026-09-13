enum CallType {
  audio,
  video;

  // Helper to convert from a string (like from Firestore)
  static CallType fromString(String type) {
    switch (type.toLowerCase()) {
      case 'video':
        return CallType.video;
      case 'audio':
      default:
        return CallType.audio;
    }
  }

  // Helper to convert to a string (like for Firestore)
  String toMapString() => name;
}
