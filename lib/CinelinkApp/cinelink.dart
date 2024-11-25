import 'package:cinema/CinemaHall/CinemaHall.dart';
import 'package:cinema/ProfilePage/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CineLinkApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineLink',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: HomePage(),
    );
  }
}

// Movie model
class Movie {
  final String title;
  final String releaseDate;
  final double rating;
  final String posterUrl;

  Movie({
    required this.title,
    required this.releaseDate,
    required this.rating,
    required this.posterUrl,
  });
}

class HomePage extends StatelessWidget {
  final List<Movie> movies = [
    Movie(
      title: "Interstellar",
      releaseDate: "2024-10-21",
      rating: 4.5,
      posterUrl:
          "https://image.tmdb.org/t/p/original/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg",
    ),
    Movie(
      title: "Stree",
      releaseDate: "2023-07-21",
      rating: 5.0,
      posterUrl:
          "https://resize.indiatvnews.com/en/resize/newbucket/1200_-/2024/07/stree-2-posters-1-1721218037.jpg",
    ),
    Movie(
      title: "Pushpa: The Rule",
      releaseDate: "2024-12-15",
      rating: 4.7,
      posterUrl:
          "https://assetscdn1.paytm.com/images/cinema/pushpa-2-(1)-(1)-ff7e1f10-fbfc-11ee-bfde-1dbbef51e33c.jpg",
    ),
    Movie(
      title: "Avatar: The Way of Water",
      releaseDate: "2024-01-01",
      rating: 3.7,
      posterUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ4c47SiZXvMiCX44BTOUWcO1-TtbEuDbh98A&s",
    ),
    Movie(
      title: "Baahubali 2: The Conclusion",
      releaseDate: "2017-04-28",
      rating: 3.9,
      posterUrl:
          "https://upload.wikimedia.org/wikipedia/en/9/93/Baahubali_2_The_Conclusion_poster.jpg",
    ),
    Movie(
      title: "Annabelle",
      releaseDate: "2021-12-17",
      rating: 4.3,
      posterUrl:
          "https://image.tmdb.org/t/p/original/jNFqmsulwUrhYQW3MvqzfMc7SdS.jpg",
    ),
    Movie(
      title: "Guardians of the Galaxy Vol. 3",
      releaseDate: "2023-05-05",
      rating: 3.1,
      posterUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQOhHWyZ7Bo-m1sJp5plCwqMUKxoX2T6CvLw&s",
    ),
    Movie(
      title: "Mission: Impossible - Dead Reckoning Part One",
      releaseDate: "2023-07-12",
      rating: 4.9,
      posterUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQyoEL4jdJJgjaG7H3kZsnNXtKNnPl5BWqbUQ&s",
    ),
    Movie(
      title: "John Wick: Chapter 4",
      releaseDate: "2023-03-24",
      rating: 4.1,
      posterUrl:
          "https://media.themoviedb.org/t/p/w220_and_h330_face/uzHPb0rITwa44KkhX5Z27cXwmL1.jpg",
    ),
    Movie(
      title: "Fast X",
      releaseDate: "2023-05-19",
      rating: 3.3,
      posterUrl:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRBKonA2yeCVOivXtEK1qLl7tHoA5Ef-kZNXQ&s",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    movies.sort((a, b) => b.rating.compareTo(a.rating));

    return Scaffold(
      appBar: AppBar(
        title: Text('CineLink'),
        backgroundColor: Colors.redAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.person), // Profile icon
            onPressed: () {
              // Navigate to ProfilePage when icon is clicked
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.yellow[100],
        child: ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return MovieCard(movie: movies[index]);
          },
        ),
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to Cinema Hall (dummy page)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              body: Cinemahall(
                  Platinum: 40,
                  Gold: 20,
                  Silver: 20,
                  PlatinumPrize: 500,
                  GoldPrize: 250,
                  SilverPrize: 125),
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                height: 150,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(8)),
                  child: Image.network(
                    movie.posterUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Release Date: ${movie.releaseDate}",
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          "Rating: ${movie.rating}",
                          style: const TextStyle(
                              fontSize: 16, color: Colors.green),
                        ),
                        const SizedBox(width: 5),
                        const Icon(Icons.star, color: Colors.orange),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
