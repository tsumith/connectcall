import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import '../core/router/app_router.dart';

class CallOverlayWidget extends StatelessWidget {
  final Widget child;

  const CallOverlayWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        ZegoUIKitPrebuiltCallMiniOverlayPage(
          contextQuery: () {
            return rootNavigatorKey.currentState!.context;
          },
        ),
      ],
    );
  }
}
