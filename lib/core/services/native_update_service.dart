import 'package:flutter/services.dart';
import 'dart:developer' as dev;
import 'package:smart_reserve/core/services/gcp_logging_service.dart';

class NativeUpdateService {
  static const MethodChannel _channel = MethodChannel('smart_reserve/in_app_update');

  /// Checks for any available updates on the Play Store.
  /// If an update is available, it triggers the native IMMEDIATE update UI.
  static Future<void> checkForUpdate() async {
    try {
      dev.log('Initiating native update check...', name: 'NativeUpdateService');
      final String? result = await _channel.invokeMethod('checkForUpdate');
      dev.log('Update check result: $result', name: 'NativeUpdateService');
      GCPLog.info('Native in-app update check: $result');
    } on PlatformException catch (e) {
      dev.log('Native update check failed: ${e.message}', name: 'NativeUpdateService');
      
      // We don't want to log "UPDATE_CANCELED" or "No update available" as errors to GCP, 
      // just as info or warnings if needed.
      if (e.code == 'UPDATE_CANCELED') {
        GCPLog.warning('User canceled the mandatory in-app update');
      } else if (e.code == 'UPDATE_ERROR') {
        GCPLog.error('Error during native in-app update check', error: e.message);
      } else {
        GCPLog.info('Native update status: ${e.code} - ${e.message}');
      }
    } catch (e) {
      dev.log('Unexpected error during update check: $e', name: 'NativeUpdateService');
      GCPLog.error('Unexpected error in NativeUpdateService', error: e);
    }
  }
}
