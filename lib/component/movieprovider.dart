import 'package:flutter/material.dart';
import 'package:nirut_final_app/component/moviecard.dart';
import 'package:nirut_final_app/pages/03_bookingpage.dart';

class MovieCard extends StatelessWidget {
  final MovieCardData movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
      child: ListTile(
        leading: Image.network(
          movie.image,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.broken_image);
          },
        ),
        title: Text(
          movie.movieName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'ประเภทหนัง: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: movie.movieType),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'เรื่องย่อ: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: movie.movieDesc),
                ],
              ),
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookingPage(movieId: movie.movid),
              ),
            );
          },
          child: const Text('จองตั๋วเรื่องนี้'),
        ),
      ),
    );
  }
}
