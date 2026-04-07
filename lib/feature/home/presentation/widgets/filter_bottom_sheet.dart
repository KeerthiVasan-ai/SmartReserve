import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:smart_reserve/core/theme/app_fonts.dart';

class FilterBottomSheet extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterSelected;

  const FilterBottomSheet({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final halls = ['All', '2216-Hall', 'CompScE', 'Pheonix'];

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle/Indicator
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Filter Bookings",
              style: AppFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF124076),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Select a hall to filter your reservations",
              style: AppFonts.poppins(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: halls.map((hall) {
                final isSelected = selectedFilter == hall;
                return GestureDetector(
                  onTap: () => onFilterSelected(hall),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF124076)
                          : Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : const Color(0xFF124076).withOpacity(0.1),
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFF124076).withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ]
                          : [],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getIconForHall(hall),
                          size: 18,
                          color: isSelected ? Colors.white : const Color(0xFF124076),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          hall,
                          style: AppFonts.poppins(
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? Colors.white : const Color(0xFF124076),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  IconData _getIconForHall(String hall) {
    switch (hall) {
      case 'All':
        return Icons.apps_rounded;
      case '2216-Hall':
        return Icons.meeting_room_rounded;
      case 'CompScE':
        return Icons.computer_rounded;
      case 'Pheonix':
        return Icons.bolt_rounded;
      default:
        return Icons.room_rounded;
    }
  }
}
