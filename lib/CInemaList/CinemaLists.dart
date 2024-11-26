import 'package:flutter/material.dart';
import 'package:cinema/CinemaHall/CinemaHall.dart';

void main() => runApp(MovieTicketApp());

class MovieTicketApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Ticket Booking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CinemaListPage(), // Changed to CinemaListPage
    );
  }
}

// Cinema Class
class Cinema {
  final String name;
  final String posterUrl;
  final int likes;
  final int dislikes;
  final String distance;
  final double rating;

  Cinema({
    required this.name,
    required this.posterUrl,
    required this.likes,
    required this.dislikes,
    required this.distance,
    required this.rating,
  }); // Constructor
}

class CinemaListPage extends StatefulWidget {
  @override
  _CinemaListPageState createState() => _CinemaListPageState();
}

class _CinemaListPageState extends State<CinemaListPage> {
  List<Cinema> cinemaList = [
    Cinema(
      name: 'Cinema Hall 1',
      posterUrl: 'https://thumbs.dreamstime.com/b/cinema-hall-11557048.jpg',
      likes: 123,
      dislikes: 4,
      distance: '2 km',
      rating: 4.5,
    ),
    Cinema(
      name: 'Cinema Hall 2',
      posterUrl:
      'https://thumbs.dreamstime.com/b/modern-cinema-hall-big-42813975.jpg',
      likes: 98,
      dislikes: 10,
      distance: '5 km',
      rating: 4.0,
    ),
    Cinema(
      name: 'Cinema Hall 3',
      posterUrl:
      'https://i.pinimg.com/originals/d3/10/a7/d310a754ddcab75a00adf9e1aefa196c.jpg',
      likes: 90,
      dislikes: 50,
      distance: '8 km',
      rating: 3.8,
    ),
    Cinema(
      name: 'Cinema Hall 4',
      posterUrl: 'https://shopee.com.my/blog/wp-content/uploads/2022/09/48.jpg',
      likes: 70,
      dislikes: 5,
      distance: '10 km',
      rating: 4.5,
    ),
    Cinema(
      name: 'Cinema Hall 5',
      posterUrl:
      'https://i.pinimg.com/originals/d3/10/a7/d310a754ddcab75a00adf9e1aefa196c.jpg',
      likes: 90,
      dislikes: 50,
      distance: '8 km',
      rating: 3.8,
    ),
    Cinema(
      name: 'Cinema Hall 6',
      posterUrl: 'https://shopee.com.my/blog/wp-content/uploads/2022/09/48.jpg',
      likes: 70,
      dislikes: 5,
      distance: '10 km',
      rating: 4.5,
    )
  ];

  // Sort criteria state
  String _sortCriteria = 'rating';

  void _sortCinemaList() {
    setState(() {
      if (_sortCriteria == 'rating') {
        cinemaList.sort((a, b) => b.rating.compareTo(a.rating));
      } else if (_sortCriteria == 'distance') {
        cinemaList.sort((a, b) {
          double distanceA = double.parse(a.distance.split(' ')[0]);
          double distanceB = double.parse(b.distance.split(' ')[0]);
          return distanceA.compareTo(distanceB);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Cinema Halls'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _sortCriteria = value;
                _sortCinemaList();
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'distance',
                child: Text('Sort by Distance'),
              ),
              const PopupMenuItem<String>(
                value: 'rating',
                child: Text('Sort by Rating'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: double.infinity,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xfff073fb),
              boxShadow: [
                BoxShadow(
                  color: Colors.pinkAccent.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    'https://images.ottplay.com/images/big/stree-2-new-poster-1721216275.jpeg', // Updated poster link
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: const Color(0x8a93fc4c),
                    padding: const EdgeInsets.all(8),
                    child: const Text(
                      'Featured Movie Name',
                      style: TextStyle(
                        color: Color(0xff1e1f1d),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // List of cinema halls
          Expanded(
            child: ListView.builder(
              itemCount: cinemaList.length,
              itemBuilder: (context, index) {
                final cinema = cinemaList[index];
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
                    margin: const EdgeInsets.all(10),
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.09,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(cinema.posterUrl),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(8)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cinema.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.thumb_up,
                                          size: 16, color: Colors.green),
                                      const SizedBox(width: 4),
                                      Text('${cinema.likes}'),
                                      const SizedBox(width: 16),
                                      const Icon(Icons.thumb_down,
                                          size: 16, color: Colors.red),
                                      const SizedBox(width: 4),
                                      Text('${cinema.dislikes}'),
                                    ],
                                  ),
                                  // Rating with Distance
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Rating: ${cinema.rating}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on,
                                              size: 16, color: Colors.blue),
                                          const SizedBox(width: 4),
                                          Text(cinema.distance),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}