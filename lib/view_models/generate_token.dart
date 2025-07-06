import 'dart:math';
import 'package:intl/intl.dart';

String generateToken() {

  const int randomPartLength = 10;
  const String chars = 'ABCDEFGHIJKLMNOPRSTUVWXYZ0123456789';
  Random random = Random();

  String randomPart = List.generate(
    randomPartLength,
        (_) => chars[random.nextInt(chars.length)],
  ).join();

  String month = DateFormat('MMM').format(DateTime.now()).toUpperCase();

  String year = DateFormat('yyyy').format(DateTime.now());

  return '$month$year$randomPart';
}