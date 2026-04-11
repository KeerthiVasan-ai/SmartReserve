import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "dart:developer" as dev;
import 'package:smart_reserve/core/presentation/widgets/custom_app_bar.dart';
import 'package:smart_reserve/core/presentation/widgets/custom_list_builder.dart';
import 'package:smart_reserve/core/presentation/widgets/background_shapes.dart';
import 'package:smart_reserve/core/theme/app_fonts.dart';

import 'package:smart_reserve/feature/booking/data/datasources/fetch_user_booking.dart';

class OlderBookingScreen extends StatefulWidget {
  const OlderBookingScreen({super.key});

  @override
  State<OlderBookingScreen> createState() => _OlderBookingScreenState();
}

class _OlderBookingScreenState extends State<OlderBookingScreen> {
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  String _selectedFilter = 'All';

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Filter by Hall",
                style: AppFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF124076),
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: ['All', '2216-Hall', 'CompScE', 'Pheonix'].map((
                  filter,
                ) {
                  final isSelected = _selectedFilter == filter;
                  return ChoiceChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                        Navigator.pop(context);
                      }
                    },
                    selectedColor: const Color(0xFF124076).withOpacity(0.2),
                    backgroundColor: Colors.grey.shade100,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? const Color(0xFF124076)
                          : Colors.black87,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected
                            ? const Color(0xFF124076)
                            : Colors.grey.shade300,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundShapes(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          title: "Previous Bookings",
          actions: [
            IconButton(
              onPressed: _showFilterSheet,
              icon: Icon(
                _selectedFilter == 'All'
                    ? Icons.filter_alt_outlined
                    : Icons.filter_alt,
                color: _selectedFilter == 'All'
                    ? Colors.black
                    : const Color(0xFF124076),
              ),
              tooltip: "Filter Bookings",
            ),
          ],
        ),
        body: SafeArea(
          child: StreamBuilder(
            stream: FetchUserBooking.fetchBookingDetails(uid),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              var sortedDocs = snapshot.data!.docs.toList()
                ..sort((a, b) {
                  var aDate = DateFormat(
                    "dd-MM-yyyy",
                  ).parse((a.data() as Map<String, dynamic>)['date']);
                  var bDate = DateFormat(
                    "dd-MM-yyyy",
                  ).parse((b.data() as Map<String, dynamic>)['date']);
                  return aDate.compareTo(bDate);
                });

              List<DocumentSnapshot> previousBooking = [];
              DateTime today = DateTime.now();
              dev.log(today.toString());

              for (var doc in sortedDocs) {
                final data = doc.data() as Map<String, dynamic>;
                DateTime bookingDate = DateFormat(
                  "dd-MM-yyyy",
                ).parse(data['date']);

                // Filter Logic
                final hall = data['hall'] is String
                    ? data['hall']
                    : '2216-Hall';
                if (_selectedFilter != 'All' && hall != _selectedFilter) {
                  continue;
                }

                if (!(bookingDate.year == today.year &&
                        bookingDate.month == today.month &&
                        bookingDate.day == today.day) &&
                    !bookingDate.isAfter(today)) {
                  previousBooking.add(doc);
                }
              }
              dev.log(previousBooking.length.toString());

              if (previousBooking.isEmpty) {
                if (_selectedFilter != 'All') {
                  return Center(
                    child: Text('No $_selectedFilter bookings available.'),
                  );
                }
                return const Center(child: Text('No Booking available.'));
              }

              return BuildListBuilder(
                bookings: previousBooking,
                isDelete: false,
                uid: uid,
              );
            },
          ),
        ),
      ),
    );
  }
}
