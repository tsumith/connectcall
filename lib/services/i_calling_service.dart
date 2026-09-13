import '../models/call_model.dart';
import '../models/call_type.dart';
import '../models/call_status.dart';

abstract class ICallingService {
  void initCloud(String userId, String userName);
  void uninitCloud();
  
  Future<void> logCall({
    required String callerId,
    required String calleeId,
    required CallType type,
    required CallStatus status,
    required int durationSeconds,
  });

  Stream<List<CallModel>> getCallHistory(String userId);
}
