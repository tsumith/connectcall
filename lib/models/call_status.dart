enum CallStatus {
  completed,
  missed,
  rejected,
  failed;

  // Helper to convert from a string
  static CallStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return CallStatus.completed;
      case 'rejected':
        return CallStatus.rejected;
      case 'failed':
        return CallStatus.failed;
      case 'missed':
      default:
        return CallStatus.missed;
    }
  }

  // Helper to convert to a string
  String toMapString() => name;
}
