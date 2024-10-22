class MyUser {
  static const String collectionName = 'users';
  String id; // to access specific user
  String name;
  String email;
  String password;
  String role; // "patient" or "caregiver"
  // final String relationship; // optional, for caregivers
  // String patientName; // optional, for caregivers
  MyUser(
      {required this.id,
      required this.name,
      required this.email,
      required this.password,
      required this.role,
      // this.relationship = '',
      // this.patientName = '',
      });

  // json to object
  MyUser.fromFireStore(Map<String, dynamic> data)
      : this(
            id: data['id'],
            name: data['name'],
            email: data['email'],
            password: data['password'],
            role: data['role'],
            // patientName: data['patientName']
            );

  // object to json
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      // 'patientName': patientName
    };
  }
}
