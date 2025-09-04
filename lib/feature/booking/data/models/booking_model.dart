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
  factory Booking.fromMap(Map<String, dynamic> map, String id) {
    return Booking(
      teacherName: map['teacherName'] ?? '',
      language: map['language'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      teacherId: map['teacherId'] ?? '',
      meetingId: map['meetingId'] ?? '',
      meetingLink: map['meetingLink'] ?? '',
 // 🔹 map userId
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'teacherName': teacherName,
      'language': language,
      'date': date,
      'time': time,
      'price': price,
      'teacherId': teacherId,
      'meetingId': meetingId,
      'meetingLink': meetingLink,

    };
  }

}
