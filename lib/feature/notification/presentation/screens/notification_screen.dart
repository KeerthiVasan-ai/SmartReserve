import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:smart_reserve/core/theme/app_fonts.dart';
import 'package:smart_reserve/core/presentation/widgets/background_shapes.dart';
import 'package:smart_reserve/feature/notification/presentation/providers/notification_provider.dart';
import 'package:smart_reserve/feature/notification/data/datasources/fetch_notifications.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return BackgroundShapes(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          ),
          title: Text(
            'Notifications',
            style: AppFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        body: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
            stream: FetchNotifications.fetchReceivedNotifications(uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: AppFonts.poppins(fontSize: 14),
                  ),
                );
              }

              final docs = snapshot.data?.docs ?? [];

              if (docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_off_outlined,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No notifications yet',
                        style: AppFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  return _NotificationCard(data: data);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends StatefulWidget {
  final Map<String, dynamic> data;

  const _NotificationCard({required this.data});

  @override
  State<_NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<_NotificationCard> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final status = data['status'] ?? 'pending';
    final isPending = status == 'pending';
    final requesterName = data['requestedByName'] ?? 'Unknown';
    final slotInfo = data['slotInfo'] ?? '';
    final date = data['date'] ?? '';
    final notificationId = data['notificationId'] ?? '';
    final requestedBy = data['requestedBy'] ?? '';
    final requestedTo = data['requestedTo'] ?? '';
    final bookingId = data['bookingId'] ?? '';
    final initiatedAt = data['notificationInitiatedAt'] ?? '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.70)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.40),
                  Colors.white.withOpacity(0.15),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF124076).withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.swap_horiz_rounded,
                        color: Color(0xFF124076),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            requesterName,
                            style: AppFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF124076),
                            ),
                          ),
                          Text(
                            'is requesting your slot',
                            style: AppFonts.poppins(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isPending) _buildStatusChip(status),
                  ],
                ),
                const SizedBox(height: 12),

                // Slot & Date info
                Row(
                  children: [
                    _buildInfoChip(Icons.access_time, slotInfo),
                    const SizedBox(width: 8),
                    _buildInfoChip(Icons.calendar_today, date),
                  ],
                ),

                // Timestamp
                if (initiatedAt.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    initiatedAt,
                    style: AppFonts.poppins(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],

                // Action buttons (only for pending)
                if (isPending) ...[
                  const SizedBox(height: 14),
                  _isLoading
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _handleResponse(
                                  context,
                                  notificationId: notificationId,
                                  senderUid: requestedBy,
                                  receiverUid: requestedTo,
                                  accept: true,
                                  requesterName: requesterName,
                                  slotInfo: slotInfo,
                                  date: date,
                                  bookingId: bookingId,
                                ),
                                icon: const Icon(Icons.check, size: 18),
                                label: Text(
                                  'Accept',
                                  style: AppFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade600,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _handleResponse(
                                  context,
                                  notificationId: notificationId,
                                  senderUid: requestedBy,
                                  receiverUid: requestedTo,
                                  accept: false,
                                  requesterName: requesterName,
                                  slotInfo: slotInfo,
                                  date: date,
                                  bookingId: bookingId,
                                ),
                                icon: const Icon(Icons.close, size: 18),
                                label: Text(
                                  'Reject',
                                  style: AppFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade600,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                            ),
                          ],
                        ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final isAccepted = status == 'accepted';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: (isAccepted ? Colors.green : Colors.red).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (isAccepted ? Colors.green : Colors.red).withOpacity(0.3),
        ),
      ),
      child: Text(
        status.substring(0, 1).toUpperCase() + status.substring(1),
        style: AppFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isAccepted ? Colors.green.shade700 : Colors.red.shade700,
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF124076).withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF124076)),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF124076),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleResponse(
    BuildContext context, {
    required String notificationId,
    required String senderUid,
    required String receiverUid,
    required bool accept,
    String? requesterName,
    String? slotInfo,
    String? date,
    String? bookingId,
  }) async {
    setState(() => _isLoading = true);

    final message = await NotificationService.respondToRequest(
      notificationId: notificationId,
      senderUid: senderUid,
      receiverUid: receiverUid,
      accept: accept,
      requesterName: requesterName,
      slotInfo: slotInfo,
      date: date,
      bookingId: bookingId,
    );

    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}
