// ignore_for_file: empty_constructor_bodies, prefer_collection_literals, unnecessary_this

class Task {
  int? id;
  String? title;
  String? note;
  int? isCompleted;
  String? data;
  String? startTime;
  String? endTime;
  int? color;
  int? remind;
  String? repeat;

  Task(
      {this.id,
      this.title,
      this.note,
      this.isCompleted,
      this.data,
      this.startTime,
      this.endTime,
      this.color,
      this.remind,
      this.repeat});

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    note = json['note'];
    isCompleted = json['isCompleted'];
    data = json['data'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    color = json['color'];
    remind = json['remind'];
    repeat = json['repeat'];
  }

  Map<String, dynamic> tojson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['data'] = this.data;
    data['note'] = this.note;
    data['isCompleted'] = this.isCompleted;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['color'] = this.color;
    data['remind'] = this.remind;
    data['repeat'] = this.repeat;
    return data;
    /* return {
      'id': id,
      'title': title,
      'note': note,
      'data': data,
      'startTime': startTime,
      'endTime': endTime,
      'remind': remind,
      'repeat': repeat,
      'color': color,
      'isCompleted': isCompleted,
    };*/
  }
}
