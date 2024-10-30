import 'package:flutter/material.dart';
import 'package:todo/firebase/model/task.dart';
import 'package:todo/firebase/task_collection.dart';

class TodoProvider extends ChangeNotifier{
  List<Task> tasksList = [];
  bool isTasksLoading = false;
  String tasksError="";
  refreshTask(String uid) async {
    try{
      isTasksLoading = true;
      notifyListeners();
      tasksList =  await TaskCollection.getTask(uid);
      tasksError="";
      isTasksLoading = false;
      notifyListeners();
    }catch(error){
      tasksError = error.toString();
      isTasksLoading = false;
      notifyListeners();
    }
  }
}