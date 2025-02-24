import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:graduation_app/utils/firebase_utils.dart';
import 'package:graduation_app/model/user_data.dart';

class PatientProvider with ChangeNotifier {
  List<MyUser> patientsList = [];
  // List<MyUser> get patients => patientsList;

  Future<void> fetchPatients(String caregiverId) async {
    patientsList = await FirebaseUtils.fetchCaregiverPatients(caregiverId);
      // print("Fetched patients: ${_patients.length}"); // Add this line for debugging
    notifyListeners();
  }

  Stream<MyUser> patientLocationStream(String userId) {
    return FirebaseFirestore.instance
        .collection(MyUser.collectionName)
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>;
      return MyUser.fromFireStore(data, snapshot.id);
    });
  }

}
