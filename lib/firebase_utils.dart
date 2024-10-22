import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:graduation_app/model/task_data.dart';
import 'package:graduation_app/model/user_data.dart';

class FirebaseUtils {
  // static void addTaskToFireStore() {
  //   // .instance create object from FirebaseFirestore
  //   // .collection => search about collection name, if found get it, if don't found, it will create it
  //   // withConverter => make firebase knows the type of data that i store
  //   // Task.collectionName instead of 'tasks' - same as routeName
  //   FirebaseFirestore.instance.collection(Task.collectionName).withConverter<Task>(
  //     // get data from firebase that stored in json doc , so get document and then get its data
  //     fromFirestore: (snapshot, options) => Task.fromFireStore(snapshot.data()!),
  //     // send data to firebase, i have object so convert it to json
  //     toFirestore: (task, options) => task.toFirestore());
  // }

  // OR function to create collection(for tasks) with the type of its data
  static CollectionReference<Task> getTasksCollection(String uId) {
    return // to save tasks list for each user
        getUsersCollection()
        .doc(uId) //uId
        // FirebaseFirestore.instance
            .collection(Task.collectionName)
            .withConverter<Task>(
                fromFirestore: (snapshot, options) =>
                    Task.fromFireStore(snapshot.data()!),
                toFirestore: (task, options) => task.toFirestore());
  }

  static Future<void> addTaskToFireStore(Task task, String uId) {
    //, String uId
    var taskCollection = getTasksCollection(uId); // create & get collection ///uId
    var taskDocRef = taskCollection
        .doc(); // create doc - give it id or it will generate auto-id
    task.id = taskDocRef.id; // auto-id
    return taskDocRef
        .set(task); // to make isDone = true - store task in firebase
  }

  // OR Task task + getTasksCollection().doc(task.id)
  static Future<void> deleteTaskFromFireStore(Task task, String id, String uId) {
    return getTasksCollection(uId).doc(id).delete(); // getTasksCollection(uId).doc(id).delete();
  }

  // update -- edit
  static Future<void> updateTaskFromFireStore(Task task, String uId) {
    //, String uId
    return getTasksCollection(uId).doc(task.id).update({
      //getTasksCollection(uId)
      'title': task.title,
      'description': task.description,
      'dateTime': task.dateTime.millisecondsSinceEpoch
    });
  }

///////////////////////////

  static CollectionReference<MyUser> getUsersCollection() {
    return FirebaseFirestore.instance
        .collection(MyUser.collectionName)
        .withConverter<MyUser>(
          fromFirestore: (snapshot, options) =>
              MyUser.fromFireStore(snapshot.data()!),
          toFirestore: (user, _) => user.toFirestore(),
        );
  }

  // in register
  static Future<void> addUserToFireStore(MyUser myUser) {
    return getUsersCollection().doc(myUser.id).set(myUser);
  }

  // in login
  static Future<MyUser?> readUserFromFireStore(String uId) async {
    var snapshot =
        await getUsersCollection().doc(uId).get(); // read data or specific user
    return snapshot.data();
  }
}
