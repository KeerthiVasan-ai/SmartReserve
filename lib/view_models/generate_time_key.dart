class TimeKey {
  static String? returnTimeKey(String slot){
    var timeMap = Map.of({
      "08:30AM": '1',
      "09:15AM": '2',
      "10:00AM": '3',
      "10:55AM": '4',
      "11:40AM": '5',
      "01:30PM": '6',
      "02:15PM": '7',
      "03:00PM": '8',
      "03:45PM": '9'
    });
    return timeMap[slot];
  }
}