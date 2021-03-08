import 'package:homeworkr/models/application.dart';

enum HomeworkStatus {
  open,
  pending,
  confirmed,
  completed,
}

class Homework {
  String authorId;
  List<Application> applications;
  Application selectedAplication;
  String status;
  int price;
  String title;
  String description;
  List<String> categories;
  String roomId;

  Homework(
      {this.authorId,
      this.applications,
      this.selectedAplication,
      this.status,
      this.price,
      this.title,
      this.description,
      this.categories,
      this.roomId});

  Homework.fromJson(Map<String, dynamic> json) {
    authorId = json['authorId'];
    if (json['applications'] != null) {
      applications = new List<Application>();
      json['applications'].forEach((v) {
        applications.add(new Application.fromJson(v));
      });
    }
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
    if (this.applications != null) {
      data['applications'] = this.applications.map((v) => v.toJson()).toList();
    }
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
