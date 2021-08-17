import 'package:homeworkr/models/application.dart';
import 'package:homeworkr/models/homework.dart';
import 'package:homeworkr/models/notification.dart';
import 'package:homeworkr/models/user.dart';

class Notifications {
  static Notification CreateNewApplicantNotification(Homework homework) {
    return Notification(
        title: "Nuevo aplicante",
        body: "Ha aplicado un nuevo mentor en la tarea ${homework.title}",
        to: homework.authorId);
  }

  static Notification CreateEnteredOnRoomNotification(
      AppUser from, AppUser to, Homework homework) {
    var role = from.role == 'student'?'estudiante':'mentor';
    return Notification(
        title: "${from.role} ha entrado en la sala de tareas",
        body:
            "El ${from.role} ha entrado a la sala de tareas de la tarea ${homework.title}",
        to: to.uUID);
  }

  static Notification CreateApplicantAcceptedNotification(
      Application application, Homework homework) {
    return Notification(
        title: "Aplicación aceptada",
        body: "Su aplicación para la tarea: ${homework.title} ha sido aceptada",
        to: application.authorId);
  }

  static Notification CreatePayProcessedNotification(
      AppUser applicant, Homework homework) {
    return Notification(
        title: "Pago procesado",
        body: "Se ha procesado el pago de la tarea ${homework.title}",
        to: applicant.uUID);
  }
}
