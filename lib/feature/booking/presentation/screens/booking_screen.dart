import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_reserve/feature/about/presentation/screens/about_screen.dart';
import 'package:smart_reserve/feature/auth/presentation/screens/verify_screen.dart';
import 'package:smart_reserve/core/presentation/widgets/background_shapes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_reserve/feature/booking/presentation/providers/booking_provider.dart';

import 'package:smart_reserve/core/presentation/widgets/custom_app_bar.dart';
import 'package:smart_reserve/core/presentation/widgets/custom_button.dart';
import 'package:smart_reserve/feature/booking/presentation/widgets/slots_widget.dart';
import 'package:smart_reserve/core/presentation/widgets/custom_text_field.dart';

import 'package:smart_reserve/feature/booking/domain/models/booking_model.dart';
import 'package:smart_reserve/feature/booking/data/datasources/fetch_slot_booker.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final BookingDetails? existingBooking;
  final String? editingSlot;

  const BookingScreen({Key? key, this.existingBooking, this.editingSlot}) : super(key: key);

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
        ref.read(bookingProvider.notifier).initializeForEdit(
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

  void _showSlotBookerDialog(BuildContext context, String date, String slot) async {
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not find booking info for this slot.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFF0F4FF),
                Color(0xFFE8EEFF),
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header icon
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF124076).withOpacity(0.1),
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
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF124076),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Text(
                  slot,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.red.shade700,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Info rows
              _buildInfoRow(Icons.person_outline, 'Name', bookerInfo['name']!),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.badge_outlined, 'Staff ID', bookerInfo['tokenNumber']!),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.subject_rounded, 'Course Code', bookerInfo['courseCode']!),
              const SizedBox(height: 24),
              // Close button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF124076),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Close',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF124076), size: 20),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
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

  Future<void> _selectDate() async {
    DateTime? picker = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 20)));

    if (picker != null) {
      ref.read(bookingProvider.notifier).setDate(picker);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen for side effects (success/error)
    ref.listen(bookingProvider, (previous, next) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage!)),
        );
        ref.read(bookingProvider.notifier).resetMessages();
      }
      
      if (next.successMessage != null) {
         ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.successMessage!)),
        );
        
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (context) {
                return VerifyScreen(
                  bookingDetails: next.bookingDetails,
                  isEditing: next.isEditing,
                  oldSlot: next.editingSlot ??
                      (next.isEditing ? next.originalBooking?.slots.firstOrNull : null),
                  oldDate: next.isEditing ? next.originalBooking?.date : null,
                );
            },
         ), (route) => false);
         
         ref.read(bookingProvider.notifier).resetMessages();
      }
    });

    final bookingState = ref.watch(bookingProvider);
    final details = bookingState.bookingDetails;

    // Sync controllers with state if needed for initial load or formatted text
    if (details.tokenNumber.isNotEmpty && tokenNumber.text != details.tokenNumber) {
        tokenNumber.text = details.tokenNumber;
    }
    if (details.name.isNotEmpty && name.text != details.name) {
        name.text = details.name;
    }
    if (details.date.isNotEmpty && date.text != details.date) {
        date.text = details.date;
    }
    if (details.courseCode.isNotEmpty && courseCode.text != details.courseCode) {
        courseCode.removeListener(_onCourseCodeChanged);
        courseCode.text = details.courseCode;
        courseCode.addListener(_onCourseCodeChanged);
    }
    


    return BackgroundShapes(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          title: bookingState.isEditing ? "Edit Booking" : "Book your Slot",
          leading: IconButton(
            icon: const Icon(Icons.info_outline, color: Color(0xFF124076)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
        ),
        body: bookingState.isLoading 
             ? const Center(child: CircularProgressIndicator()) 
             : Stack(
                children: [
                  ListView(
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
                                prefixIcon: const Icon(Icons.token)),
                            const SizedBox(height: 10.0),
                            BuildTextForm(
                                controller: name,
                                label: "Name",
                                readOnly: true,
                                prefixIcon: const Icon(Icons.person)),
                            const SizedBox(height: 10.0),
                            BuildTextForm(
                                controller: courseCode,
                                label: "Course Code",
                                readOnly: false,
                                errorText: bookingState.courseCodeError,
                                prefixIcon: const Icon(Icons.subject)),
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
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                            const SizedBox(height: 10.0),
                            // Show hint when editing and date changed
                            if (bookingState.isEditing &&
                                bookingState.originalBooking != null &&
                                details.date.isNotEmpty &&
                                details.date != bookingState.originalBooking!.date)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.amber.shade300),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.info_outline, color: Colors.amber.shade700, size: 18),
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
                                details.date != bookingState.originalBooking!.date)
                              const SizedBox(height: 10.0),
                            BuildSlots(
                              timeSlots: bookingState.timeSlots,
                              onSlotsSelected: (slot) => ref.read(bookingProvider.notifier).toggleSlot(slot),
                              onSlotLongPress: (slot) => _showSlotBookerDialog(context, details.date, slot),
                              selectedSlots: details.slots,
                              currentlyBookedSlots: () {
                                if (!bookingState.isEditing) return <String>[];
                                // Only show amber on the SAME date as original booking
                                final isSameDate = details.date == bookingState.originalBooking?.date;
                                if (!isSameDate) return <String>[];
                                if (bookingState.editingSlot != null) return [bookingState.editingSlot!];
                                return bookingState.originalBooking?.slots ?? <String>[];
                              }(),
                            ),
                            const SizedBox(height: 20.0),
                            BuildElevatedButton(
                              actionOnButton: () {
                                ref.read(bookingProvider.notifier).verifyAndSubmit();
                              },
                              buttonText: bookingState.isEditing ? "UPDATE BOOKING" : "PROCEED TO BOOK",
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (bookingState.isSubmitting)
                   Container(
                     color: Colors.black54,
                     child: const Center(child: CircularProgressIndicator()),
                   )
                ],
             ),
      ),
    );
  }
}
