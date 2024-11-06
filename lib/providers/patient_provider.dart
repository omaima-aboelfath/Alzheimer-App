import 'package:flutter/material.dart';
import 'package:graduation_app/firebase_utils.dart';
import 'package:graduation_app/model/user_data.dart';

class PatientProvider with ChangeNotifier {
  List<MyUser> patientsList = [];
  // List<MyUser> get patients => patientsList;

  Future<void> fetchPatients(String caregiverId) async {
    patientsList = await FirebaseUtils.fetchCaregiverPatients(caregiverId);
      // print("Fetched patients: ${_patients.length}"); // Add this line for debugging
    notifyListeners();
  }
}
