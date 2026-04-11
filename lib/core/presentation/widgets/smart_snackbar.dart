import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:smart_reserve/core/theme/app_fonts.dart';

enum SmartSnackBarType { success, error, warning, info }

class SmartSnackBar extends StatefulWidget {
  final String title;
  final String message;
  final SmartSnackBarType type;
  final VoidCallback onDismiss;
  final Duration duration;

  const SmartSnackBar({
    super.key,
    required this.title,
    required this.message,
    required this.type,
    required this.onDismiss,
    this.duration = const Duration(seconds: 4),
  });

  static void show({
    required BuildContext context,
    required String title,
    required String message,
    required SmartSnackBarType type,
    Duration duration = const Duration(seconds: 4),
  }) {
    final overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          left: 16,
          right: 16,
          child: SmartSnackBar(
            title: title,
            message: message,
            type: type,
            duration: duration,
            onDismiss: () {
              overlayEntry.remove();
            },
          ),
        );
      },
    );

    overlayState.insert(overlayEntry);
  }

  // Helper methods for quick access
  static void showSuccess(BuildContext context, String message, {String title = "Success"}) {
    show(context: context, title: title, message: message, type: SmartSnackBarType.success);
  }

  static void showError(BuildContext context, String message, {String title = "Error"}) {
    show(context: context, title: title, message: message, type: SmartSnackBarType.error);
  }

  static void showWarning(BuildContext context, String message, {String title = "Warning"}) {
    show(context: context, title: title, message: message, type: SmartSnackBarType.warning);
  }

  static void showInfo(BuildContext context, String message, {String title = "Info"}) {
    show(context: context, title: title, message: message, type: SmartSnackBarType.info);
  }

  @override
  State<SmartSnackBar> createState() => _SmartSnackBarState();
}

class _SmartSnackBarState extends State<SmartSnackBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
       vsync: this,
       duration: const Duration(milliseconds: 600),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _controller.forward();

    _dismissTimer = Timer(widget.duration, () {
      _dismiss();
    });
  }

  void _dismiss() {
    _controller.reverse().then((_) {
      widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Color get _baseColor {
    switch (widget.type) {
      case SmartSnackBarType.success:
        return const Color(0xFF15F5BA);
      case SmartSnackBarType.error:
        return const Color(0xFFE6A4B4);
      case SmartSnackBarType.warning:
        return const Color(0xFFFFFB73);
      case SmartSnackBarType.info:
        return const Color(0xFF45BDFE);
    }
  }

  IconData get _icon {
    switch (widget.type) {
      case SmartSnackBarType.success:
        return Icons.check_circle_rounded;
      case SmartSnackBarType.error:
        return Icons.error_rounded;
      case SmartSnackBarType.warning:
        return Icons.warning_rounded;
      case SmartSnackBarType.info:
        return Icons.info_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
            if (details.primaryDelta! < -10) {
              _dismiss();
            }
          },
          child: Material(
             color: Colors.transparent,
             child: ClipRRect(
               borderRadius: BorderRadius.circular(20),
               child: BackdropFilter(
                 filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                 child: Container(
                   padding: const EdgeInsets.all(16),
                   decoration: BoxDecoration(
                     color: Colors.white.withOpacity(0.12),
                     borderRadius: BorderRadius.circular(20),
                     border: Border.all(
                       color: _baseColor.withOpacity(0.5),
                       width: 1.5,
                     ),
                     boxShadow: [
                       BoxShadow(
                         color: Colors.black.withOpacity(0.1),
                         blurRadius: 10,
                         offset: const Offset(0, 4),
                       ),
                     ],
                   ),
                   child: Column(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       Row(
                         children: [
                           Container(
                             padding: const EdgeInsets.all(8),
                             decoration: BoxDecoration(
                               color: _baseColor.withOpacity(0.2),
                               shape: BoxShape.circle,
                             ),
                             child: Icon(
                               _icon,
                               color: _baseColor,
                               size: 24,
                             ),
                           ),
                           const SizedBox(width: 16),
                           Expanded(
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               mainAxisSize: MainAxisSize.min,
                               children: [
                                 Text(
                                   widget.title,
                                   style: AppFonts.poppins(
                                     fontWeight: FontWeight.bold,
                                     fontSize: 16,
                                     color: Colors.black87,
                                   ),
                                 ),
                                 Text(
                                   widget.message,
                                   style: AppFonts.poppins(
                                     fontSize: 13,
                                     color: Colors.black54,
                                   ),
                                 ),
                               ],
                             ),
                           ),
                         ],
                       ),
                       const SizedBox(height: 12),
                       // Progress bar
                       TweenAnimationBuilder<double>(
                         duration: widget.duration,
                         tween: Tween<double>(begin: 1.0, end: 0.0),
                         builder: (context, value, child) {
                           return LinearProgressIndicator(
                             value: value,
                             backgroundColor: _baseColor.withOpacity(0.1),
                             valueColor: AlwaysStoppedAnimation<Color>(_baseColor),
                             minHeight: 3,
                             borderRadius: BorderRadius.circular(10),
                           );
                         },
                       ),
                     ],
                   ),
                 ),
               ),
             ),
          ),
        ),
      ),
    );
  }
}
