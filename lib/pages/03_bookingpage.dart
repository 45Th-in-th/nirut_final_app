import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookingPage extends StatefulWidget {
  final String movieId; // รับ movieId จากหน้า Homepage

  const BookingPage({super.key, required this.movieId});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String? selectedShowTime; // เก็บรอบฉายที่เลือก
  String? selectedSeat; // เก็บที่นั่งที่เลือก

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Page'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('nirut_movies') // คอลเล็กชันที่เก็บข้อมูลภาพยนตร์
            .doc(widget.movieId) // ดึงเอกสารตาม movieId
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('ไม่สามารถแสดงข้อมูลได้: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('ไม่พบข้อมูลภาพยนตร์'));
          }

          final movieData = snapshot.data!.data() as Map<String, dynamic>;
          final showTimes = movieData['showTimes'] as List<dynamic>? ?? [];
          final availableSeats =
              movieData['availableSeats'] as List<dynamic>? ?? [];

          return ListView(
            padding: const EdgeInsets.all(8.0),
            children: [
              Text(
                movieData['movieName'] ?? 'No Title',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // เลือกรอบฉาย
              const Text(
                'รอบฉาย:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ...showTimes.map((time) => ListTile(
                    title: Text(time),
                    trailing: selectedShowTime == time
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      setState(() {
                        selectedShowTime = time; // กำหนดรอบฉายที่เลือก
                      });
                    },
                  )),
              const SizedBox(height: 16),

              // เลือกที่นั่งว่าง
              const Text(
                'ที่นั่งว่าง:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ...availableSeats.map((seat) => ListTile(
                    title: Text('ที่นั่ง: $seat'),
                    trailing: selectedSeat == seat
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      setState(() {
                        selectedSeat = seat; // กำหนดที่นั่งที่เลือก
                      });
                    },
                  )),

              const SizedBox(height: 16),

              // ปุ่มยืนยันการจอง
              ElevatedButton(
                onPressed: selectedShowTime != null && selectedSeat != null
                    ? () async {
                        // บันทึกข้อมูลการจองกลับไปที่ Firestore
                        final bookingData = {
                          'movieId': widget.movieId,
                          'showTime': selectedShowTime,
                          'seat': selectedSeat,
                          'bookedAt': Timestamp.now(),
                        };
                        await FirebaseFirestore.instance
                            .collection(
                                'bookings') // เก็บข้อมูลการจองในคอลเล็กชัน 'bookings'
                            .add(bookingData);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('การจองสำเร็จ!')),
                        );

                        Navigator.pop(context); // กลับไปหน้าก่อนหน้า
                      }
                    : null, // ปุ่มจะทำงานเมื่อเลือกรอบฉายและที่นั่งครบแล้ว
                child: const Text('ยืนยันการจอง'),
              ),
            ],
          );
        },
      ),
    );
  }
}
