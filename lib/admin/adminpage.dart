import 'package:flutter/material.dart';
import 'package:nirut_final_app/admin/bookingreport.dart';
import 'package:nirut_final_app/admin/setuptheater.dart';
import 'package:nirut_final_app/admin/setupshowtimes.dart';
import 'package:nirut_final_app/admin/bookingreport.dart';
import 'package:nirut_final_app/admin/setupmovie.dart';

class AdminMenuPage extends StatelessWidget {
  const AdminMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Menu'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('เพิ่มภาพยนตร์'),
            trailing: const Icon(Icons.movie),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SetupMoviePage()),
              );
            },
          ),
          ListTile(
            title: const Text('ตั้งค่าข้อมูลโรงภาพยนตร์'),
            trailing: const Icon(Icons.theater_comedy),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SetupTheaterPage()),
              );
            },
          ),
          ListTile(
            title: const Text('ตั้งค่ารอบฉาย'),
            trailing: const Icon(Icons.schedule),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SetupShowtimePage()),
              );
            },
          ),
          ListTile(
            title: const Text('รายงานการจอง'),
            trailing: const Icon(Icons.report),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const BookingReportPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
