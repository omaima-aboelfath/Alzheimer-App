import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  static const String collectionName = 'users';
  String id; // to access specific user
  String name;
  String email;
  String password;
  String role; // "patient" or "caregiver"
  double? latitude; // Nullable, updated when the patient's location changes
  double? longitude; // Nullable, updated when the patient's location changes
  DateTime? timestamp; // Timestamp of the last location update


  MyUser({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.latitude,
    this.longitude,
    this.timestamp,
    // this.relationship = '',
  });

  // json to object
  MyUser.fromFireStore(Map<String, dynamic> data, String documentId)
      : this(
          id: data['id'],
          name: data['name'],
          email: data['email'],
          password: data['password'],
          role: data['role'],
          latitude: data['latitude'],
    longitude: data['longitude'],
    timestamp: data['timestamp'] != null
        ? (data['timestamp'] as Timestamp).toDate()
        : null,
          // taskIds: List<String>.from(
          //     data['taskIds'] ?? []), // Ensure taskIds are parsed
        );

  // object to json
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp != null ? Timestamp.fromDate(timestamp!) : null,
      // 'taskIds': taskIds, 
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MyUser) return false;
    return id == other.id; // Compare based on unique ID
  }

  @override
  int get hashCode => id.hashCode; // Use ID for hashCode
}
