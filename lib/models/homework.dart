import 'package:homeworkr/models/application.dart';

enum HomeworkStatus {
  open,
  pending,
  confirmed,
  completed,
}

String traslateHomeworkStatus(String status) {
  switch (status) {
    case "open":
      return "abierto";
    case "pending":
      return "pendiente";
    case "confirmed":
      return "confirmada";
    case "completed":
      return "completed";
    default:
      return status;
  }
}

class Homework {
  String authorId;
  Application selectedAplication;
  String status;
  int price;
  String title;
  String description;
  List<String> categories;
  String roomId;
  int get workProgress {
    var progress = 0;
    switch (status) {
      case "pending":
        progress = 1;
        break;
      case "confirmed":
        progress = 2;
        break;
      case "completed":
        progress = 3;
        break;
    }
    return progress;
  }

  Homework(
      {this.authorId,
      this.selectedAplication,
      this.status,
      this.price,
      this.title,
      this.description,
      this.categories,
      this.roomId});

  Homework.fromJson(Map<String, dynamic> json) {
    authorId = json['authorId'];
    selectedAplication = json['selectedAplication'] != null
        ? new Application.fromJson(json['selectedAplication'])
        : null;
    status = json['status'];
    price = json['price'];
    title = json['title'];
    description = json['description'];
    categories = json['categories'].cast<String>();
    roomId = json['roomId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['authorId'] = this.authorId;
    if (this.selectedAplication != null) {
      data['selectedAplication'] = this.selectedAplication.toJson();
    }
    data['status'] = this.status;
    data['price'] = this.price;
    data['title'] = this.title;
    data['description'] = this.description;
    data['categories'] = this.categories;
    data['roomId'] = this.roomId;
    return data;
  }
}
