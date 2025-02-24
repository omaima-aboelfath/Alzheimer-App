import 'package:intl/intl.dart';

class DateTimeUtils {
  static final DateFormat defaultFormat = DateFormat('dd-MM-yyyy hh:mm a');
  static final DateFormat short = DateFormat('dd-MM');

  static String format(DateTime dateTime) {
    return defaultFormat.format(dateTime);
  }

  static String shortFormat(DateTime dateTime) {
    return short.format(dateTime);
  }

  static String formatDelay(Duration delay) {
    final days = delay.inDays;
    final hours = delay.inHours % 24; // Remaining hours after days
    final minutes = delay.inMinutes % 60; // Remaining minutes after hours
    final seconds = delay.inSeconds % 60; // Remaining seconds after minutes

    // Construct a readable delay string
    final parts = [
      if (days > 0) '$days ${days == 1 ? 'day' : 'days'}',
      if (hours > 0) '$hours ${hours == 1 ? 'hour' : 'hours'}',
      if (minutes > 0) '$minutes ${minutes == 1 ? 'minute' : 'minutes'}',
      if (seconds > 0) '$seconds ${seconds == 1 ? 'second' : 'seconds'}',
    ];

    // Join the parts with commas and "and" for readability
    if (parts.isEmpty) {
      return 'less than a second';
    } else if (parts.length == 1) {
      return parts[0];
    } else {
      return '${parts.sublist(0, parts.length - 1).join(', ')} and ${parts.last}';
    }
  }

  //   static String formatDelay(Duration delay) {
//   if (delay.inDays > 0) {
//     return '${delay.inDays} days';
//   } else if (delay.inHours > 0) {
//     return '${delay.inHours} hours';
//   } else if (delay.inMinutes > 0) {
//     return '${delay.inMinutes} minutes';
//   } else {
//     return 'less than a minute';
//   }
// }
}
