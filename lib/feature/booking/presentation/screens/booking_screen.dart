import "package:flutter/material.dart";
import 'package:smart_reserve/feature/about/presentation/screens/about_screen.dart';
import 'package:smart_reserve/feature/auth/presentation/screens/verify_screen.dart';
import 'package:smart_reserve/core/presentation/widgets/background_shapes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_reserve/feature/booking/presentation/providers/booking_provider.dart';

import 'package:smart_reserve/core/presentation/widgets/custom_app_bar.dart';
import 'package:smart_reserve/core/presentation/widgets/custom_button.dart';
import 'package:smart_reserve/feature/booking/presentation/widgets/slots_widget.dart';
import 'package:smart_reserve/core/presentation/widgets/custom_text_field.dart';

import 'package:smart_reserve/feature/booking/domain/models/booking_model.dart'; // Add import

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
