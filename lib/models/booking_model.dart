class BookingDetails{
  late String ticketId;
  late String tokenNumber;
  late String name;
  late String courseCode;
  late String date;
  late List<String> slots;

  BookingDetails({
    required this.ticketId,
    required this.tokenNumber,
    required this.name,
    required this.courseCode,
    required this.date,
    required this.slots,
  });

  Map<String, dynamic> getBookingDetails() {
    return {
      'ticketId':ticketId,
      'tokenNumber': tokenNumber,
      'name': name,
      'courseCode': courseCode,
      'date': date,
      'slots': slots,
    };
  }
}