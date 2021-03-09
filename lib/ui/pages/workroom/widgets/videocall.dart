
import 'package:flutter/material.dart';
import 'package:homeworkr/helpers/alerts_helpers.dart';
import 'package:homeworkr/stores/stores.dart';
import 'package:homeworkr/ui/widgets/custom_icon_button.dart';
//import 'package:jitsi_meet/feature_flag/feature_flag.dart';
//import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:jitsi_meet_screen/jitsi_meet_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoCall extends StatefulWidget {
  String callId;
  VideoCall(this.callId);

  @override
  _VideoCallState createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
   final jitsiScreenController = JitsiMeetScreenController(
    // ignore: avoid_print
    () => print('join'),
    // ignore: avoid_print
    () => print('will join'),
    // ignore: avoid_print
    () => print('terminated'),
  );
  _joinMeeting() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();
    if (!statuses.values.contains(PermissionStatus.denied)) {
      // ignore: unawaited_futures
      var user = Stores.userStore.user;
      jitsiScreenController.setUserInfo(user.firstName, avatarURL: user.avatar);
      jitsiScreenController.joinRoom(
        widget.callId,
        audioMuted: false,
        audioOnly: false,
        videoMuted: false
      );
    } else {
      AlertsHelpers.showAlert(context, "Error",
          "Debe aceptar todos los permisos antes de continuar");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: CustomIconButton(
      onPressed: _joinMeeting,
      text: "Entrar a la reunion",
      backgroundColor: Colors.teal,
      textColor: Colors.white,
      rounded: true,
    ));
  }
}
