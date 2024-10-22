import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/firebase/model/users.dart';

class UserCollection{

  static CollectionReference<User> getUserCollectionsReference(){
    var database = FirebaseFirestore.instance;
    var collectionReference = database.collection(User.collectionName).withConverter(
      fromFirestore: (snapshot, options) => User.fromFirestore(snapshot.data()),
      toFirestore: (User, options) => User.toFirestore(),
    );
    return collectionReference;
  }
  static Future<void> createUser(String userId, User user){
    var userCollectionsReference = getUserCollectionsReference();
    return userCollectionsReference.doc(userId).set(user);
  }

  static Future<User?> getUser(String userId) async {
    var userCollectionReference = getUserCollectionsReference();
    var snapshot = await userCollectionReference.doc(userId).get();
    return snapshot.data();
  }
}