import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'dart:ui';
import "package:intl/intl.dart";
import 'package:smart_reserve/core/theme/app_fonts.dart';
import 'package:smart_reserve/feature/auth/presentation/screens/verify_screen.dart';
import 'package:smart_reserve/core/presentation/widgets/background_shapes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_reserve/feature/booking/presentation/providers/booking_provider.dart';
import 'package:smart_reserve/core/presentation/widgets/smart_snackbar.dart';

import 'package:smart_reserve/core/presentation/widgets/custom_app_bar.dart';
import 'package:smart_reserve/core/presentation/widgets/custom_button.dart';
import 'package:smart_reserve/feature/booking/presentation/widgets/slots_widget.dart';
import 'package:smart_reserve/feature/booking/presentation/widgets/weekly_slot_usage_widget.dart';
import 'package:smart_reserve/core/presentation/widgets/custom_text_field.dart';
import 'package:smart_reserve/core/presentation/widgets/loading_overlay.dart';

import 'package:smart_reserve/feature/booking/domain/models/booking_model.dart';
import 'package:smart_reserve/feature/booking/data/datasources/fetch_slot_booker.dart';
import 'package:smart_reserve/feature/notification/presentation/providers/notification_provider.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final BookingDetails? existingBooking;
  final String? editingSlot;

  const BookingScreen({Key? key, this.existingBooking, this.editingSlot})
    : super(key: key);

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController tokenNumber;
  late TextEditingController name;
  late TextEditingController courseCode;
  late TextEditingController date;

  void _onCourseCodeChanged() {
    ref.read(bookingProvider.notifier).updateCourseCode(courseCode.text);
  }

  @override
  void initState() {
    super.initState();
    tokenNumber = TextEditingController();
    name = TextEditingController();
    courseCode = TextEditingController();
    date = TextEditingController();

    // Initialize provider data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.existingBooking != null) {
        ref
            .read(bookingProvider.notifier)
            .initializeForEdit(
              widget.existingBooking!,
              editingSlot: widget.editingSlot,
            );
      } else {
        ref.read(bookingProvider.notifier).initialize();
      }
    });

    courseCode.addListener(_onCourseCodeChanged);
  }

  @override
  void dispose() {
    tokenNumber.dispose();
    name.dispose();
    courseCode.dispose();
    date.dispose();
    super.dispose();
  }

  void _showSlotBookerDialog(
    BuildContext context,
    String date,
    String slot,
  ) async {
    // Show loading dialog first
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final bookerInfo = await FetchSlotBooker.fetchBooker(date, slot);

    // Pop loading
    if (context.mounted) Navigator.of(context).pop();

    if (!context.mounted) return;

    if (bookerInfo == null) {
      SmartSnackBar.showError(
        context,
        'The booking information for this slot is currently unavailable.',
        title: 'Info Not Found',
      );
      return;
    }

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (ctx) => Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
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
              child: Material(
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header icon
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF124076).withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: Color(0xFF124076),
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Slot Booked By',
                      style: AppFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF124076),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Text(
                        slot,
                        style: AppFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Info rows
                    _buildInfoRow(
                      Icons.person_outline,
                      'Name',
                      bookerInfo['name']!,
                    ),
                    const SizedBox(height: 10),
                    _buildInfoRow(
                      Icons.badge_outlined,
                      'Staff ID',
                      bookerInfo['tokenNumber']!,
                    ),
                    const SizedBox(height: 10),
                    _buildInfoRow(
                      Icons.subject_rounded,
                      'Course Code',
                      bookerInfo['courseCode']!,
                    ),
                    const SizedBox(height: 24),
                    // Action buttons
                    Builder(
                      builder: (_) {
                        final currentUid =
                            FirebaseAuth.instance.currentUser?.uid ?? '';
                        final isOwnSlot =
                            bookerInfo['uid'] == currentUid;

                        if (isOwnSlot) {
                          // Own slot — only show Close
                          return Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.green.withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.check_circle_outline,
                                      size: 14,
                                      color: Colors.green.shade700,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'This is your booking',
                                      style: AppFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.green.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => Navigator.of(ctx).pop(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey.shade200,
                                    foregroundColor: const Color(0xFF124076),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    'Close',
                                    style: AppFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }

                        // Other user's slot — show Close + Request
                        return Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => Navigator.of(ctx).pop(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey.shade200,
                                  foregroundColor: const Color(0xFF124076),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Close',
                                  style: AppFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                  if (!context.mounted) return;
                                  _showCourseCodeBottomSheet(
                                    context,
                                    slot: slot,
                                    date: date,
                                    bookerInfo: bookerInfo,
                                  );
                                },
                                icon: const Icon(Icons.swap_horiz, size: 18),
                                label: Text(
                                  'Request',
                                  style: AppFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF124076),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                            ),
                          ],
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
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.6)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF124076), size: 20),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: AppFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: AppFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF124076),
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  void _showCourseCodeBottomSheet(
    BuildContext context, {
    required String slot,
    required String date,
    required Map<String, String> bookerInfo,
  }) {
    final courseCodeController = TextEditingController();
    bool isSending = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.6),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0.55),
                          Colors.white.withOpacity(0.25),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Drag handle
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Header
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF124076).withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.swap_horiz_rounded,
                            color: Color(0xFF124076),
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Request Slot',
                          style: AppFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF124076),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Enter your course code for this slot',
                          style: AppFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Slot & Date info chips
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildChip(Icons.access_time, slot),
                            const SizedBox(width: 8),
                            _buildChip(Icons.calendar_today, date),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Course Code text field
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: const Color(0xFF124076).withOpacity(0.2),
                            ),
                          ),
                          child: TextField(
                            controller: courseCodeController,
                            textCapitalization: TextCapitalization.characters,
                            style: AppFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF124076),
                            ),
                            decoration: InputDecoration(
                              hintText: 'e.g. CS3401',
                              hintStyle: AppFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey.shade400,
                              ),
                              labelText: 'Course Code',
                              labelStyle: AppFonts.poppins(
                                fontSize: 14,
                                color: const Color(0xFF124076).withOpacity(0.7),
                              ),
                              prefixIcon: const Icon(
                                Icons.subject_rounded,
                                color: Color(0xFF124076),
                                size: 20,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Send Request button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: isSending
                              ? const Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                    ),
                                  ),
                                )
                              : ElevatedButton.icon(
                                  onPressed: () async {
                                    final code =
                                        courseCodeController.text.trim();
                                    if (code.isEmpty) {
                                      SmartSnackBar.showWarning(
                                        context,
                                        'You must enter a course code to send a request.',
                                        title: 'Code Required',
                                      );
                                      return;
                                    }

                                    setSheetState(() => isSending = true);

                                    final message =
                                        await NotificationService.sendRequest(
                                      bookingId:
                                          bookerInfo['ticketId'] ?? '',
                                      slotInfo: slot,
                                      date: date,
                                      requestedToUid:
                                          bookerInfo['uid'] ?? '',
                                      requestedToName:
                                          bookerInfo['name'] ?? '',
                                      courseCode: code,
                                    );

                                    if (ctx.mounted) {
                                      Navigator.of(ctx).pop();
                                    }
                                    if (context.mounted) {
                                      SmartSnackBar.showSuccess(
                                        context,
                                        message,
                                        title: "Request Sent",
                                      );
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.send_rounded,
                                    size: 18,
                                  ),
                                  label: Text(
                                    'Send Request',
                                    style: AppFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF124076),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    elevation: 0,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF124076).withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF124076)),
          const SizedBox(width: 5),
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

  Future<void> _selectDate() async {
    DateTime? picker = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 20)),
    );

    if (picker != null) {
      ref.read(bookingProvider.notifier).setDate(picker);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen for side effects (success/error)
    ref.listen(bookingProvider, (previous, next) {
      if (next.errorMessage != null) {
        SmartSnackBar.showError(context, next.errorMessage!, title: "Booking Error");
        ref.read(bookingProvider.notifier).resetMessages();
      }

      if (next.successMessage != null) {
        SmartSnackBar.showSuccess(context, next.successMessage!, title: "Success");

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) {
              return VerifyScreen(
                bookingDetails: next.bookingDetails,
                isEditing: next.isEditing,
                oldSlot:
                    next.editingSlot ??
                    (next.isEditing
                        ? next.originalBooking?.slots.firstOrNull
                        : null),
                oldDate: next.isEditing ? next.originalBooking?.date : null,
              );
            },
          ),
          (route) => false,
        );

        ref.read(bookingProvider.notifier).resetMessages();
      }
    });

    final bookingState = ref.watch(bookingProvider);
    final details = bookingState.bookingDetails;

    // Sync controllers with state
    if (details.tokenNumber.isNotEmpty &&
        tokenNumber.text != details.tokenNumber) {
      tokenNumber.text = details.tokenNumber;
    }
    if (details.name.isNotEmpty && name.text != details.name) {
      name.text = details.name;
    }
    if (details.date.isNotEmpty && date.text != details.date) {
      date.text = details.date;
    }
    if (details.courseCode.isNotEmpty &&
        courseCode.text != details.courseCode) {
      courseCode.removeListener(_onCourseCodeChanged);
      courseCode.text = details.courseCode;
      courseCode.addListener(_onCourseCodeChanged);
    }

    return AttractiveLoadingOverlay(
      isLoading: bookingState.isLoading || bookingState.isSubmitting,
      message: bookingState.isSubmitting ? "Booking In Progress" : "Fetching Details",
      child: BackgroundShapes(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: CustomAppBar(
            title: bookingState.isEditing ? "Edit Booking" : "Book your Slot",
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF124076)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: bookingState.isLoading
              ? const SizedBox.shrink()
              : ListView(
                  children: [
                    Center(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const SizedBox(height: 40),
                            BuildTextForm(
                              controller: tokenNumber,
                              label: "Staff Id",
                              readOnly: true,
                              prefixIcon: const Icon(Icons.token),
                            ),
                            const SizedBox(height: 10.0),
                            BuildTextForm(
                              controller: name,
                              label: "Name",
                              readOnly: true,
                              prefixIcon: const Icon(Icons.person),
                            ),
                            const SizedBox(height: 10.0),
                            BuildTextForm(
                              controller: courseCode,
                              label: "Course Code",
                              readOnly: false,
                              prefixIcon: const Icon(Icons.subject),
                            ),
                            const SizedBox(height: 10.0),
                            // Hall Selection
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25.0,
                                vertical: 4.0,
                              ),
                              child: DropdownButtonFormField<String>(
                                value: bookingState.selectedHall,
                                decoration: const InputDecoration(
                                  labelText: "Select Hall",
                                  prefixIcon: Icon(Icons.meeting_room),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xFF124076),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Color(0xFF124076),
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Color(0xFF124076),
                                ),
                                items: ['2216-Hall', 'CompScE', 'Pheonix']
                                    .map((String hall) {
                                      return DropdownMenuItem<String>(
                                        value: hall,
                                        child: Text(
                                          hall,
                                          style: AppFonts.poppins(
                                            color: const Color(0xFF124076),
                                          ),
                                        ),
                                      );
                                    })
                                    .toList(),
                                onChanged: bookingState.isEditing
                                    ? null
                                    : (String? newValue) {
                                        if (newValue != null) {
                                          ref
                                              .read(bookingProvider.notifier)
                                              .updateHall(newValue);
                                        }
                                      },
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            BuildTextForm(
                              controller: date,
                              label: "Date",
                              readOnly: true,
                              prefixIcon: const Icon(Icons.date_range),
                              onTap: _selectDate,
                              errorText: bookingState.dateError,
                            ),
                            const SizedBox(height: 10.0),
                            // Weekly slot usage indicator
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 350),
                              child: (bookingState.bookingDetails.date.isNotEmpty &&
                                      bookingState.selectedHall == '2216-Hall' &&
                                      bookingState.weeklyAllottedSlots > 0)
                                  ? WeeklySlotUsageWidget(
                                      key: ValueKey(
                                        '${bookingState.weeklyUsedSlots}_${bookingState.weeklyAllottedSlots}',
                                      ),
                                      allotted: bookingState.weeklyAllottedSlots,
                                      used: bookingState.weeklyUsedSlots,
                                    )
                                  : const SizedBox.shrink(),
                            ),
                            const SizedBox(height: 10.0),
                            if (bookingState.selectedHall == '2216-Hall')
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 25.0,
                                ),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Select the Slots",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF124076),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            // Show hint when editing and date changed
                            if (bookingState.isEditing &&
                                bookingState.originalBooking != null &&
                                details.date.isNotEmpty &&
                                details.date !=
                                    bookingState.originalBooking!.date)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 25.0,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.amber.shade300,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline,
                                        color: Colors.amber.shade700,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          "Editing: ${bookingState.editingSlot ?? bookingState.originalBooking!.slots.join(', ')} on ${bookingState.originalBooking!.date}",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.amber.shade900,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            if (bookingState.isEditing &&
                                bookingState.originalBooking != null &&
                                details.date.isNotEmpty &&
                                details.date !=
                                    bookingState.originalBooking!.date)
                              const SizedBox(height: 10.0),
                            if (bookingState.selectedHall == '2216-Hall')
                              BuildSlots(
                                timeSlots: bookingState.timeSlots,
                                disabledReasons: bookingState.disabledReasons,
                                onSlotsSelected: (slot) => ref
                                    .read(bookingProvider.notifier)
                                    .toggleSlot(slot),
                                onSlotLongPress: (slot) =>
                                    _showSlotBookerDialog(
                                      context,
                                      details.date,
                                      slot,
                                    ),
                                selectedSlots: details.slots,
                                currentlyBookedSlots: () {
                                  if (!bookingState.isEditing)
                                    return <String>[];
                                  final isSameDate =
                                      details.date ==
                                      bookingState.originalBooking?.date;
                                  if (!isSameDate) return <String>[];
                                  if (bookingState.editingSlot != null)
                                    return [bookingState.editingSlot!];
                                  return bookingState
                                          .originalBooking
                                          ?.slots ??
                                      <String>[];
                                }(),
                              )
                            else
                              _buildTimeRangePicker(
                                context,
                                bookingState,
                                ref,
                              ),
                            const SizedBox(height: 20.0),
                            BuildElevatedButton(
                              actionOnButton: () {
                                ref
                                    .read(bookingProvider.notifier)
                                    .verifyAndSubmit();
                              },
                              buttonText: bookingState.isEditing
                                  ? "UPDATE BOOKING"
                                  : "PROCEED TO BOOK",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildTimeRangePicker(
    BuildContext context,
    BookingState state,
    WidgetRef ref,
  ) {
    Future<void> selectTime(bool isStartTime) async {
      final initialTime = TimeOfDay.now();
      final picked = await showTimePicker(
        context: context,
        initialTime: initialTime,
      );

      if (picked != null) {
        // Format to HH:mm
        final formatted =
            "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";

        if (isStartTime) {
          ref
              .read(bookingProvider.notifier)
              .updateTimeRange(formatted, state.selectedEndTime);
        } else {
          ref
              .read(bookingProvider.notifier)
              .updateTimeRange(state.selectedStartTime, formatted);
        }
      }
    }

    String formatTime(String? time) {
      if (time == null || time.isEmpty) return "";
      if (state.selectedHall == '2216-Hall') return time;
      try {
        final dt = DateFormat('HH:mm').parse(time);
        return DateFormat('hh:mm a').format(dt);
      } catch (e) {
        return time;
      }
    }

    // Controllers for display
    final startCtrl = TextEditingController(
      text: formatTime(state.selectedStartTime),
    );
    final endCtrl = TextEditingController(
      text: formatTime(state.selectedEndTime),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.0),
          child: Text(
            "Select Time Range",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF124076),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: BuildTextForm(
                controller: startCtrl,
                label: "Start Time",
                readOnly: true,
                prefixIcon: const Icon(Icons.access_time),
                onTap: () => selectTime(true),
              ),
            ),
            Expanded(
              child: BuildTextForm(
                controller: endCtrl,
                label: "End Time",
                readOnly: true,
                prefixIcon: const Icon(Icons.access_time_filled),
                onTap: () => selectTime(false),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
