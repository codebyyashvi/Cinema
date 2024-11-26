import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cinema/main.dart';
import 'package:cinema/CinemaHall/CinemaHall.dart';

class Cinema {
  final String name;
  final double latitude;
  final double longitude;

  Cinema({
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  // Factory method to create a Cinema object from a JSON element
  factory Cinema.fromJson(Map<String, dynamic> json) {
    return Cinema(
      name: json['tags']?['name'] ?? 'Unnamed Cinema',
      latitude: json['lat'],
      longitude: json['lon'],
    );
  }
}

class CinemaListPage extends StatefulWidget {
  final Movie? movie; // Make the movie parameter optional.

  CinemaListPage({this.movie}); // Constructor

  @override
  _CinemaListPageState createState() => _CinemaListPageState();
}

class _CinemaListPageState extends State<CinemaListPage> {
  List<Cinema> cinemaList = [];
  TextEditingController locationController = TextEditingController();
  bool isLoading = false;

  Future<void> fetchCoordinatesAndCinemas(String location) async {
    setState(() {
      isLoading = true;
    });

    try {
      final geocodingUrl =
          'https://nominatim.openstreetmap.org/search?q=$location&format=json&limit=1';
      final geocodingResponse = await http.get(Uri.parse(geocodingUrl));

      if (geocodingResponse.statusCode == 200) {
        final geocodingData = json.decode(geocodingResponse.body);

        if (geocodingData.isNotEmpty) {
          final lat = double.parse(geocodingData[0]['lat']);
          final lon = double.parse(geocodingData[0]['lon']);
          final radius = 0.1; // ~10km radius
          final south = lat - radius;
          final north = lat + radius;
          final west = lon - radius;
          final east = lon + radius;

          final overpassUrl = 'https://overpass-api.de/api/interpreter';
          final query = '''
            [out:json];
            node["amenity"="cinema"]($south,$west,$north,$east);
            out body;
          ''';

          final overpassResponse = await http.post(
            Uri.parse(overpassUrl),
            body: {'data': query},
          );

          if (overpassResponse.statusCode == 200) {
            final overpassData = json.decode(overpassResponse.body);
            final elements = overpassData['elements'] as List;

            setState(() {
              cinemaList = elements.map((cinema) => Cinema.fromJson(cinema)).toList();
            });
          } else {
            print('Error fetching cinemas: ${overpassResponse.statusCode}');
          }

        } else {
          print('Location not found.');
        }
      } else {
        print('Error fetching coordinates: ${geocodingResponse.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Cinema Halls'),
        backgroundColor: Colors.red, // Colorful AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              if (locationController.text.isNotEmpty) {
                fetchCoordinatesAndCinemas(locationController.text);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Poster Section with improved styling
            if (widget.movie != null) ...[
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.movie!.posterUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/placeholder.png', // Correct usage of a placeholder
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.movie!.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
            ],

            // Search Bar with colorful background
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                hintText: 'Enter a location',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white, // Colorful background
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onSubmitted: (value) {
                fetchCoordinatesAndCinemas(value);
              },
            ),
            const SizedBox(height: 20),

            // Loading indicator or Cinema list
            isLoading
                ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple), // Colorful loading spinner
              ),
            )
                : Expanded(
              child: cinemaList.isEmpty
                  ? const Center(
                child: Text(
                  'No cinemas found. Try a different location.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
                  : ListView.builder(
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
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.blueAccent, // Colorful background for cards
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      title: Text(
                        cinema.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // White text on colorful background
                        ),
                      ),
                      subtitle: Text(
                        'Coordinates: (${cinema.latitude}, ${cinema.longitude})',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70, // Light white text
                        ),
                      ),
                      onTap: () {
                        // Handle cinema details navigation if required
                      },
                    ),
                  ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
