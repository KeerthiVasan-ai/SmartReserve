import 'dart:io';
import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import 'package:googleapis/logging/v2.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:smart_reserve/core/constants/app_constants.dart';

/// Google Cloud Logging singleton.
///
/// Usage:
///   await GCPLog.instance.setupLoggingApi();   // call once at startup
///   GCPLog.info('Booking created', userId: uid);
///   GCPLog.error('Insert failed', error: e, stacktrace: st);
class GCPLog {
  GCPLog._();
  static final GCPLog instance = GCPLog._();

  LoggingApi? _loggingApi;
  bool _isSetup = false;
  String _projectId = '';
  static const Map<String, dynamic> _serviceAccountCredentials = {
    "type": "service_account",
    "project_id": "smart-reserve-487517",
    "private_key_id": "8d441034a00ac497c943133f68d0eab4797bf373",
    "private_key":
        "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQCv5Mx1fBdRwdFV\nHkHH/DPLD0rjsiB9Q70aE5FM9PWtra1DF4m+cEshE/fozruZwpCBsFBP/SqKciyx\nqgNCDwQ8rDMDutWQqV2zl67gGezbb9R1Q1RJhLR0h1jLEYsGqETjDT3QjVDIQ5b+\na9mh4l/r/0MmkXs7n48if7oMWwimY25CnXTV1wRcqFGkZRtEGzBUojOEq7AkRsP/\nCHZ10kamsCC7Bqkxcxual+1Y1vFdfvcgWXzcSTnWsnmWcE+1uMTNn3q/fCBkgV/a\nAxqUN40DERDojNhvyZJFxfSDg4WblTQDMBhgsAMjCUcypv9SHuP6D4k1cy6O8c/s\nlcsL6iCxAgMBAAECggEAAgdT/cPOOaEle3CwKn4ny1mlh/Kg4KxObuxUZJMDmXLM\nx4lq20Iclgt5bw3sK0U2Nn5d78KRiiPFgjtN7YYChaVeCCw1seUH1aYxbsgybihi\nwWM4V98j978sSfkdjY3VD7oSQ+CZsq9CYMmbRVxjizNlia6Q/CPJB6P52tIq4MSK\nXVb7w+fGAQjVxHiYjsfSKvwFvKaaKrvFhkvI/0Pd+8KtHVvb14Xl1gSo7SZqf3qT\nNBDdzp0sB0JKanAsT/nXNG2njiQE5s/L2CAHspgDSwFE48/gt/bmWpgSt3uKiHSG\nRKhLxYzNh0nn8aHcyFImgWSgL+5mDOSUp95GSiIDgQKBgQDe1/62ETzO0EKN7wgL\n5zA0yv7wZf5O5iOC5uE+eMZDa4odkuHPZ/nT2S4cGhprLqVL2OlMrcJwnRxCc8R9\n/9TazO2t7QcTR1SPGTrLN1UTmop48ifv4P5npYkhG0oGKTmL8GivykUYDLjLq2WV\nOyyYqHX4Xhgq9WlZBsDCxrSBMQKBgQDKEICjBNsK4ARCvYuevbfoQ1D8AcRIL5oY\nqVpsgO2H8nd1yMpm6ZbZuVQagj0KwlpmsjGNbxM804FBl7NgQWSIpOhrWxuAvCh6\nx93wukjf3ri2hA8qz5k1MqzQDs0BikIt3V8J3PIZdrU4a2aAZvhzDsbxtVZn2EmS\nV4V8TYu3gQKBgQCcpo4BgwCSCcifaeboJy62DfVFHQ22fQV9obu5ZMFK57ABth1S\n5a6zg7psOtVTf0jnlqX6JzPGYktZU3RPdqY04VY7q6ILpVsF9SBldpIx47Nv7hqx\nACMWzUEmqr5Qsm4nt2qAGNqVW2wUkHoqe5yP++xiGhM3L6lM0fhzc6e0IQKBgQCI\nsoFTx4Un5kT7oZ9C1LYFuwSed9OBwjJNXMR/gvkubynB1QSYeo5C3M244ULKdJET\nyJkdRXeOPsfCyA3hoFuS1X0mo4wHm0MHTQ8oO93xFYuAbfaUz7yl8JJYbqrhz9bV\nkF0rHv3pnBUdBgth8kdCD00nV7YMqpWbGvqDDTLoAQKBgQCRolYQAKRWapEVFxR9\nSe766i3lXGlrnpvABwcI1ZaP518UCylEIV+tpuuD76ybEO+jBaRFG1kwj9tbNHcD\nkqDh64FOfWBVpCFdzvInBeozwnVz96PBNmEXVytjtm1PlpOJDSTF9zpJqxVzSXCY\nmFtpS6kRnFtxgqxX5VFrKi9Cyw==\n-----END PRIVATE KEY-----\n",
    "client_email":
        "smart-reserve-gcp@smart-reserve-487517.iam.gserviceaccount.com",
    "client_id": "108920843884847920322",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url":
        "https://www.googleapis.com/robot/v1/metadata/x509/smart-reserve-gcp%40smart-reserve-487517.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com",
  };

