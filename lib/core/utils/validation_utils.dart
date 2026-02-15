import "dart:developer" as dev;
import 'package:smart_reserve/core/services/gcp_logging_service.dart';

class Validation {

  static void showToast(String message) {
    dev.log('Toast: $message');
    GCPLog.debug('Toast: $message');
  }
}
