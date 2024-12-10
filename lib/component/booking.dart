import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SeatBookingScreen extends StatefulWidget {
  final String roundId; // ID ของรอบฉายที่เลือก
  const SeatBookingScreen({required this.roundId});

  @override
  _SeatBookingScreenState createState() => _SeatBookingScreenState();
}

class _SeatBookingScreenState extends State<SeatBookingScreen> {
  List<String> selectedSeats = []; // เก็บที่นั่งที่ผู้ใช้เลือก

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Your Seats'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('nirut_round') // คอลเลกชันที่เก็บข้อมูลรอบฉาย
            .doc(widget.roundId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var roundData = snapshot.data!;
          var seats =
              roundData['seats'] as Map<String, dynamic>; // ที่นั่งทั้งหมด

          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(20),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8, // จำนวนที่นั่งในแต่ละแถว
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: seats.length,
                  itemBuilder: (context, index) {
                    String seatKey = seats.keys.elementAt(index);
                    String seatStatus = seats[seatKey];

                    return GestureDetector(
                      onTap: seatStatus == 'available'
                          ? () {
                              setState(() {
                                if (selectedSeats.contains(seatKey)) {
                                  selectedSeats.remove(seatKey);
                                } else {
                                  selectedSeats.add(seatKey);
                                }
                              });
                            }
                          : null,
                      child: Container(
                        decoration: BoxDecoration(
                          color: selectedSeats.contains(seatKey)
                              ? Colors.blue
                              : seatStatus == 'booked'
                                  ? Colors.red
                                  : Colors.green,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            seatKey,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: selectedSeats.isNotEmpty
                      ? () async {
                          // อัปเดตสถานะที่นั่งใน Firebase
                          for (var seat in selectedSeats) {
                            await FirebaseFirestore.instance
                                .collection('nirut_round')
                                .doc(widget.roundId)
                                .update({
                              'seats.$seat':
                                  'booked', // เปลี่ยนสถานะเป็น "booked"
                            });
                          }

                          // บันทึกการจองใน 'nirut_booking'
                          await FirebaseFirestore.instance
                              .collection('nirut_booking')
                              .add({
                            'roundid': widget.roundId,
                            'seats': selectedSeats,
                            'bookdate': FieldValue.serverTimestamp(),
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Booking Successful!')),
                          );

                          setState(() {
                            selectedSeats.clear();
                          });
                        }
                      : null,
                  child: Text('Book Tickets'),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
