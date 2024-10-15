class MessageTime {
  static String getTime(String time) {
    DateTime dateTime = DateTime.parse(time);
    return "${dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}";
  }
}
