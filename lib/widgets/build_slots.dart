import 'package:flutter/material.dart';
import '../services/fetch_times.dart';

class BuildSlots extends StatefulWidget {
  final Map<String, bool> timeSlots;
  final Function(String) onSlotsSelected;
  final List<String> selectedSlots;

  const BuildSlots({
    required this.timeSlots,
    required this.onSlotsSelected,
    required this.selectedSlots,
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
    Color buttonColor =
    isAvailable ? (isSelected ? Colors.grey : Colors.green) : Colors.red;

    return ElevatedButton(
      onPressed: () {
        if (isAvailable) {
          widget.onSlotsSelected(slot);
        }
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(buttonColor),
      ),
      /// To make a widget to fit - Need to code review.
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          slot,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16, // or whatever size you want
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