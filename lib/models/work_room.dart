class WorkRoom {
  List<Message> messages;
  String videoCallId;
  List<String> participants;
  String homeworkId;

  WorkRoom(
      {this.messages, this.videoCallId, this.participants, this.homeworkId});

  WorkRoom.fromJson(Map<String, dynamic> json) {
    if (json['messages'] != null) {
      messages = new List<Message>();
      json['messages'].forEach((v) {
        messages.add(new Message.fromJson(v));
      });
    }
    videoCallId = json['videoCallId'];
    participants = json['participants'].cast<String>();
    homeworkId = json['homeworkId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.messages != null) {
      data['messages'] = this.messages.map((v) => v.toJson()).toList();
    }
    data['videoCallId'] = this.videoCallId;
    data['participants'] = this.participants;
    data['homeworkId'] = this.homeworkId;
    return data;
  }
}

class Message {
  String authorId;
  String message;
  String createdAt;
  File file;

  Message({this.authorId, this.message, this.createdAt, this.file});

  Message.fromJson(Map<String, dynamic> json) {
    authorId = json['authorId'];
    message = json['message'];
    createdAt = json['createdAt'];
    file = json['file'] != null ? new File.fromJson(json['file']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['authorId'] = this.authorId;
    data['message'] = this.message;
    data['createdAt'] = this.createdAt;
    if (this.file != null) {
      data['file'] = this.file.toJson();
    }
    return data;
  }
}

class File {
  String url;
  String type;

  File({this.url, this.type});

  File.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['type'] = this.type;
    return data;
  }
}