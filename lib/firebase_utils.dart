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

  // my code
  // static Future<void> addTaskToFireStore(Task task, String uId) {
  //   var taskCollection =
  //       getTasksCollection(uId); // create & get collection ///uId
  //   var taskDocRef = taskCollection
  //       .doc(); // create doc - give it id or it will generate auto-id
  //   task.id = taskDocRef.id; // auto-id
  //   return taskDocRef
  //       .set(task); // to make isDone = true - store task in firebase
  // }

  static Future<void> addTaskToFireStore(
      Task task, String uId, MyUser patient) async {
    var taskCollection =
        getTasksCollection(uId); // create & get collection ///uId
    var taskDocRef = taskCollection
        .doc(); // create doc - give it id or it will generate auto-id
    task.id = taskDocRef.id; // auto-id
    // Store the task in Firestore
    await taskDocRef
        .set(task); // Ensure to use toFirestore() if Task is a class
    // Update the patient's taskIds in Firestore
    var patientDocRef =
        FirebaseFirestore.instance.collection(MyUser.collectionName).doc(uId);
    // Add the new task ID to the taskIds list
    await patientDocRef.update({
      'taskIds':
          FieldValue.arrayUnion([task.id]) // Use arrayUnion to avoid duplicates
    });
  }

  // testttt
//   static Future<void> addTaskToFireStore(Task task, String uId) async {
//   var taskCollection = FirebaseFirestore.instance
//       .collection('users')
//       .doc(uId)
//       .collection('tasks'); // Save tasks directly in the user's tasks subcollection

//   var taskDocRef = taskCollection.doc(); // Create new task document
//   task.id = taskDocRef.id; // Assign the auto-generated ID to the task
//   await taskDocRef.set(task.toFirestore()); // Store the task in Firestore
// }

  // OR Task task + getTasksCollection().doc(task.id)
  static Future<void> deleteTaskFromFireStore(
      Task task, String id, String uId) {
    return getTasksCollection(uId)
        .doc(id)
        .delete(); // getTasksCollection(uId).doc(id).delete();
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

  // Register new user

  static Future<void> addUserToFireStore(MyUser myUser) {
    return getUsersCollection().doc(myUser.id).set(myUser);
  }

  // Read user data on login
  static Future<MyUser?> readUserFromFireStore(String uId) async {
    var snapshot =
        await getUsersCollection().doc(uId).get(); // read data or specific user
    return snapshot.data();
  }

  ///////////////////////////

  // Method to fetch patients assigned to a specific caregiver
  static Future<List<MyUser>> fetchCaregiverPatients(String caregiverId) async {
    var patientSnapshots = await FirebaseFirestore.instance
        .collection(
            'users') // Assuming you store all users in a 'users' collection
        .where('role', isEqualTo: 'Patient') // Filter by role
        .get();

    // Convert each document into a `MyUser` instance
    return patientSnapshots.docs.map((doc) {
      return MyUser.fromFireStore(doc.data());
    }).toList();
  }

  // Fetch tasks for a specific patient where isDone = false
  /*
  static Future<List<Task>> fetchTasksForPatient(String patientId) async {

    // var tasksSnapshot = await
    // // fetchCaregiverPatients().
    // FirebaseFirestore.instance
    //     .collection('tasks')
    //     .where('id', isEqualTo: patientId)
    //     .where('isDone', isEqualTo: false)
    //     .get();
    ////////////
    // return // to save tasks list for each user
    //     getUsersCollection()
    //         .doc(patientId) //uId
    //         // FirebaseFirestore.instance
    //         .collection(Task.collectionName)
    //         .where('isDone', isEqualTo: false).get()
    //         .withConverter<Task>(
    //             fromFirestore: (snapshot, options) =>
    //                 Task.fromFireStore(snapshot.data()!),
    //             toFirestore: (task, options) => task.toFirestore());
    /////////////////
    //       print('Tasks fetched: ${tasksSnapshot.docs.length} for Patient ID: $patientId');
    //  // If you have task data, log it
    // tasksSnapshot.docs.forEach((doc) {
    //     print('Task ID: ${doc.id}, Data: ${doc.data()}');
    // });
    // // Map the tasks to the `Task` model and return the list
    // return tasksSnapshot.docs
    //     .map((doc) => Task.fromFireStore(doc.data()))
    //     .toList();

 ///////lastt
    var tasksSnapshots = await FirebaseFirestore.instance
        .collection(
            'tasks') // Assuming you store all users in a 'users' collection
        .where('id', isEqualTo: patientId) // Filter by role
        .where('isDone', isEqualTo: false)
        .get();
   // Convert each document into a `MyUser` instance
    return tasksSnapshots.docs.map((doc) {
      return Task.fromFireStore(doc.data());
    }).toList();

    
  }
  */
}
