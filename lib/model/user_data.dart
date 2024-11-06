class MyUser {
  static const String collectionName = 'users';
  String id; // to access specific user
  String name;
  String email;
  String password;
  String role; // "patient" or "caregiver"
  // final String relationship; // optional, for caregivers
  List<String> taskIds; // New property to store task IDs
  MyUser({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    // this.relationship = '',
    this.taskIds = const [], // Initialize with an empty list by default
  });

  // json to object
  MyUser.fromFireStore(Map<String, dynamic> data)
      : this(
          id: data['id'],
          name: data['name'],
          email: data['email'],
          password: data['password'],
          role: data['role'],
          taskIds: List<String>.from(
              data['taskIds'] ?? []), // Ensure taskIds are parsed
        );

  // object to json
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'taskIds': taskIds, 
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
