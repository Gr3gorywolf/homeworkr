class Notification {
  String title;
  String body;
  String to;

  Notification({this.title, this.body, this.to});

  Notification.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['body'] = this.body;
    data['to'] = this.to;
    return data;
  }
}