import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MovieCardData {
  final String movid;
  final String movieName;
  final String movieType;
  final String movieDesc;
  final String image; // เก็บ URL ของรูปภาพ
  final VoidCallback? onBook; // ใช้ในแอปพลิเคชัน ไม่บันทึกใน Firestore

  const MovieCardData({
    required this.movid,
    required this.movieName,
    required this.movieType,
    required this.movieDesc,
    required this.image,
    this.onBook,
  });

  // แปลงข้อมูลเป็น Map เพื่อบันทึกใน Firestore
  Map<String, dynamic> toMap() {
    return {
      'movid': movid,
      'movieName': movieName,
      'movieType': movieType,
      'movieDesc': movieDesc,
      'image': image,
    };
  }

  // สร้าง `MovieCardData` จาก Map ที่ดึงมาจาก Firestore
  factory MovieCardData.fromMap(Map<String, dynamic> data) {
    return MovieCardData(
      movid: data['movid'] ?? '',
      movieName: data['movieName'] ?? '',
      movieType: data['movieType'] ?? '',
      movieDesc: data['movieDesc'] ?? '',
      image: data['image'] ?? '',
    );
  }
}

class MovieCardProvider with ChangeNotifier {
  MovieCardData? _selectedMovieCard;
  List<MovieCardData> _moviecards = [];
  String? _errorMessage; // สำหรับเก็บข้อความผิดพลาด

  MovieCardData? get selectedMovieCard => _selectedMovieCard;
  List<MovieCardData> get moviecards => _moviecards;
  String? get errorMessage => _errorMessage;

  // เลือกภาพยนตร์
  Future<void> selectMovieCard(MovieCardData movieCard) async {
    _selectedMovieCard = movieCard;
    notifyListeners();
  }

  // อัปเดตข้อมูลภาพยนตร์ที่เลือก
  Future<void> updateMovieCard(MovieCardData updatedMovieCard) async {
    if (_selectedMovieCard?.movid == updatedMovieCard.movid) {
      _selectedMovieCard = updatedMovieCard;
      notifyListeners();
    }
  }

  // ดึงข้อมูลภาพยนตร์จาก Firestore
  Future<void> fetchMovieCards() async {
    final CollectionReference moviesCollection =
        FirebaseFirestore.instance.collection('nirut_movies');

    try {
      _errorMessage = null; // ล้างข้อความผิดพลาด
      QuerySnapshot snapshot = await moviesCollection.get();
      _moviecards = snapshot.docs.map((doc) {
        return MovieCardData.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      notifyListeners();
    } catch (error) {
      _errorMessage = 'Failed to fetch movies: $error';
      debugPrint(_errorMessage);
      notifyListeners(); // แจ้งให้ UI ทราบถึงข้อผิดพลาด
    }
  }
}
