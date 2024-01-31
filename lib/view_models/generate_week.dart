import 'package:intl/intl.dart';
import 'package:week_number/iso.dart';

String getWeekNumber(String date) {
  DateTime myDate = DateFormat("dd-MM-yyyy").parse(date);
  return myDate.weekNumber.toString();
}