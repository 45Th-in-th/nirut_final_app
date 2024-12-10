import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SetupMoviePage extends StatefulWidget {
  const SetupMoviePage({super.key});

  @override
  State<SetupMoviePage> createState() => _SetupMoviePageState();
}

class _SetupMoviePageState extends State<SetupMoviePage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController movieIdController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController typeController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    final TextEditingController imageController = TextEditingController();
    // final TextEditingController TimeinController = TextEditingController();
    DateTime? selectedDateTime;
    String? imagePath;

    return Scaffold(
      appBar: AppBar(
        title: const Text('เพิ่มภาพยนตร์'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: movieIdController,
              decoration: const InputDecoration(labelText: 'รหัสภาพยนต์'),
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'ชื่อภาพยนตร์'),
            ),
            TextField(
              controller: typeController,
              decoration: const InputDecoration(labelText: 'ประเภท'),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'คำอธิบาย'),
            ),
            TextField(
              controller: imageController,
              decoration: const InputDecoration(labelText: 'รูปภาพ'),
            ),
            ElevatedButton(
              onPressed: () async {
                final movieData = {
                  'movid': movieIdController.text,
                  'movieName': nameController.text,
                  'movieType': typeController.text,
                  'movieDesc': descController.text,
                  'image': imagePath ?? imageController.text,
                  'movDatein': DateTime.now().toIso8601String(),
                };
                await FirebaseFirestore.instance
                    .collection('nirut_movies')
                    .add(movieData);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('เพิ่มภาพยนตร์เรียบร้อยแล้ว!')),
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
