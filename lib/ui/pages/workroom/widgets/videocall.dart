import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:homeworkr/helpers/alerts_helpers.dart';
import 'package:homeworkr/helpers/helper_functions.dart';
import 'package:homeworkr/models/user.dart';
import 'package:homeworkr/repository/notifications_repository.dart';
import 'package:homeworkr/repository/user_repository.dart';
import 'package:homeworkr/stores/current_homework_store.dart';
import 'package:homeworkr/stores/stores.dart';
import 'package:homeworkr/ui/widgets/custom_icon_button.dart';
import 'package:homeworkr/utils/notifications.dart';
//import 'package:jitsi_meet/feature_flag/feature_flag.dart';
//import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:jitsi_meet_screen/jitsi_meet_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoCall extends StatefulWidget {
  String callId;
  VideoCall(this.callId);

  @override
  _VideoCallState createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  bool _isLoading = false;
  final jitsiScreenController = JitsiMeetScreenController(
    // ignore: avoid_print
    () => print('join'),
    // ignore: avoid_print
    () => print('will join'),
    // ignore: avoid_print
    () => print('terminated'),
  );

  notify() async {
    var currentHomework = Stores.currentHomeworkStore.homework;
    var from = Stores.userStore.user;
    AppUser to = null;
    if (from.role == 'mentor') {
      try {
        to = await UserRepository().getUser(currentHomework.authorId);
      } catch (err) {
        return;
      }
    }else{
      to = Stores.currentHomeworkStore.acceptedApplicant;
      print(to);
    }
    await NotificationsRepository().PostNotification(
        Notifications.CreateEnteredOnRoomNotification(
            from, to, currentHomework));
  }

  _joinMeeting() async {
    setState(() {
      _isLoading = true;
    });
    await notify();
    if (kIsWeb) {
      webLaunch();
      return;
    }
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();
    if (!statuses.values.contains(PermissionStatus.denied)) {
      // ignore: unawaited_futures
      var user = Stores.userStore.user;
      jitsiScreenController.setUserInfo(user.firstName, avatarURL: user.avatar);
      jitsiScreenController.joinRoom(widget.callId,
          audioMuted: false, audioOnly: false, videoMuted: false);
    } else {
      AlertsHelpers.showAlert(context, "Error",
          "Debe aceptar todos los permisos antes de continuar");
    }
    setState(() {
      _isLoading = false;
    });
  }

  webLaunch() {
    var user = Stores.userStore.user;
    var avatarEncoded = Uri.encodeFull(user.avatar);
    launch('https://meet.jit.si/${widget.callId}#userInfo.displayName="${user.firstName}"&userInfo.avatarURL="${avatarEncoded}"')
        .then((value) => print("cerrer"));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: CustomIconButton(
      onPressed: _joinMeeting,
      isLoading: _isLoading,
      text: "Entrar a la videollamada",
      backgroundColor: Colors.teal,
      textColor: Colors.white,
      rounded: true,
    ));
  }
}