  /// Authenticates with GCP and initialises the Logging API.
  Future<void> setupLoggingApi() async {
    if (_isSetup) return;

    try {
      // Extract project_id from credentials
      _projectId = _serviceAccountCredentials['project_id'] ?? '';

      final credentials = ServiceAccountCredentials.fromJson(
        _serviceAccountCredentials,
      );

      final authClient = await clientViaServiceAccount(credentials, [
        LoggingApi.loggingWriteScope,
      ]);

      _loggingApi = LoggingApi(authClient);
      _isSetup = true;
      dev.log('Cloud Logging API setup for $_projectId', name: 'GCPLog');
    } catch (error) {
      dev.log('Error setting up Cloud Logging API: $error', name: 'GCPLog');
    }
  }

  // ── convenience helpers ──────────────────────

  static void info(String message, {String? userId}) =>
      instance._write(level: 'INFO', message: message, userId: userId);

  static void warning(String message, {String? userId}) =>
      instance._write(level: 'WARNING', message: message, userId: userId);

  static void error(
    String message, {
    Object? error,
    StackTrace? stacktrace,
    String? userId,
  }) => instance._write(
    level: 'ERROR',
    message: message,
    errorString: error?.toString(),
    stacktrace: stacktrace?.toString(),
    userId: userId,
  );

  static void debug(String message, {String? userId}) =>
      instance._write(level: 'DEBUG', message: message, userId: userId);

  // ── core writer ──────────────────────────────

  void _write({
    required String level,
    required String message,
    String? errorString,
    String? stacktrace,
    String? userId,
  }) {
    // Always log locally so the debug console still works.
    dev.log('[$level] $message', name: 'GCPLog');

    if (!_isSetup || _loggingApi == null) return;

    final appMode = kReleaseMode ? 'release' : 'debug';
    final logName = 'projects/$_projectId/logs/$appMode-production';

    final resource = MonitoredResource()..type = 'global';

    final Map<String, Object?> payload = {'message': message};
    if (level == 'ERROR') {
      payload['exception'] = errorString ?? 'Unidentified Exception';
      payload['stack_trace'] = stacktrace ?? '';
    }

    final logEntry = LogEntry()
      ..logName = logName
      ..jsonPayload = payload
      ..resource = resource
      ..severity = level
      ..labels = {
        'project_id': _projectId,
        'level': level.toUpperCase(),
        'app_mode': appMode,
        'user_id': userId ?? 'unknown',
        'app_version': AppConstants.APP_VERSION,
        'platform': Platform.isAndroid ? 'ANDROID' : 'IOS',
      };

    final request = WriteLogEntriesRequest()..entries = [logEntry];

    _loggingApi!.entries.write(request).catchError((dynamic e) {
      dev.log('Error writing log entry: $e', name: 'GCPLog');
      return WriteLogEntriesResponse();
    });
  }
}
