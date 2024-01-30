import "dart:math";

String generateToken() {
  const int length = 10;
  const String chars = 'ABCDEFGHIJKLMNOPRSTUVWXYZ0123456789';

  Random random = Random();
  String token = '';

  for(int i=0;i<length;i++) {
    token += chars[random.nextInt(chars.length)];
  }

  return token;
}