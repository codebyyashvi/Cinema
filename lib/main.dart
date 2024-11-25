import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cinema/CinemaHall/CinemaHall.dart';
import 'package:cinema/ProfilePage/profile_page.dart';
import 'package:cinema/LoginPage/widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cinema/LoginPage/Auth.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(CineLinkApp());
}

class CineLinkApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineLink',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage(),
    );
  }
}

// Movie model
class Movie {
  final String title;
  final String year;
  final double score;
  final String posterUrl;

  Movie({
    required this.title,
    required this.year,
    required this.score,
    required this.posterUrl,
  });
}

// Service class to handle API requests
class MovieService {
  final String traktBaseUrl = 'https://api.trakt.tv';
  final String fanartBaseUrl = 'https://webservice.fanart.tv/v3/movies';
  final String traktApiKey =
      '5f49d6f4a4fe874f7c43bca412a6956f7e9497ecbf18c18cc9700bea6f0a20c8'; // Replace with your Trakt API key
  final String fanartApiKey = '2004d4c42bb45cdb35f593993a248beb'; // Replace with your Fanart API key

  Future<List<Movie>> fetchMovies() async {
    final response = await http.get(
      Uri.parse('$traktBaseUrl/movies/trending'),
      headers: {
        'Content-Type': 'application/json',
        'trakt-api-key': traktApiKey,
        'trakt-api-version': '2',
      },
    );

    if (response.statusCode == 200) {
      print("Raw API Response: ${response.body}");
      List moviesData = json.decode(response.body);
      return await Future.wait(
          moviesData.map((movieData) => _createMovie(movieData)).toList());
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<Movie> _createMovie(Map<String, dynamic> movieData) async {
    final String? title = movieData['movie']?['title'];
    final String? year = movieData['movie']?['year']?.toString();
    final double score = movieData.containsKey('watchers')
        ? (movieData['watchers'] as num).toDouble()
        : 0.0; // Default to 0.0 if score is missing

    if (title == null || year == null) {
      throw Exception("Movie data contains null values");
    }

    // Poster fetching
    String posterUrl = 'assets/placeholder.png';
    final fanartResponse = await http.get(
      Uri.parse('$fanartBaseUrl/${movieData['movie']['ids']['tmdb']}?api_key=$fanartApiKey'),
    );
    if (fanartResponse.statusCode == 200) {
      final fanartData = json.decode(fanartResponse.body);
      posterUrl = (fanartData['movieposter'] != null && fanartData['movieposter'].isNotEmpty)
          ? fanartData['movieposter'][0]['url']
          : 'assets/placeholder.png';
    }

    return Movie(
      title: title,
      year: year,
      score: score,
      posterUrl: posterUrl,
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MovieService movieService = MovieService();
  List<Movie> movies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  Future<void> _fetchMovies({bool isReload = false}) async {
    if (!isReload) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      final fetchedMovies = await movieService.fetchMovies();
      setState(() {
        movies = fetchedMovies..sort((a, b) => b.score.compareTo(a.score));
      });
    } catch (e) {
      print('Error fetching movies: $e');
    } finally {
      if (!isReload) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> signOut() async {
    try {
      await Auth().signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => WidgetTree()), // Navigate to login page
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      print('Sign-out error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CineLink'),
        backgroundColor: Colors.redAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchMovies,
          ),
          IconButton(
            icon: Icon(Icons.logout), // Logout icon
            onPressed: () async {
              await signOut();
            },
          ),
          IconButton(
            icon: Icon(Icons.person), // Profile icon
            onPressed: () {
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
      body: RefreshIndicator(
        onRefresh: _fetchMovies,
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : movies.isEmpty
            ? Center(
          child: Text(
            'No trending movies available.',
            style: TextStyle(fontSize: 18),
          ),
        )
            : ListView.builder(
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Cinemahall(
              Platinum: 40,
              Gold: 20,
              Silver: 20,
              PlatinumPrize: 500,
              GoldPrize: 250,
              SilverPrize: 125,
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
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  child: Image.network(
                    movie.posterUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Image.asset('assets/placeholder.png'),
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
                      "Release Year: ${movie.year}",
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          "Rating: ${movie.score}",
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
