import "package:flutter/material.dart";
import 'package:smart_reserve/feature/auth/presentation/screens/verify_screen.dart';
import 'package:smart_reserve/core/presentation/widgets/background_shapes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_reserve/feature/booking/presentation/providers/booking_provider.dart';

import 'package:smart_reserve/core/presentation/widgets/custom_app_bar.dart';
import 'package:smart_reserve/core/presentation/widgets/custom_button.dart';
import 'package:smart_reserve/feature/booking/presentation/widgets/slots_widget.dart';
import 'package:smart_reserve/core/presentation/widgets/custom_text_field.dart';

class BookingScreen extends ConsumerStatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController tokenNumber;
  late TextEditingController name;
  late TextEditingController courseCode;
  late TextEditingController date;
  
  @override
  void initState() {
    super.initState();
    tokenNumber = TextEditingController();
    name = TextEditingController();
    courseCode = TextEditingController();
    date = TextEditingController();
    
    // Initialize provider data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bookingProvider.notifier).initialize();
    });
    
    courseCode.addListener(() {
        ref.read(bookingProvider.notifier).updateCourseCode(courseCode.text);
    });
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
                return VerifyScreen(bookingDetails: next.bookingDetails);
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
    
    return BackgroundShapes(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: buildAppBar("Book your Slot"),
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
                            BuildSlots(
                              timeSlots: bookingState.timeSlots,
                              onSlotsSelected: (slot) => ref.read(bookingProvider.notifier).toggleSlot(slot),
                              selectedSlots: details.slots,
                            ),
                            const SizedBox(height: 20.0),
                            BuildElevatedButton(
                              actionOnButton: () {
                                ref.read(bookingProvider.notifier).verifyAndSubmit();
                              },
                              buttonText: "PROCEED TO BOOK",
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
