import "dart:developer" as dev;

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_reserve/core/theme/app_fonts.dart';
import "package:intl/intl.dart";
import 'package:smart_reserve/core/services/gcp_logging_service.dart';
import 'package:smart_reserve/core/presentation/widgets/background_shapes.dart';
import 'package:smart_reserve/core/presentation/widgets/custom_list_builder.dart';
import 'package:smart_reserve/feature/about/presentation/screens/about_screen.dart';
import 'package:smart_reserve/feature/booking/data/datasources/fetch_user_booking.dart';
import 'package:smart_reserve/feature/booking/presentation/screens/booking_screen.dart';
import 'package:smart_reserve/feature/booking/presentation/screens/previous_booking_screen.dart';
import 'package:smart_reserve/feature/home/presentation/widgets/filter_bottom_sheet.dart';
import 'package:smart_reserve/feature/notification/presentation/providers/notification_provider.dart';
import 'package:smart_reserve/feature/notification/presentation/screens/notification_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  late String uid;
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    // Subscribe to FCM topic for this user
    _subscribeToFCMTopic();
  }

  void _subscribeToFCMTopic() async {
    dev.log('Subscribing to FCM topic: $uid', name: 'MainScreen');
    await FirebaseMessaging.instance.subscribeToTopic(uid);
    dev.log('Successfully subscribed to FCM topic: $uid', name: 'MainScreen');

    // Log the FCM token for debugging
    final token = await FirebaseMessaging.instance.getToken();
    dev.log('FCM Device Token: $token', name: 'MainScreen');
  }

  void _signOut() async {
    // Unsubscribe from FCM topic before signing out
    await FirebaseMessaging.instance.unsubscribeFromTopic(uid);
    GCPLog.info('User logged out: $uid');
    FirebaseAuth.instance.signOut();
  }

  void bookSlotRoute() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const BookingScreen();
        },
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // Transparent background for glass effect
      builder: (context) {
        return FilterBottomSheet(
          selectedFilter: _selectedFilter,
          onFilterSelected: (String filter) {
            setState(() {
              _selectedFilter = filter;
            });
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundShapes(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton(
          onPressed: bookSlotRoute,
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
            icon: const Icon(Icons.info_outline, color: Colors.black),
          ),
          title: Text(
            "Smart Reserve",
            style: AppFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          actions: [
            // Notification Bell with badge
            Consumer(
              builder: (context, ref, _) {
                final pendingCount = ref.watch(
                  pendingNotificationCountProvider,
                );
                return IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationScreen(),
                      ),
                    );
                  },
                  icon: Stack(
                    children: [
                      const Icon(
                        Icons.notifications_outlined,
                        color: Colors.black,
                      ),
                      pendingCount.when(
                        data: (count) => count > 0
                            ? Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 16,
                                  ),
                                  child: Text(
                                    '$count',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                    ],
                  ),
                  tooltip: "Notifications",
                );
              },
            ),
            // Filter Icon
            IconButton(
              onPressed: _showFilterSheet,
              icon: Icon(
                _selectedFilter == 'All'
                    ? Icons.filter_alt_outlined
                    : Icons.filter_alt, // Filled if active
                color: _selectedFilter == 'All'
                    ? Colors.black
                    : const Color(0xFF124076), // Colored if active
              ),
              tooltip: "Filter Bookings",
            ),
            // Popup Menu
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.black),
              onSelected: (value) {
                if (value == 'history') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OlderBookingScreen(),
                    ),
                  );
                } else if (value == 'logout') {
                  _signOut();
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'history',
                  child: Row(
                    children: [
                      Icon(Icons.history, color: Colors.black87, size: 20),
                      SizedBox(width: 12),
                      Text('Previous Bookings'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.black87, size: 20),
                      SizedBox(width: 12),
                      Text('Logout'),
                    ],
                  ),
                ),
              ],
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

              // if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
              //   return const Center(
              //     child: Text('No Booking available.'),
              //   );
              // }

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

              List<DocumentSnapshot> bookings = [];
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

                if ((bookingDate.year == today.year &&
                        bookingDate.month == today.month &&
                        bookingDate.day == today.day) ||
                    bookingDate.isAfter(today)) {
                  bookings.add(doc);
                }
              }
              dev.log(bookings.length.toString());

              if (bookings.isEmpty) {
                if (_selectedFilter != 'All') {
                  return Center(
                    child: Text('No $_selectedFilter bookings available.'),
                  );
                }
                return const Center(child: Text('No Booking available.'));
              }

              return BuildListBuilder(
                bookings: bookings,
                isDelete: true,
                uid: uid,
              );
            },
          ),
        ),
      ),
    );
  }
}
