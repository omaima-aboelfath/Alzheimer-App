// data class

class Task {
  static const String collectionName = 'tasks';
  String id; // to get each task, not required to use auto-id
  String title;
  String description;
  DateTime dateTime;
  bool isDone;
  Task(
      {this.id = '',
      required this.title,
      required this.description,
      required this.dateTime,
      this.isDone = false});

  // take data from firebase : json => object
  // send data to firebase : object => json

  // OR use  default constructor
  Task.fromFireStore(Map<String, dynamic> map)
      : this(
            id: map['id'] as String, // casting 'optional'
            title: map['title'],
            description: map['description'],
            dateTime: DateTime.fromMillisecondsSinceEpoch(
                map['dateTime']), // to convert int to DateTime
            isDone: map['isDone']);

  // object => json = map
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': dateTime.millisecondsSinceEpoch, // to convert DateTime to int
      'isDone': isDone
    };
  }
}
