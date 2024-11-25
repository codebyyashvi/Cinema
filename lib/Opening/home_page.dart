import 'package:flutter/material.dart';

void main() {
  runApp(CineLinkApp());
}

class CineLinkApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineLink',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final List<String> currentMovies = [
    'Movie 1',
    'Movie 2',
    'Movie 3',
    'Movie 4',
    'Movie 5',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CineLink - Current Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select a Movie:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: currentMovies.length,
                itemBuilder: (context, index) {
                  return MovieCard(movieTitle: currentMovies[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final String movieTitle;

  MovieCard({required this.movieTitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Container(
            width: 150,
            height: 200,
            color: Color(0xffa13131),
            child: Center(
              child: Text(
                'Image Here',
                style: TextStyle(color: Color(0x8ad43a3a)),
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            movieTitle,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
