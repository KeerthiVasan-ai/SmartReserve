import 'package:flutter/material.dart';
import 'package:smart_reserve/feature/booking/data/datasources/fetch_times.dart';

class BuildSlots extends StatefulWidget {
  final Map<String, bool> timeSlots;
  final Function(String) onSlotsSelected;
  final Function(String)? onSlotLongPress;
  final List<String> selectedSlots;
  final List<String> currentlyBookedSlots;

  const BuildSlots({
    required this.timeSlots,
    required this.onSlotsSelected,
    this.onSlotLongPress,
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
      buttonColor = Colors.amber.shade700; // Keep amber when editing slot is selected
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

    return GestureDetector(
      onLongPress: isBooked && widget.onSlotLongPress != null
          ? () => widget.onSlotLongPress!(slot)
          : null,
      child: ElevatedButton(
        onPressed: () {
          if (isAvailable) {
            widget.onSlotsSelected(slot);
          }
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(buttonColor),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            slot,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
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
