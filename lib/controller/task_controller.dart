// ignore_for_file: unnecessary_new

import 'package:flutter_to_do_app/controller/task.dart';
import 'package:flutter_to_do_app/db/db_helper.dart';

import 'package:get/get.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    super.onReady();
  }

  var taskList = <Task>[]
      .obs; //do put all task (that comes from database)in list to can get all of it and show it

  Future<int> addTask({Task? task}) async {
    print('addTask metod called');
    return await DBHelper.insert(task);
  }

  void getTasks() async {
    //to show all data in database
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks
        .map((data) => new Task.fromJson(data))
        .toList()); //do (SQLite doucmentation في Retrieve the list of Dogsالدزء دا زي toList  ويرجعهم علي هيأت fromJsonزي  map بيعمل عليهم )
  }

  void delet(Task task) {
    DBHelper.delet(task);
    getTasks();
  }

  void markTaskCOmpleted(int id) async {
    await DBHelper.upadata(id);
    getTasks();
  }
}
