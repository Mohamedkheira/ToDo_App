import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/firebase/model/task.dart';
import 'package:todo/firebase/user_collection.dart';

class TaskCollection{

  static CollectionReference<Task> getTaskCollection(String userId){
    var userCollection = UserCollection.getUserCollectionsReference();
    var userDoc = userCollection.doc(userId);
    var taskCollection = userDoc.collection( Task.collectionName).withConverter(
        fromFirestore: (snapshot, options) {
          return Task.fromFirestoe(snapshot.data());
        },
        toFirestore: (task, options) {
          return task.toFirestore();
        },
    );
    return taskCollection;

  }
  static Future<void> createTask(String userId,Task newTask) async{
    var collectionTask = getTaskCollection(userId);
    var docRef = collectionTask.doc();
    newTask.id = docRef.id;
    await docRef.set(newTask);
  }
  static Future<List<Task>> getTask(String userId) async {
    var collectionTask = getTaskCollection(userId);
    var snapshot = await collectionTask.get();
    List<Task> tasks = snapshot.docs.map((snapshot) => snapshot.data()).toList();
    return tasks;
  }
  static Future<void> deleteTask(String userId,String taskId) async{
    var collectionTask = getTaskCollection(userId);
    var docRef = collectionTask.doc(taskId);
    await docRef.delete();
  }
}