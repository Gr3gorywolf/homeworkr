import 'package:dio/dio.dart';
import 'package:homeworkr/constants/app.dart';
import 'package:homeworkr/helpers/dio_helpers.dart';
import 'package:homeworkr/models/notification.dart';

class NotificationsRepository {
  PostNotification(Notification notification) async {
    try {
      var response = await DioHelpers.dioInstance
          .post("${AppConstants.kBaseUrl}/api/notify", data: notification);
    } on DioError catch (err) {
      print(err.message);
    }
  }
}
