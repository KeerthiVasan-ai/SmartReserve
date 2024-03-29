import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BuildListBuilder extends StatelessWidget {
  final List<DocumentSnapshot> bookings;

  const BuildListBuilder({required this.bookings, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        var data = bookings[index].data() as Map<String, dynamic>;

        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.bookmark),
                  const SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${data['tokenNumber']}"),
                      Text("${data['courseCode']}"),
                      Text("${data['date']}"),
                      Text("Slots: ${data['slots'].join(', ')}"),
                    ],
                  ),
                  // const Spacer(),
                  // IconButton(
                  //   icon: const Icon(Icons.delete),
                  //   onPressed: () {
                  //     deleteBooking(uid,data['ticketId'],data['date'],data['slots']);
                  //   },
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
    ;
  }
}
