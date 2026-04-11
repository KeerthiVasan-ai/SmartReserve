import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "dart:developer" as dev;
import 'package:smart_reserve/core/theme/app_fonts.dart';
import 'package:intl/intl.dart';
import 'package:smart_reserve/core/presentation/widgets/frosted_glass.dart';
import 'package:smart_reserve/feature/booking/presentation/providers/booking_provider.dart';
import 'package:smart_reserve/feature/booking/presentation/screens/booking_screen.dart';
import 'package:smart_reserve/feature/booking/domain/models/booking_model.dart';
import 'package:smart_reserve/core/services/gcp_logging_service.dart';

class BuildListBuilder extends ConsumerWidget {
  final List<DocumentSnapshot> bookings;
  final bool isDelete;
  final String uid;

  const BuildListBuilder({
    required this.bookings,
    required this.isDelete,
    required this.uid,
    super.key,
  });

  Future<void> _showDeleteDialog(
    BuildContext context,
    WidgetRef ref,
    String ticketId,
    String dateStr,
    List<dynamic> allSlots,
    String hall,
  ) async {
    List<String> selectedSlots = [];
    final DateTime now = DateTime.now();
    final DateTime bookingDate = DateFormat("dd-MM-yyyy").parse(dateStr);
    final isToday =
        bookingDate.year == now.year &&
        bookingDate.month == now.month &&
        bookingDate.day == now.day;

    // Filter valid slots for deletion
    final validSlots = allSlots.where((slot) {
      if (!isToday) return true; // Future date, all slots valid

      // Parse slot time (e.g., "09:00 - 10:00")
      try {
        final startTimeStr = slot.toString().split("-")[0].trim(); // "09:00"
        final startTimeParts = startTimeStr.split(":");
        final startHour = int.parse(startTimeParts[0]);
        final startMinute = int.parse(startTimeParts[1]);

        final slotStartTime = DateTime(
          now.year,
          now.month,
          now.day,
          startHour,
          startMinute,
        );

        // Check if current time is more than 15 minutes before slot start
        return now.isBefore(
          slotStartTime.subtract(const Duration(minutes: 15)),
        );
      } catch (e) {
        dev.log("Error parsing slot time: $slot", name: "Error");
        return false;
      }
    }).toList();

    if (validSlots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "No slots available for cancellation (less than 15 mins remaining).",
          ),
        ),
      );
      return;
    }

    if (allSlots.length == 1) {
      // Single slot case - Show confirmation dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Cancel Booking"),
          content: Text(
            "Are you sure you want to cancel the booking for ${allSlots.first}?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                GCPLog.info(
                  'User confirmed cancellation for ticket: $ticketId, slots: $allSlots',
                );
                ref
                    .read(bookingProvider.notifier)
                    .deleteBooking(uid, ticketId, dateStr, allSlots, hall: hall);
              },
              child: const Text("Yes"),
            ),
          ],
        ),
      );
    } else {
      // Multiple slots case - Show selection dialog
      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text("Select Slots to Cancel"),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: allSlots.map((slot) {
                      final isValid = validSlots.contains(slot);
                      return CheckboxListTile(
                        title: Text(
                          slot.toString(),
                          style: TextStyle(
                            color: isValid ? Colors.black : Colors.grey,
                            decoration: isValid
                                ? null
                                : TextDecoration.lineThrough,
                          ),
                        ),
                        value: selectedSlots.contains(slot),
                        onChanged: isValid
                            ? (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    selectedSlots.add(slot.toString());
                                  } else {
                                    selectedSlots.remove(slot.toString());
                                  }
                                });
                              }
                            : null, // Disable if not valid
                      );
                    }).toList(),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: selectedSlots.isEmpty
                        ? null
                        : () {
                            Navigator.pop(context);
                            GCPLog.info(
                              'User confirmed partial cancellation for ticket: $ticketId, selected: $selectedSlots',
                            );
                            ref
                                .read(bookingProvider.notifier)
                                .deleteBooking(
                                  uid,
                                  ticketId,
                                  dateStr,
                                  selectedSlots,
                                  hall: hall,
                                );
                          },
                    child: const Text("Delete Selected"),
                  ),
                ],
              );
            },
          );
        },
      );
    }
  }

  void _showEditDialog(
    BuildContext context,
    Map<String, dynamic> data,
    List<dynamic> allSlots,
  ) {
    final DateTime now = DateTime.now();
    final String dateStr = data['date'];
    final DateTime bookingDate = DateFormat("dd-MM-yyyy").parse(dateStr);
    final isToday =
        bookingDate.year == now.year &&
        bookingDate.month == now.month &&
        bookingDate.day == now.day;

    // Filter valid slots for editing (same 15-min constraint as delete)
    final validSlots = allSlots.where((slot) {
      if (!isToday) return true;
      try {
        final startTimeStr = slot.toString().split("-")[0].trim();
        final startTimeParts = startTimeStr.split(":");
        final startHour = int.parse(startTimeParts[0]);
        final startMinute = int.parse(startTimeParts[1]);
        final slotStartTime = DateTime(
          now.year,
          now.month,
          now.day,
          startHour,
          startMinute,
        );
        return now.isBefore(
          slotStartTime.subtract(const Duration(minutes: 15)),
        );
      } catch (e) {
        dev.log("Error parsing slot time: $slot", name: "Error");
        return false;
      }
    }).toList();

    if (validSlots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "No slots available for editing (less than 15 mins remaining).",
          ),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Slot to Edit"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: allSlots.map((slot) {
                final isValid = validSlots.contains(slot);
                return ListTile(
                  title: Text(
                    slot.toString(),
                    style: TextStyle(
                      color: isValid ? Colors.black : Colors.grey,
                      decoration: isValid ? null : TextDecoration.lineThrough,
                    ),
                  ),
                  enabled: isValid,
                  onTap: isValid
                      ? () {
                          Navigator.pop(context);
                          GCPLog.info(
                            'User selected specific slot to edit: $slot (ticket: ${data['ticketId']})',
                          );
                          final booking = BookingDetails.fromJson(
                            data,
                          ).copyWith(ticketId: data['ticketId']);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingScreen(
                                existingBooking: booking,
                                editingSlot: slot.toString(),
                              ),
                            ),
                          );
                        }
                      : null,
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        var data = bookings[index].data() as Map<String, dynamic>;
        final String hall = data['hall'] is String ? data['hall'] : '2216-Hall';

        String formatSlots(List<dynamic> slots) {
          if (hall == '2216-Hall') return slots.join(', ');
          return slots
              .map((slot) {
                final str = slot.toString();
                if (!str.contains('-')) return str;
                // Assumes "HH:mm - HH:mm" (start - end) or single time?
                // If it's single time (2216 style), we excluded it.
                // Non-2216 stores "HH:mm - HH:mm" in slots[0].
                try {
                  final parts = str.split('-');
                  if (parts.length != 2) return str;
                  final start = DateFormat('HH:mm').parse(parts[0].trim());
                  final end = DateFormat('HH:mm').parse(parts[1].trim());
                  return "${DateFormat('hh:mm a').format(start)} - ${DateFormat('hh:mm a').format(end)}";
                } catch (e) {
                  return str;
                }
              })
              .join(', ');
        }

        return FrostedGlassUI(
          theHeight: 110.0,
          theWidth: 200.0,
          theChild: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.bookmark),
                    const SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${data['tokenNumber']}",
                          style: AppFonts.ebGaramond(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "${data['courseCode']}",
                          style: AppFonts.ebGaramond(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "${data['date']}",
                          style: AppFonts.ebGaramond(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "Slots: ${formatSlots(data['slots'] ?? [])}",
                          style: AppFonts.ebGaramond(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    if (isDelete) const Spacer(),
                    if (isDelete)
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              final slots = data['slots'] as List<dynamic>;
                              if (slots.length == 1) {
                                // Single slot — navigate directly
                                final booking = BookingDetails.fromJson(
                                  data,
                                ).copyWith(ticketId: data['ticketId']);
                                GCPLog.info(
                                  'User initiated edit for single-slot booking: ${data['ticketId']}',
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BookingScreen(existingBooking: booking),
                                  ),
                                );
                              } else {
                                // Multiple slots — ask which one to edit
                                _showEditDialog(context, data, slots);
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              GCPLog.info(
                                'User clicked delete icon for ticket: ${data['ticketId']}',
                              );
                              _showDeleteDialog(
                                context,
                                ref,
                                data['ticketId'],
                                data['date'],
                                data['slots'],
                                hall,
                              );
                            },
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF124076).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF124076).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    hall,
                    style: AppFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF124076),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
