import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nirut_final_app/component/bottombar.dart';
import 'package:nirut_final_app/component/moviecard.dart';
import 'package:nirut_final_app/component/movieprovider.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.message),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.forward),
            onPressed: () {
              Navigator.pushNamed(context, '/second');
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        // ดึงข้อมูลแบบเรียลไทม์จาก Firestore
        stream:
            FirebaseFirestore.instance.collection('nirut_movies').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No movies found'));
          }

          // แปลงข้อมูล Firestore เป็น ListView
          final movies = snapshot.data!.docs.map((doc) {
            return MovieCardData.fromMap(doc.data() as Map<String, dynamic>);
          }).toList();

          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return MovieCard(movie: movie);
            },
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
