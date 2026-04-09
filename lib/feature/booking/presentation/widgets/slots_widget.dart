import 'package:flutter/material.dart';
import 'package:smart_reserve/feature/booking/data/datasources/fetch_times.dart';

class BuildSlots extends StatefulWidget {
  final Map<String, bool> timeSlots;
  final Function(String) onSlotsSelected;
  final Function(String)? onSlotLongPress;
  final Map<String, String>? disabledReasons;
  final List<String> selectedSlots;
  final List<String> currentlyBookedSlots;

  const BuildSlots({
    required this.timeSlots,
    required this.onSlotsSelected,
    this.onSlotLongPress,
    this.disabledReasons,
    required this.selectedSlots,
    this.currentlyBookedSlots = const [],
    super.key,
  });

  @override
  _BuildSlotsState createState() => _BuildSlotsState();
}

class _BuildSlotsState extends State<BuildSlots> {
  late Future<List<String>> _futureSlots;

  @override
  void initState() {
    super.initState();
    _futureSlots = FetchTimes.fetchTime();
  }

  Widget _buildSlot(String slot) {
    bool isAvailable = widget.timeSlots[slot] ?? false;
    bool isSelected = widget.selectedSlots.contains(slot);
    bool isCurrentlyBooked = widget.currentlyBookedSlots.contains(slot);

    Color buttonColor;
    if (isSelected && isCurrentlyBooked) {
      buttonColor =
          Colors.amber.shade700; // Keep amber when editing slot is selected
    } else if (isSelected) {
      buttonColor = Colors.grey;
    } else if (isCurrentlyBooked) {
      buttonColor = Colors.amber.shade700;
    } else if (isAvailable) {
      buttonColor = Colors.green;
    } else {
      buttonColor = Colors.red;
    }

    final bool isBooked = !isAvailable && !isSelected && !isCurrentlyBooked;
    final bool isGloballyDisabled = widget.disabledReasons?.containsKey(slot) ?? false;
    final String? adminReason = isGloballyDisabled ? widget.disabledReasons![slot] : null;

    return GestureDetector(
      onLongPress: isBooked
          ? () {
              if (isGloballyDisabled && adminReason != null && adminReason.isNotEmpty) {
                // Show Admin disabled reason dialog
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Admin Restriction', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
                    content: Text('This slot is globally disabled.\n\nReason: $adminReason', style: const TextStyle(fontFamily: 'Poppins', fontSize: 14)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('OK', style: TextStyle(color: Color(0xFF124076))),
                      ),
                    ],
                  ),
                );
              } else if (widget.onSlotLongPress != null) {
                widget.onSlotLongPress!(slot);
              }
            }
          : null,
      child: ElevatedButton(
        onPressed: () {
          if (isAvailable) {
            widget.onSlotsSelected(slot);
          } else if (isGloballyDisabled && adminReason != null && adminReason.isNotEmpty) {
             // Also show admin reason on simple tap so they don't get confused!
             showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Slot Disabled', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
                  content: Text('Reason: $adminReason', style: const TextStyle(fontFamily: 'Poppins', fontSize: 14)),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Close', style: TextStyle(color: Color(0xFF124076))),
                    ),
                  ],
                ),
              );
          }
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(buttonColor),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            slot,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _futureSlots,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Failed to load time slots"));
        }

        final timeSlots = snapshot.data ?? [];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.5,
            ),
            itemCount: timeSlots.length,
            itemBuilder: (context, index) {
              return _buildSlot(timeSlots[index]);
            },
          ),
        );
      },
    );
  }
}
