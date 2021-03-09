enum ApplicationStatus { pending, accepted, denied }

class Application {
  String authorId;
  String reason;
  String status;

  Application({this.authorId, this.reason, this.status});

  Application.fromJson(Map<String, dynamic> json) {
    authorId = json['authorId'];
    reason = json['reason'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['authorId'] = this.authorId;
    data['reason'] = this.reason;
    data['status'] = this.status;
    return data;
  }
}
