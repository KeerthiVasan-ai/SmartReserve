import 'dart:math';
import 'package:flutter/material.dart';
import 'package:smart_reserve/core/theme/app_fonts.dart';

/// A glassmorphism-style card showing weekly slot usage with an animated
/// circular progress ring.
class WeeklySlotUsageWidget extends StatelessWidget {
  final int allotted;
  final int used;

  const WeeklySlotUsageWidget({
    super.key,
    required this.allotted,
    required this.used,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = (allotted - used).clamp(0, allotted);
    final ratio = allotted > 0 ? used / allotted : 0.0;

    // Colour shifts green → amber → red based on usage
    final Color progressColor;
    if (ratio < 0.5) {
      progressColor = const Color(0xFF2E7D32); // green
    } else if (ratio < 0.8) {
      progressColor = const Color(0xFFF9A825); // amber
    } else {
      progressColor = const Color(0xFFC62828); // red
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.70)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.45),
              Colors.white.withOpacity(0.18),
            ],
          ),
        ),
        child: Row(
          children: [
            // Circular progress ring
            SizedBox(
              width: 56,
              height: 56,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: ratio.clamp(0.0, 1.0)),
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeOutCubic,
                builder: (context, value, _) {
                  return CustomPaint(
                    painter: _SlotRingPainter(
                      progress: value,
                      progressColor: progressColor,
                      trackColor: const Color(0xFF124076).withOpacity(0.12),
                    ),
                    child: Center(
                      child: Text(
                        '$used/$allotted',
                        style: AppFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF124076),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            // Text info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weekly Slot Usage',
                    style: AppFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF124076),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$used of $allotted slots used this week',
                    style: AppFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
            // Remaining chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: progressColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: progressColor.withOpacity(0.3)),
              ),
              child: Text(
                '$remaining left',
                style: AppFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: progressColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter that draws a circular progress arc.
class _SlotRingPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final Color trackColor;

  _SlotRingPainter({
    required this.progress,
    required this.progressColor,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 5.0;
    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );

    // Track (background ring)
    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = trackColor
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, 0, 2 * pi, false, trackPaint);

    // Progress arc
    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = progressColor
      ..strokeCap = StrokeCap.round;

    // Start from top (-π/2) and sweep clockwise
    canvas.drawArc(rect, -pi / 2, 2 * pi * progress, false, progressPaint);
  }

  @override
  bool shouldRepaint(_SlotRingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.progressColor != progressColor;
}
