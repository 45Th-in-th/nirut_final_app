import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:ffi';
import 'package:nirut_final_app/component/movieprovider.dart';
import 'package:nirut_final_app/component/moviecard.dart';

class SetupShowtimePage extends StatefulWidget {
  const SetupShowtimePage({super.key});

  @override
  State<SetupShowtimePage> createState() => _SetupShowtimePageState();
}

class _SetupShowtimePageState extends State<SetupShowtimePage> {
  String? selectedMovieId;
  String? selectedTheaterId;
  String? selectedShowTime;
  List<String> availableTimes = [];
  List<Map<String, dynamic>> theaters = [];

  @override
  void initState() {
    super.initState();
    availableTimes = _generateAvailableTimes();
  }

  // สร้างเวลาฉายตั้งแต่ 10:00 ถึง 20:00 (รอบละ 2 ชั่วโมง)
  List<String> _generateAvailableTimes() {
    List<String> times = [];
    DateTime start = DateTime(2024, 1, 1, 10, 0);
    DateTime end = DateTime(2024, 1, 1, 20, 0);
    while (start.isBefore(end)) {
      times.add('${start.hour.toString().padLeft(2, '0')}:00');
      start = start.add(const Duration(hours: 2));
    }
    return times;
  }

  Future<List<Map<String, dynamic>>> _fetchMovies() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('nirut_movies')
        .where('onBook', isEqualTo: true)
        .get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<List<Map<String, dynamic>>> _fetchTheaters(String movieId) async {
    final snapshot =
        await FirebaseFirestore.instance.collection('nirut_theater').get();
    final allTheaters =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    // ดึงข้อมูลรอบฉายทั้งหมดสำหรับโรงภาพยนตร์
    final showtimeSnapshot = await FirebaseFirestore.instance
        .collection('nirut_showtimes')
        .where('movid', isNotEqualTo: movieId) // ไม่เอาหนังเรื่องที่กำลังเพิ่ม
        .get();
    final showtimes = showtimeSnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    // กรองโรงภาพยนตร์ที่ยังมีเวลาว่าง
    return allTheaters.where((theater) {
      final theaterId = theater['theid'];
      final theaterShowtimes =
          showtimes.where((st) => st['theid'] == theaterId).toList();

      for (final time in availableTimes) {
        // ถ้าช่วงเวลายังไม่มีการจอง ให้โรงนี้ยังมีเวลาว่าง
        final isOccupied = theaterShowtimes.any((st) => st['showTime'] == time);
        if (!isOccupied) return true;
      }
      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ตั้งค่ารอบฉาย'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown เลือกหนัง
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchMovies(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('ไม่พบภาพยนตร์ที่ยังฉายอยู่');
                }
                final movies = snapshot.data!;
                return DropdownButton<String>(
                  isExpanded: true,
                  value: selectedMovieId,
                  hint: const Text('เลือกภาพยนตร์'),
                  items: movies
                      .map<DropdownMenuItem<String>>(
                          (movie) => DropdownMenuItem<String>(
                                value: movie['movid']
                                    as String, // แปลงให้เป็น String
                                child: Text(movie['movieName']
                                    as String), // แปลงให้เป็น String
                              ))
                      .toList(),
                  onChanged: (value) async {
                    setState(() {
                      selectedMovieId = value;
                      selectedTheaterId = null;
                      selectedShowTime = null;
                    });
                    if (value != null) {
                      final fetchedTheaters = await _fetchTheaters(value);
                      setState(() {
                        theaters = fetchedTheaters;
                      });
                    }
                  },
                );
              },
            ),
            const SizedBox(height: 16),

            // Dropdown เลือกโรงภาพยนตร์
            if (selectedMovieId != null)
              theaters.isNotEmpty
                  ? DropdownButton<String>(
                      isExpanded: true,
                      value: selectedTheaterId,
                      hint: const Text('เลือกโรงภาพยนตร์'),
                      items: theaters
                          .map<DropdownMenuItem<String>>(
                              (theater) => DropdownMenuItem<String>(
                                    value: theater['theid']
                                        as String, // กำหนดให้เป็น String
                                    child: Text(
                                        theater['theaterName'] as String? ??
                                            'Unknown Theater'),
                                  ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedTheaterId = value;
                        });
                      },
                    )
                  : const Text('ไม่พบโรงภาพยนตร์ที่ว่างสำหรับรอบนี้'),

            // Dropdown เลือกเวลาฉาย
            if (selectedTheaterId != null)
              DropdownButton<String>(
                isExpanded: true,
                value: selectedShowTime,
                hint: const Text('เลือกเวลาฉาย'),
                items: availableTimes
                    .map((time) => DropdownMenuItem(
                          value: time,
                          child: Text(time),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedShowTime = value;
                  });
                },
              ),
            const SizedBox(height: 16),

            // ปุ่มบันทึก
            ElevatedButton(
              onPressed: selectedMovieId != null &&
                      selectedTheaterId != null &&
                      selectedShowTime != null
                  ? () async {
                      final showtimeData = {
                        'movieId': selectedMovieId,
                        'theaterId': selectedTheaterId,
                        'showTime': selectedShowTime,
                      };
                      await FirebaseFirestore.instance
                          .collection('nirut_showtimes')
                          .add(showtimeData);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('เพิ่มรอบฉายเรียบร้อยแล้ว!')),
                      );

                      Navigator.pop(context);
                    }
                  : null,
              child: const Text('บันทึก'),
            ),
          ],
        ),
      ),
    );
  }
}
