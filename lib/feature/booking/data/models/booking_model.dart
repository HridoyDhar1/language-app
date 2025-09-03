class Booking {
  final String teacherName;
  final String language;
  final String date;
  final String time;
  final double price;
 final String teacherId; 
 final String meetingId; 
  final String meetingLink;
  Booking({
    required this.teacherName,
    required this.language,
    required this.date,
    required this.time,
    required this.teacherId,
    required this.price,
    required this.meetingId,
    this.meetingLink = '',
  });
}
