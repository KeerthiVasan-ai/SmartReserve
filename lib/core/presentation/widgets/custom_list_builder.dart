import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "dart:developer" as dev;
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:smart_reserve/core/presentation/widgets/frosted_glass.dart';
import 'package:smart_reserve/feature/booking/presentation/providers/booking_provider.dart';
import 'package:smart_reserve/feature/booking/presentation/screens/booking_screen.dart';
import 'package:smart_reserve/feature/booking/domain/models/booking_model.dart';

class BuildListBuilder extends ConsumerWidget {
  final List<DocumentSnapshot> bookings;
  final bool isDelete;
  final String uid;

  const BuildListBuilder(
      {required this.bookings,
      required this.isDelete,
      required this.uid,
      super.key});

  Future<void> _showDeleteDialog(
      BuildContext context,
      WidgetRef ref,
      String ticketId,
      String dateStr,
      List<dynamic> allSlots) async {
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
        return now.isBefore(slotStartTime.subtract(const Duration(minutes: 15)));
      } catch (e) {
        dev.log("Error parsing slot time: $slot", name: "Error");
        return false;
      }
    }).toList();

    if (validSlots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No slots available for cancellation (less than 15 mins remaining).")),
      );
      return;
    }

    if (allSlots.length == 1) {
      // Single slot case - Show confirmation dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Cancel Booking"),
          content: Text("Are you sure you want to cancel the booking for ${allSlots.first}?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ref.read(bookingProvider.notifier).deleteBooking(uid, ticketId, dateStr, allSlots);
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
                            decoration: isValid ? null : TextDecoration.lineThrough,
                          ),
                        ),
                        value: selectedSlots.contains(slot),
                        onChanged: isValid ? (bool? value) {
                          setState(() {
                            if (value == true) {
                              selectedSlots.add(slot.toString());
                            } else {
                              selectedSlots.remove(slot.toString());
                            }
                          });
                        } : null, // Disable if not valid
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
                    onPressed: selectedSlots.isEmpty ? null : () {
                      Navigator.pop(context);
                      ref.read(bookingProvider.notifier).deleteBooking(uid, ticketId, dateStr, selectedSlots);
                    },
                    child: const Text("Delete Selected"),
                  ),
                ],
              );
            }
          );
        },
      );
    }
  }

  void _showEditDialog(
      BuildContext context,
      Map<String, dynamic> data,
      List<dynamic> allSlots) {
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
          now.year, now.month, now.day, startHour, startMinute,
        );
        return now.isBefore(slotStartTime.subtract(const Duration(minutes: 15)));
      } catch (e) {
        dev.log("Error parsing slot time: $slot", name: "Error");
        return false;
      }
    }).toList();

    if (validSlots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No slots available for editing (less than 15 mins remaining).")),
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
                  onTap: isValid ? () {
                    Navigator.pop(context);
                    final booking = BookingDetails.fromJson(data)
                        .copyWith(ticketId: data['ticketId']);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingScreen(
                          existingBooking: booking,
                          editingSlot: slot.toString(),
                        ),
                      ),
                    );
                  } : null,
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
        return FrostedGlassUI(
          theHeight: 110.0,
          theWidth: 200.0,
          theChild: Padding(
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
                      style: GoogleFonts.ebGaramond(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      "${data['courseCode']}",
                      style: GoogleFonts.ebGaramond(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text("${data['date']}",
                        style: GoogleFonts.ebGaramond(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text("Slots: ${data['slots'].join(', ')}",
                        style: GoogleFonts.ebGaramond(
                            fontWeight: FontWeight.bold, fontSize: 16)),
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
                            final booking = BookingDetails.fromJson(data)
                                .copyWith(ticketId: data['ticketId']);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookingScreen(existingBooking: booking),
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
                          _showDeleteDialog(
                            context,
                            ref,
                            data['ticketId'],
                            data['date'],
                            data['slots'],
                          );
                        },
                      ),
                    ],
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}
