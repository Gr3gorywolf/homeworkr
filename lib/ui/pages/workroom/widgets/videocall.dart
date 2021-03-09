import 'package:flutter/material.dart';
import 'package:homeworkr/stores/stores.dart';
import 'package:homeworkr/ui/widgets/custom_icon_button.dart';
import 'package:jitsi_meet/feature_flag/feature_flag.dart';
import 'package:jitsi_meet/jitsi_meet.dart';

class VideoCall extends StatelessWidget {
  String callId;
  VideoCall(this.callId);
  _joinMeeting() async {
    try {
      FeatureFlag featureFlag = FeatureFlag();
      featureFlag.welcomePageEnabled = false;
      featureFlag.resolution = FeatureFlagVideoResolution
          .MD_RESOLUTION; // Limit video resolution to 360p
      var user = Stores.userStore.user;
      var homework = Stores.currentHomeworkStore.homework;
      var options = JitsiMeetingOptions()
        ..room = callId // Required, spaces will be trimmed
        ..subject = homework.title
        ..userDisplayName = user.firstName
        ..userAvatarURL = user.avatar // or .png
        ..audioOnly = true
        ..audioMuted = true
        ..videoMuted = true
        ..featureFlag = featureFlag;

      await JitsiMeet.joinMeeting(options);
    } catch (error) {
      debugPrint("error: $error");
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
