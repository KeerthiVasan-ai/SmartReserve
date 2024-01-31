import "package:flutter/material.dart";

class BuildSlots extends StatelessWidget {
  final Map<String, bool> timeSlots;
  final Function(String) onSlotsSelected;
  final List<String> selectedSlots;

  const BuildSlots(
      {required this.timeSlots,
      required this.onSlotsSelected,
      required this.selectedSlots,
      super.key});

  Widget _buildSlot(String slot) {
    bool isAvailable = timeSlots[slot] ?? false;
    bool isSelected = selectedSlots.contains(slot);
    Color buttonColor =
        isAvailable ? (isSelected ? Colors.grey : Colors.green) : Colors.red;

    return ElevatedButton(
      onPressed: () => {
        if (isAvailable) {onSlotsSelected(slot)}
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(buttonColor)),
      child: Text(slot,style: const TextStyle(color: Colors.white),),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             _buildSlot("08:30AM"),
             _buildSlot("09:15AM"),
             _buildSlot("10:00AM")
           ],
         ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSlot("10:55AM"),
              _buildSlot("11:40AM"),
              _buildSlot("01:30PM")
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSlot("02:15PM"),
              _buildSlot("03:00PM"),
              _buildSlot("03:45PM")
            ],
          ),
        ]
      )
    );
  }
}