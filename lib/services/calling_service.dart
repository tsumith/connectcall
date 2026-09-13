import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// ignore: depend_on_referenced_packages
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import '../core/constants/app_constants.dart';
import '../models/call_model.dart';
import '../core/router/app_router.dart';

import 'i_calling_service.dart';
import '../models/call_type.dart';
import '../models/call_status.dart';

final callingServiceProvider = Provider<ICallingService>((ref) {
  return ZegoCallingService(FirebaseFirestore.instance);
});

class ZegoCallingService implements ICallingService {
  final FirebaseFirestore _firestore;

  ZegoCallingService(this._firestore);

  @override
  void initCloud(String userId, String userName) {
    ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(rootNavigatorKey);
    ZegoUIKitPrebuiltCallInvitationService().init(
      appID: AppConstants.zegoAppId,
      appSign: AppConstants.zegoAppSign,
      userID: userId,
      userName: userName,
      plugins: [ZegoUIKitSignalingPlugin()],
      requireConfig: (ZegoCallInvitationData data) {
        final config = (data.type == ZegoCallInvitationType.videoCall)
            ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
            : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

        config.bottomMenuBar = ZegoCallBottomMenuBarConfig(
          style: ZegoCallMenuBarStyle.dark,
          backgroundColor: const Color(0xFF1C1C1E).withValues(alpha: 0.9),
        );
        config.topMenuBar = ZegoCallTopMenuBarConfig(
          isVisible: true,
          style: ZegoCallMenuBarStyle.dark,
        );

        return config;
      },
      invitationEvents: ZegoUIKitPrebuiltCallInvitationEvents(
        onOutgoingCallDeclined:
            (String callID, ZegoCallUser callee, String customData) {
              final isVideo =
                  customData.contains('video') || callID.contains('video');
              logCall(
                callerId: userId,
                calleeId: callee.id,
                type: isVideo ? CallType.video : CallType.audio,
                status: CallStatus.rejected,
                durationSeconds: 0,
              );
            },
        onOutgoingCallTimeout:
            (String callID, List<ZegoCallUser> callees, bool isVideoCall) {
              if (callees.isNotEmpty) {
                logCall(
                  callerId: userId,
                  calleeId: callees.first.id,
                  type: isVideoCall ? CallType.video : CallType.audio,
                  status: CallStatus.missed,
                  durationSeconds: 0,
                );
              }
            },
        onIncomingCallTimeout: (String callID, ZegoCallUser caller) {
          final isVideo = callID.contains('video');
          logCall(
            callerId: caller.id,
            calleeId: userId,
            type: isVideo ? CallType.video : CallType.audio,
            status: CallStatus.missed,
            durationSeconds: 0,
          );
        },
        onOutgoingCallAccepted: (String callID, ZegoCallUser callee) {
          final isVideo = callID.contains('video');
          logCall(
            callerId: userId,
            calleeId: callee.id,
            type: isVideo ? CallType.video : CallType.audio,
            status: CallStatus.completed,
            durationSeconds: 0,
          );
        },
        onIncomingCallAcceptButtonPressed: () {
          // Note (Architecture): For incoming call acceptance, the Zego SDK event
          // `onIncomingCallAcceptButtonPressed` lacks direct caller information parameters.
          // In a fully robust production system, you would:
          // 1. Maintain active call state in this service using ZegoUIKitPrebuiltCallInvitationData
          // 2. Parse that data here to log the accepted incoming call.
          // For now, per standard pragmatic constraints, this is left as a placeholder.
        },
      ),
    );
  }

  @override
  void uninitCloud() {
    ZegoUIKitPrebuiltCallInvitationService().uninit();
  }

  @override
  Future<void> logCall({
    required String callerId,
    required String calleeId,
    required CallType type,
    required CallStatus status,
    required int durationSeconds,
  }) async {
    final callsCollection = _firestore.collection(AppConstants.callsCollection);
    final callDoc = callsCollection.doc();

    final call = CallModel(
      id: callDoc.id,
      participants: [callerId, calleeId],
      callerId: callerId,
      calleeId: calleeId,
      type: type,
      status: status,
      startedAt: DateTime.now().subtract(Duration(seconds: durationSeconds)),
      durationSeconds: durationSeconds,
    );

    await callDoc.set(call.toMap());
  }

  @override
  Stream<List<CallModel>> getCallHistory(String userId) {
    return _firestore
        .collection(AppConstants.callsCollection)
        .where('participants', arrayContains: userId)
        .orderBy('startedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => CallModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }
}
