import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallAction extends StatefulWidget {
  CallAction(
      {Key? key,
      required this.callId,
      required this.userId,
      required this.username})
      : super(key: key);
  String userId;
  String username;
  String callId;

  @override
  State<CallAction> createState() => _CallActionState();
}

class _CallActionState extends State<CallAction> {
  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: 861031996,
      appSign:
          "e3b345e9ecc166e34e3f90fd15b2b877f7a35a85cd4bf367bca7d4d38d4e2991",
      userID: widget.userId,
      userName: widget.username,
      callID: widget.callId,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
        ..layout = ZegoLayout.gallery()
        ..turnOnCameraWhenJoining = false,
    );
  }
}
