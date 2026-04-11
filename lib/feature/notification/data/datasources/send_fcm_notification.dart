import 'dart:convert';
import 'dart:developer' as dev;

import 'package:googleapis_auth/auth_io.dart';
import 'package:smart_reserve/core/services/gcp_credentials.dart';
import 'package:smart_reserve/core/services/gcp_logging_service.dart';

class SendFCMNotification {
  /// Sends a push notification via FCM HTTP v1 API to the given topic.
  static Future<bool> sendToTopic({
    required String topic,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    try {
      final creds = GCPCredentials.instance;
      final projectId = creds.projectId;

      dev.log(
        'Sending FCM: project=$projectId, topic=$topic, title=$title',
        name: 'SendFCMNotification',
      );

      // 1. Obtain OAuth2 access token
      final authClient = await clientViaServiceAccount(
        creds.serviceAccountCredentials,
        ['https://www.googleapis.com/auth/firebase.messaging'],
      );

      // 2. Build the FCM v1 request
      final url = Uri.parse(
        'https://fcm.googleapis.com/v1/projects/$projectId/messages:send',
      );

      final payload = {
        'message': {
          'topic': topic,
          'notification': {'title': title, 'body': body},
          if (data != null) 'data': data,
          'android': {
            'priority': 'high',
          },
          'apns': {
            'headers': {
              'apns-priority': '10',
            },
            'payload': {
              'aps': {
                'content-available': 1,
                'sound': 'default',
              },
            },
          },
        },
      };

      dev.log(
        'FCM Request URL: $url',
        name: 'SendFCMNotification',
      );
      dev.log(
        'FCM Payload: ${jsonEncode(payload)}',
        name: 'SendFCMNotification',
      );

      final response = await authClient.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      authClient.close();

      if (response.statusCode == 200) {
        dev.log(
          'FCM sent successfully to topic=$topic, response=${response.body}',
          name: 'SendFCMNotification',
        );
        GCPLog.info('FCM notification sent to topic: $topic');
        return true;
      } else {
        dev.log(
          'FCM send failed: status=${response.statusCode}, body=${response.body}',
          name: 'SendFCMNotification',
        );
        GCPLog.error(
          'FCM send failed: ${response.statusCode}',
          error: response.body,
        );
        return false;
      }
    } catch (e, st) {
      dev.log('FCM send error: $e\n$st', name: 'SendFCMNotification');
      GCPLog.error('FCM send error', error: e);
      return false;
    }
  }
}
