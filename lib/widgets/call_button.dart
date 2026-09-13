import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// ignore: depend_on_referenced_packages
import 'package:zego_uikit/zego_uikit.dart';

class CallButtonWidget extends StatelessWidget {
  final String userId;
  final String userName;
  final bool isVideoCall;
  final Size iconSize;
  final Size buttonSize;
  final EdgeInsets padding;

  const CallButtonWidget({
    super.key,
    required this.userId,
    required this.userName,
    required this.isVideoCall,
    this.iconSize = const Size(32, 32),
    this.buttonSize = const Size(44, 44),
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return ZegoSendCallInvitationButton(
      isVideoCall: isVideoCall,
      invitees: [ZegoUIKitUser(id: userId, name: userName)],
      iconSize: iconSize,
      buttonSize: buttonSize,
      padding: padding,
      customData: isVideoCall ? 'video' : 'audio',
      icon: ButtonIcon(
        icon: Icon(
          isVideoCall ? Icons.videocam_rounded : Icons.phone_rounded,
          color: Colors.white,
        ),
        backgroundColor: isVideoCall ? Colors.teal : Colors.blueAccent,
      ),
    );
  }
}
