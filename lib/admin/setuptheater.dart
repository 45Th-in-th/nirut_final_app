import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SetupTheaterPage extends StatefulWidget {
  const SetupTheaterPage({super.key});

  @override
  State<SetupTheaterPage> createState() => _SetupTheaterPageState();
}

class _SetupTheaterPageState extends State<SetupTheaterPage> {
  final TextEditingController theidController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController seatsAController = TextEditingController();
  final TextEditingController seatsBController = TextEditingController();
  final TextEditingController seatsCController = TextEditingController();
  bool? status; // สถานะ (true = ใช้งาน, false = ปิดปรับปรุง)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ตั้งค่าข้อมูลโรงภาพยนตร์'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: theidController,
              decoration: const InputDecoration(labelText: 'รหัสโรงภาพยนตร์'),
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'ชื่อโรงภาพยนตร์'),
            ),
            TextField(
              controller: seatsAController,
              decoration:
                  const InputDecoration(labelText: 'จำนวนที่นั่ง ฮันนีมูน'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: seatsBController,
              decoration:
                  const InputDecoration(labelText: 'จำนวนที่นั่ง พิเศษ'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: seatsCController,
              decoration:
                  const InputDecoration(labelText: 'จำนวนที่นั่ง ธรรมดา'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Dropdown สำหรับเลือกสถานะ
            DropdownButton<bool>(
              isExpanded: true,
              value: status,
              hint: const Text('เลือกสถานะ'),
              items: const [
                DropdownMenuItem(
                  value: true,
                  child: Text('ใช้งาน'),
                ),
                DropdownMenuItem(
                  value: false,
                  child: Text('ปิดปรับปรุง'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  status = value; // อัปเดตสถานะ
                });
              },
            ),
            const SizedBox(height: 20),

            // ปุ่มบันทึก
            ElevatedButton(
              onPressed: () async {
                if (status == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('กรุณาเลือกสถานะ')),
                  );
                  return;
                }

                final theaterData = {
                  'theid': theidController.text,
                  'theaterName': nameController.text,
                  'totalSeatsA': int.parse(seatsAController.text),
                  'totalSeatsB': int.parse(seatsBController.text),
                  'totalSeatsC': int.parse(seatsCController.text),
                  'status': status, // true หรือ false
                };

                await FirebaseFirestore.instance
                    .collection('nirut_theater')
                    .add(theaterData);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('เพิ่มโรงภาพยนตร์เรียบร้อยแล้ว!')),
                );

                Navigator.pop(context);
              },
              child: const Text('บันทึก'),
            ),
          ],
        ),
      ),
    );
  }
}
