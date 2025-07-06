import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:smart_reserve/screens/verify_screen.dart";
import "package:smart_reserve/services/fetch_alloted_slots.dart";
import "package:smart_reserve/services/fetch_user_booking.dart";
import "package:smart_reserve/services/update_time_slots.dart";
import "package:smart_reserve/view_models/generate_time_key.dart";
import "package:smart_reserve/view_models/generate_token.dart";
import "package:smart_reserve/view_models/generate_week.dart";
import "package:smart_reserve/widgets/ui/background_shapes.dart";
import "dart:developer" as dev;

import "../models/booking_model.dart";
import "../services/fetch_time_slots.dart";
import "../services/fetch_user_name.dart";
import "../services/fetch_user_token.dart";
import "../services/insert_booking_details.dart";
import "../widgets/build_app_bar.dart";
import "../widgets/build_elevated_button.dart";
import "../widgets/build_slots.dart";
import "../widgets/build_text_field.dart";

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  late TextEditingController tokenNumber;
  late TextEditingController name;
  late TextEditingController courseCode;
  late int slotCount;
  String ticketId = "";
  late Map<String, bool> timeSlots = <String, bool>{};
  TextEditingController date = TextEditingController();
  List<String> selectedSlots = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    slotCount = 0;
    tokenNumber = TextEditingController();
    name = TextEditingController();
    courseCode = TextEditingController();
    ticketId = generateToken();
    dev.log(ticketId, name: "Ticket");

    // ESSENTIALS
    _getSlots(uid).then((value) => slotCount = value);
    _displayDetails();
  }

  void _verifyDetails() {
    dev.log(tokenNumber.text, name: "Token Number");
    dev.log(name.text, name: "Name");
    dev.log(courseCode.text, name: "Course Code");
    dev.log(selectedSlots.toString(), name: "Slots");
    dev.log(date.text, name: "Date");

    FetchUserBooking.fetchBookingDetails(uid).listen((snapshot) {
      checkConditions(snapshot);
    });
  }

  void checkConditions(QuerySnapshot snapshot) {
    if (_formKey.currentState!.validate() && selectedSlots.isNotEmpty) {
      if (snapshot.docs.isEmpty) {
        dev.log("SUBMITTING");
        performSubmission();
      } else {
        String currentWeek = getWeekNumber(date.text);
        List<QueryDocumentSnapshot> filteredSnapshots =
            snapshot.docs.where((doc) => doc['week'] == currentWeek).toList();

        dev.log(slotCount.toString(), name: "Slots");

        if (filteredSnapshots.isEmpty) {
          performSubmission();
        } else if (filteredSnapshots.length == slotCount) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Limit Reached For this Week")));
        } else {
          int bookedSlots = filteredSnapshots.length;
          int slotCounter = 0;
          for (int i = 0; i < bookedSlots; i++) {
            int slotsLength = filteredSnapshots[i]['slots'].length;
            slotCounter += slotsLength;
          }
          dev.log(slotCounter.toString(), name: "From Counter");
          if (slotCounter <= slotCount) {
            dev.log(selectedSlots.length.toString(),
                name: "SLOT LENGTH FROM FINAL");
            if (((slotCount - slotCounter) >= selectedSlots.length)) {
              performSubmission();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      "Remaining Slots available for this week is ${slotCount - slotCounter}")));
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Limit Reached For this Week")));
          }
        }
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Select the Time Slots")));
    }
  }

  void performSubmission() {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    BookingDetails bookingDetails = BookingDetails(
      ticketId: ticketId,
      tokenNumber: tokenNumber.text,
      name: name.text,
      week: getWeekNumber(date.text),
      courseCode: courseCode.text,
      date: date.text,
      slots: selectedSlots,
      slotKey: TimeKey.returnTimeKey(selectedSlots[0])!,
    );

    final String uid = FirebaseAuth.instance.currentUser!.uid;
    Map<String, dynamic> bookingData = bookingDetails.getBookingDetails();

    InsertBookingDetails.addIndividualBookingDetails(
        uid: uid, bookingData: bookingData, ticketId: ticketId);
    InsertBookingDetails.addBookingDetails(
        date: date.text, ticketId: ticketId, bookingData: bookingData);

    DateTime myDate = DateFormat("dd-MM-yyyy").parse(date.text);
    updateTimeSlots(DateFormat('yyyy-MM-dd').format(myDate), selectedSlots);

    Navigator.pop(context);

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Booked Successfully")));

    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (context) {
        return VerifyScreen(bookingDetails: bookingDetails);
      },
    ), (route) => false);
  }

  Future<void> fetchTimeSlots(String date) async {
    setState(() {
      timeSlots = {};
    });
    timeSlots = await FetchTimeSlots.fetchTimeSlots(date);
    setState(() {});
  }

  Future<void> updateTimeSlots(String date, List<String> selectedSlots) async {
    await UpdateTimeSlots.insertSlots(date, selectedSlots, false);
  }

  void _selectSlots(String slot) {
    setState(() {
      if (selectedSlots.contains(slot)) {
        selectedSlots.remove(slot);
      } else if (selectedSlots.length < 2) {
        selectedSlots.add(slot);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Only 2 Slot Allowed")));
      }
    });
  }

  Future<void> _selectDate() async {
    DateTime? picker = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 20)));

    if (picker != null) {
      setState(() {
        date.text = DateFormat('dd-MM-yyyy').format(picker).toString();
        selectedSlots.clear();
      });
      dev.log(getWeekNumber(date.text), name: "Date");
      await fetchTimeSlots(picker.toString().split(" ")[0]);
    }
  }

  Future<void> _displayDetails() async {
    String? userName = await FetchName.fetchName();
    String? token = await FetchToken.fetchToken();
    if (userName != null && token != null) {
      setState(() {
        name.text = userName;
        tokenNumber.text = token;
      });
    }
  }

  Future<int> _getSlots(String uid) async {
    int slots = await FetchAllottedSlots.getAllottedSlots(uid);
    return slots;
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundShapes(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: buildAppBar("Book your Slot"),
        body: ListView(
          children: [
            Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    BuildTextForm(
                        controller: tokenNumber,
                        label: "Token Number",
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
                        prefixIcon: const Icon(Icons.subject)),
                    const SizedBox(height: 10.0),
                    BuildTextForm(
                      controller: date,
                      label: "Date",
                      readOnly: true,
                      prefixIcon: const Icon(Icons.date_range),
                      onTap: _selectDate,
                    ),
                    const SizedBox(height: 10.0),

                    /// Only render the slots if the date is selected.

                    ...(date.text.isNotEmpty
                        ? [
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
                              timeSlots: timeSlots,
                              onSlotsSelected: _selectSlots,
                              selectedSlots: selectedSlots,
                            ),
                          ]
                        : [
                            const SizedBox(height: 20.0),
                            Text(
                              "Slots will be available once date is selected.",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF124076),
                              ),
                            ),
                          ]),
                    const SizedBox(height: 20.0),
                    BuildElevatedButton(
                      actionOnButton: () => _verifyDetails(),
                      buttonText: "PROCEED TO BOOK",
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
