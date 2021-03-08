import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homeworkr/models/homework.dart';
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
}
