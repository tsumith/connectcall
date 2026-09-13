import 'call_type.dart';
import 'call_status.dart';

class CallModel {
  final String id;
  final List<String> participants;
  final String callerId;
  final String calleeId;
  final CallType type;
  final CallStatus status;
  final DateTime startedAt;
  final int durationSeconds;

  CallModel({
    required this.id,
    required this.participants,
    required this.callerId,
    required this.calleeId,
    required this.type,
    required this.status,
    required this.startedAt,
    this.durationSeconds = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'participants': participants,
      'callerId': callerId,
      'calleeId': calleeId,
      'type': type.toMapString(),
      'status': status.toMapString(),
      'startedAt': startedAt.millisecondsSinceEpoch,
      'durationSeconds': durationSeconds,
    };
  }

  factory CallModel.fromMap(Map<String, dynamic> map, String documentId) {
    return CallModel(
      id: documentId,
      participants: List<String>.from(map['participants'] ?? []),
      callerId: map['callerId'] ?? '',
      calleeId: map['calleeId'] ?? '',
      type: CallType.fromString(map['type'] ?? 'audio'),
      status: CallStatus.fromString(map['status'] ?? 'missed'),
      startedAt: DateTime.fromMillisecondsSinceEpoch(map['startedAt'] ?? 0),
      durationSeconds: map['durationSeconds'] ?? 0,
    );
  }
}
