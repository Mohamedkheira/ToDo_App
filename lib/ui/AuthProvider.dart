import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/firebase/model/task.dart';
import 'package:todo/firebase/model/users.dart' as MyUser;
import 'package:flutter/material.dart';
import 'package:todo/firebase/task_collection.dart';
import 'package:todo/firebase/user_collection.dart';

class AuthUserProvider extends ChangeNotifier{
  User? firebaseUser;
  MyUser.User? databaseUser;

  setUsers(User newFirebaseUse,MyUser.User newDatabase ){
    firebaseUser = newFirebaseUse;
    databaseUser = newDatabase;

  }

  Future<void> retrieveUserData() async{
    firebaseUser = FirebaseAuth.instance.currentUser;
    databaseUser = await UserCollection.getUser(firebaseUser!.uid);
    
  }


}