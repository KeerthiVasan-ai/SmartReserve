import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:smart_reserve/screens/verify_screen.dart";
import "package:smart_reserve/services/fetch_user_booking.dart";
import "package:smart_reserve/services/update_time_slots.dart";
import "package:smart_reserve/view_models/generate_token.dart";
import "package:smart_reserve/view_models/generate_week.dart";
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
  String ticketId = "";
  // late TextEditingController ticketId;
  late Map<String, bool> timeSlots = <String, bool>{};
  TextEditingController date = TextEditingController();
  List<String> selectedSlots = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // ticketId = TextEditingController();
    tokenNumber = TextEditingController();
    name = TextEditingController();
    courseCode = TextEditingController();
    ticketId = generateToken();
    dev.log(ticketId,name:"Ticket");
    // setState(() {
    // });
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
        if(filteredSnapshots.isEmpty){
          performSubmission();
        } else if (filteredSnapshots.length == 1) {
          int slotsLength = filteredSnapshots[0]['slots'].length;

          if (slotsLength == 1) {
            if (selectedSlots.length == 2) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text("Already Booked 1 slot for this Week")));
            } else {
              dev.log("SUBMITTING");
              performSubmission();
            }
          } else if (slotsLength == 2) {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Limit Reached For this Week")));
          }
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Limit Reached For this Week")));
        }
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(
          const SnackBar(content: Text("Select the Time Slots")));
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
          slots: selectedSlots);

      final String uid = FirebaseAuth.instance.currentUser!.uid;
      Map<String, dynamic> bookingData = bookingDetails.getBookingDetails();

      InsertBookingDetails.addIndividualBookingDetails(uid: uid, bookingData: bookingData, ticketId: ticketId);
      InsertBookingDetails.addBookingDetails(date:date.text,ticketId: ticketId, bookingData: bookingData);
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
    // }
  }

  Future<void> fetchTimeSlots(String date) async {
    setState(() {
      timeSlots = {};
    });
    timeSlots = await FetchTimeSlots.fetchTimeSlots(date);
    setState(() {});
  }

  Future<void> updateTimeSlots(String date, List<String> selectedSlots) async {
    await UpdateTimeSlots.insertSlots(date, selectedSlots,false);
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
        lastDate: DateTime.now().add(const Duration(days: 13)));

    if (picker != null) {
      setState(() {
        date.text = DateFormat('dd-MM-yyyy').format(picker).toString();
        selectedSlots.clear();
      });
      dev.log(getWeekNumber(date.text),name: "Dateeeeeee");
      await fetchTimeSlots(picker.toString().split(" ")[0]);
    }
  }

  Future<void> _displayDetails() async {
    String? userName = await FetchName.fetchName();
    String? token  = await FetchToken.fetchToken();
    if (userName != null && token != null) {
      setState(() {
        name.text = userName;
        tokenNumber.text = token;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar("Book your Slot"),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background/check2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
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
                                color: Colors.blueGrey),
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
                    const SizedBox(height: 20.0),
                    BuildElevatedButton(
                      actionOnButton: () => _verifyDetails(),
                      buttonText: "Verify",
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
