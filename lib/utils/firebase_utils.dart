import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:graduation_app/model/task_data.dart';
import 'package:graduation_app/model/user_data.dart';

import '../model/api_manager.dart';

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
  static CollectionReference<TaskData> getTasksCollection(String uId) {
    return // to save tasks list for each user
        getUsersCollection()
            .doc(uId) //uId
            // FirebaseFirestore.instance
            .collection(TaskData.collectionName)
            .withConverter<TaskData>(
                fromFirestore: (snapshot, options) =>
                    TaskData.fromFireStore(snapshot.data()!),
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

  ///mine
  // static Future<void> addTaskToFireStore(
  //     Task task, String uId, MyUser patient) async {
  //   var taskCollection =
  //       getTasksCollection(uId); // create & get collection ///uId
  //   var taskDocRef = taskCollection
  //       .doc(); // create doc - give it id or it will generate auto-id
  //   task.id = taskDocRef.id; // auto-id
  //   // Store the task in Firestore
  //   await taskDocRef
  //       .set(task); // Ensure to use toFirestore() if Task is a class
  //   // Call the Flask API to generate analysis data
  //   await ApiManager.generateAnalysis(uId);
  // }

  static Future<void> addTaskToFireStore(
      TaskData task, String uId, MyUser patient) async {
    try {
      var taskCollection =
          getTasksCollection(uId); // create & get collection ///uId
      var taskDocRef = taskCollection
          .doc(); // create doc - give it id or it will generate auto-id
      task.id = taskDocRef.id; // auto-id
      // Store the task in Firestore
      await taskDocRef
          .set(task); // Ensure to use toFirestore() if Task is a class
      // Call the Flask API to generate analysis data
      // await ApiManager.generateAnalysis(uId);
    } catch (e) {
      print('Error adding task to Firestore: $e');
      rethrow; // Re-throw the error to handle it in the calling function};
    }
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
      TaskData task, String id, String uId) {
    return getTasksCollection(uId)
        .doc(id)
        .delete(); // getTasksCollection(uId).doc(id).delete();
  }

  // update -- edit
  static Future<void> updateTaskFromFireStore(TaskData task, String uId) {
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
              MyUser.fromFireStore(snapshot.data()!, snapshot.id),
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
      return MyUser.fromFireStore(doc.data(), doc.id);
    }).toList();
  }

  static Future<void> markTaskAsDone(TaskData task, String uId) async {
    var taskDocRef = getTasksCollection(uId).doc(task.id);
    await taskDocRef.update({
      'isDone': true,
      'completedAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  static Future<void> updatePatientLocation(
      String userId, double latitude, double longitude) async {
    final userDoc = FirebaseFirestore.instance
        .collection(MyUser.collectionName)
        .doc(userId);
    await userDoc.update({
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  static Stream<MyUser> patientLocationStream(String userId) {
    return FirebaseFirestore.instance
        .collection(MyUser.collectionName)
        .doc(userId)
        .snapshots()
        .map((snapshot) => MyUser.fromFireStore(snapshot.data()!, snapshot.id));
  }

  static Future<void> saveAnalysisToFirestore(
      Map<String, dynamic> data, String patientId) async {
    final firestore = FirebaseFirestore.instance;

    // Save analysis data to Firestore under the user's document
    await firestore
        .collection('users')
        .doc(patientId)
        .collection('analysis')
        .add({
      'timestamp': FieldValue.serverTimestamp(),
      'data': data,
    });
  }

  static Future<Map<String, dynamic>?> fetchHomeLocation(
      String patientId) async {
    try {
      DocumentSnapshot patientDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(patientId)
          .get();
      if (patientDoc.exists) {
        return patientDoc['home_location'];
      }
    } catch (e) {
      print('Error fetching home location: $e');
      return null;
    }
    return null;
  }

//   static Future<Map<String, dynamic>> fetchReportData(String userId) async {
//   final firestore = FirebaseFirestore.instance;
//   final snapshot = await firestore.collection('users').doc(userId).collection('analysis').get();
//   // Process the data as needed
//   final data = snapshot.docs.map((doc) => doc.data()).toList();
//   return {
//     'analysis': data,
//     // 'totalTasks': data.fold(0, (sum, item) => sum + (item['total_tasks'] ?? 0)),
//     // 'completedTasks': data.fold(0, (sum, item) => sum + (item['completed_tasks'] ?? 0)),
//     // 'incompleteTasks': data.fold(0, (sum, item) => sum + (item['incomplete_tasks'] ?? 0)),
//     'recommendations': data.fold([], (list, item) => list..addAll(item['recommendations'] ?? [])),
//   };
// }

  //22
  // static Future<Map<String, dynamic>> fetchReportData(String userId) async {
  //   final firestore = FirebaseFirestore.instance;
  //   final snapshot = await firestore
  //       .collection('users')
  //       .doc(userId)
  //       .collection('analysis')
  //       .get();
  //   if (snapshot.docs.isEmpty) {
  //     throw Exception('No data found for the selected patient.');
  //   }
  //   // Fetch the first document (assuming there's only one document per patient)
  //   final data = snapshot.docs.first.data();
  //   // Extract nested fields
  //   final recommendations = data['data']?['recommendations'] ?? [];
  //   return {
  //     'patientName': data['patientName'] ?? 'N/A',
  //     'totalTasks': data['data']?['total_tasks'] ?? 0,
  //     'completedTasks': data['data']?['completed_tasks'] ?? 0,
  //     'incompleteTasks': data['data']?['incomplete_tasks'] ?? 0,
  //     'forecastData': data['data']?['forecastData'] ?? {},
  //     'recommendations':
  //         recommendations.isNotEmpty ? recommendations.join(', ') : 'N/A',
  //   };
  // }

  //3 correct without scatter
  static Future<Map<String, dynamic>> fetchReportData(String userId) async {
    final firestore = FirebaseFirestore.instance;
    final snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('analysis')
        .get();

    if (snapshot.docs.isEmpty) {
      throw Exception('No data found for the selected patient.');
    }

    // Fetch the first document (assuming there's only one document per patient)
    final data = snapshot.docs.first.data();
    // Extract nested fields
    final recommendations = data['data']?['recommendations'] ?? [];

    return {
      'patientName': data['patientName'] ?? 'N/A',
      'totalTasks': data['data']?['total_tasks'] ?? 0,
      'completedTasks': data['data']?['completed_tasks'] ?? 0,
      'incompleteTasks': data['data']?['incomplete_tasks'] ?? 0,
      'forecastData': data['data']?['forecastData'] ?? {},
      'recommendations':
          recommendations.isNotEmpty ? recommendations.join(', ') : 'N/A',
      'scatter_plot_path': data['data']?['scatter_plot_path'],
    };
  }

  //last 2 functions**
  // Future<Map<String, dynamic>?> getAnalysisData(String userId) async {
  //   try {
  //     final doc = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(userId)
  //         .collection('analysis')
  //         .doc(userId)
  //         .get();
  //     if (doc.exists) {
  //       print('Firestore Data: ${doc.data()}');
  //       return doc.data();
  //     } else {
  //       print('No analysis data found for user: $userId');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Error fetching analysis datafrom Firestore: $e');
  //     return null;
  //   }
  // }

  // Future<void> saveAnalysisData(String userId, Map<String, dynamic> analysisData) async {
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(userId)
  //         .collection('analysis')
  //         .doc(userId)
  //         .set(analysisData,
  //             SetOptions(merge: true)); // Merge with existing data
  //     print('Analysis data saved to Firestore');
  //   } catch (e) {
  //     print('Error saving analysis data to Firestore: $e');
  //     throw e;
  //   }
  // }

  

  //  Future<void> savePdfToFirestore(String userId, File pdfFile) async {
  //   // Upload PDF to Firebase Storage
  //   final storageRef = FirebaseStorage.instance.ref().child('reports/$userId/report.pdf');
  //   await storageRef.putFile(pdfFile);

  //   // Get the download URL
  //   final downloadUrl = await storageRef.getDownloadURL();

  //   // Save the URL to Firestore
  //   await FirebaseFirestore.instance.collection('users').doc(userId).collection('reports').add({
  //     'pdfUrl': downloadUrl,
  //     'timestamp': DateTime.now(),
  //   });
  // }

  // static Future<Map<String, dynamic>> fetchReportData(String userId) async {
  //   final firestore = FirebaseFirestore.instance;
  //   final snapshot = await firestore
  //       .collection('users')
  //       .doc(userId)
  //       .collection('analysis')
  //       .get();

  //   if (snapshot.docs.isEmpty) {
  //     throw Exception('No data found for the selected patient.');
  //   }

  //   // Fetch the first document (assuming there's only one document per patient)
  //   final data = snapshot.docs.first.data();
  //   // Extract nested fields
  //   final recommendations = data['data']?['recommendations'] ?? [];

  //   return {
  //     'patientName': data['patientName'] ?? 'N/A',
  //     'totalTasks': data['data']?['total_tasks'] ?? 0,
  //     'completedTasks': data['data']?['completed_tasks'] ?? 0,
  //     'incompleteTasks': data['data']?['incomplete_tasks'] ?? 0,
  //     'forecastData': data['data']?['forecastData'] ?? {},
  //     'recommendations':
  //         recommendations.isNotEmpty ? recommendations.join(', ') : 'N/A',
  //     'scatter_plot_path': data['data']
  //         ?['scatter_plot_path'], // Ensure this is a String
  //   };
  // }

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
  } */

  // fetch tasks for a specific patient
  Future<List<TaskData>> fetchTasksForPatient(String patientId) async {
    try {
      final QuerySnapshot taskSnapshot = await FirebaseFirestore.instance
          .collection(MyUser.collectionName)
          .doc(patientId)
          .collection(TaskData.collectionName)
          .get();

      return taskSnapshot.docs
          .map((doc) =>
              TaskData.fromFireStore(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch tasks: $e');
    }
  }
}
