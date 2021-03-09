import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homeworkr/helpers/helper_functions.dart';
import 'package:homeworkr/models/application.dart';
import 'package:homeworkr/models/homework.dart';
import 'package:homeworkr/models/work_room.dart';
import 'package:homeworkr/repository/user_repository.dart';
import 'package:homeworkr/stores/stores.dart';

class HomeworkRepository {
  CollectionReference get reference {
    return FirebaseFirestore.instance.collection("homeworks");
  }

  Future<DocumentReference> createHomework(Homework homework) async {
    var currentBalance = Stores.userStore.user.balance - homework.price;
    await UserRepository()
        .setBalance(Stores.userStore.user.uUID, currentBalance);
    return await reference.add(homework.toJson());
  }

  Future setHomeworkStatus(String homeworkId, HomeworkStatus status) async {
    return await reference
        .doc(homeworkId)
        .update({'status': HelperFunctions.parseEnumVal(status)});
  }

  Future<DocumentReference> applyToHomework(
      String homeworkId, Application application) async {
    var document = await reference.doc(homeworkId);
    setHomeworkStatus(homeworkId, HomeworkStatus.pending);
    return document.collection("applications").add(application.toJson());
  }

  Future<DocumentReference> setApplicationState(
      String homeworkId, String applicantUId, ApplicationStatus status) async {
    var collections = await reference
        .doc(homeworkId)
        .collection("applications")
        .where("authorId", isEqualTo: applicantUId)
        .get();
    if (collections.docs.length > 0) {
      await collections.docs.first.reference
          .update({"status": HelperFunctions.parseEnumVal(status)});
    }
  }

  Future<DocumentReference> acceptApplication(
      String homeworkId, String applicantUId) async {
    await setApplicationState(
        homeworkId, applicantUId, ApplicationStatus.accepted);
    var workRoomId = applicantUId + homeworkId + Stores.userStore.user.uUID;
    await reference.doc(homeworkId).update({
      "status": HelperFunctions.parseEnumVal(HomeworkStatus.confirmed),
      "selectedAplication": Application(
              authorId: applicantUId,
              reason: "",
              status: HelperFunctions.parseEnumVal(ApplicationStatus.accepted))
          .toJson(),
      "roomId": workRoomId
    });
    await FirebaseFirestore.instance
        .collection("workrooms")
        .doc(workRoomId)
        .set(WorkRoom(
                homeworkId: workRoomId,
                messages: [],
                participants: [Stores.userStore.user.uUID, applicantUId],
                videoCallId: workRoomId)
            .toJson());
  }
}
