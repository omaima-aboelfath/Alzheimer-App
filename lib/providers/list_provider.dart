import 'package:flutter/material.dart';
import 'package:graduation_app/firebase_utils.dart';
import 'package:graduation_app/model/task_data.dart';

class ListProvider extends ChangeNotifier {
  // data

  List<Task> tasksList = [];
  var selectDate = DateTime.now();

  // functions
/* my old function
  void getAllTasksFromFireStore() async { //String uId
    // .get will return Future<QuerySnapshot<Task>> => return every thing in collection(docs) in firebase
    // use await on result because it returns => --Future--<QuerySnapshot<Task>>
    // use .snapshot instead of .get to apply realtime changes
    var querySnapshot = await FirebaseUtils.getTasksCollection() //uId
        .orderBy('dateTime', descending: true)
        .get(); //// get all tasks
    // we want to convert List<QueryDocumentSnapshot<Task>> => List<Task>
    // doc is object from List<QueryDocumentSnapshot<Task>>
    // map will convert every document snapshot into task
    tasksList = querySnapshot.docs.map((doc) {
      // access task from doc object
      return doc.data();
    }).toList(); // map return iterable so we will convert it to list

    // print all tasksList
    // for (int i = 0; i < tasksList.length; i++) {
    //   print(tasksList[i].title);
    // }

    //// filter tasks based on select date that user choosed
    // .where => has for loop , looping on every task in the list
    // if select date of task == select date of user => true
    // after filtering it will take the true results and put it in new list
    // that's why we will update the tasksList
    
    tasksList = tasksList.where(
      (task) {
        if (selectDate.day == task.dateTime.day &&
            selectDate.month == task.dateTime.month &&
            selectDate.year == task.dateTime.year) {
          return true;
        } else {
          return false;
        }
      },
    ).toList(); // Iterable<Task> => List<Task>

    // /// sorting - ordering based on which one added first
    // tasksList.sort((task1, task2) {
    //   return task1.dateTime.compareTo(task2.dateTime);
    // });

    notifyListeners();
  }
*/

  Future<void> getAllTasksFromFireStore() async {
    FirebaseUtils.getTasksCollection()
        .orderBy('dateTime', descending: false)
        .snapshots()
        .listen((querySnapshot) {
      tasksList = querySnapshot.docs.map((doc) {
        return doc.data();
      }).toList();

      print('Fetched ${tasksList.length} tasks from Firestore');

      tasksList = tasksList.where((task) {
        return selectDate.day == task.dateTime.day &&
            selectDate.month == task.dateTime.month &&
            selectDate.year == task.dateTime.year;
      }).toList();

      notifyListeners();
    });
  }

  void changeSelectDate(DateTime newDate, String uId) {
    selectDate = newDate; // change the date to the selected date by user
    // we want when clicking on newDate calling getAllTasksFromFireStore because there we filtering based on selectedDates
    // we call it also after adding new task on bottom sheet to update list
    getAllTasksFromFireStore(); //uId
    // notifyListeners();
  }

  void updateTask(Task updatedTask) {//, String uId
    for (int i = 0; i < tasksList.length; i++) {
      if (tasksList[i].id == updatedTask.id) {
        tasksList[i] = updatedTask;
        notifyListeners();
        break; // Exit the loop once the task is found and updated
      }
    }
    getAllTasksFromFireStore(); //uId
  }

  // Future<void> updateTask(Task task) async {
  //   await FirebaseUtils.updateTaskFromFireStore(task);
  //   getAllTasksFromFireStore();
  // }
}
