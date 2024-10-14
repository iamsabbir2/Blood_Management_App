import 'package:logger/logger.dart';

enum Day { MON, TUE, WED, Thu, Fri, Sat, Sun }

enum Month { Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec }

class ChatTime {
  static Logger logger = Logger();
  static String getTimes(String time) {
    DateTime currentDateTime = DateTime.now();
    DateTime dateTime = DateTime.parse(time);
    String formattedTime =
        "${dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}";
    String formattedDate = "${dateTime.day}/${dateTime.month}/${dateTime.year}";
    String formattedMonth = "${dateTime.month}";
    String formattedDay = "${dateTime.day}";
    // String formattedDayName = "${Day.values[dateTime.weekday]}";
    String formattedMonthName = "${Month.values[dateTime.month - 1]}";
    if (dateTime.subtract(const Duration(days: 2)).compareTo(currentDateTime) >
        0) {
      return formattedTime;
    }
    if (dateTime.subtract(const Duration(days: 1)).compareTo(currentDateTime) >
        0) {
      return "Yesterday";
    }
    if (dateTime.subtract(const Duration(days: 7)).compareTo(currentDateTime) >
        0) {
      return formattedMonthName;
    }

    return formattedTime;
  }
}
