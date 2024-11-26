import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cinema/CinemaHall/CinemaHall.dart';
import 'package:cinema/main.dart';

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
  final Movie? movie; // Optional movie parameter

  CinemaListPage({this.movie});

  @override
  _CinemaListPageState createState() => _CinemaListPageState();
}

class _CinemaListPageState extends State<CinemaListPage> {
  List<Cinema> cinemaList = [];
  TextEditingController locationController = TextEditingController();
  bool isLoading = false;

  // Function to fetch cinemas by city
  Future<void> fetchCinemasByCity(String cityName) async {
    setState(() {
      isLoading = true;
    });

    try {
      final cityNameEncoded = Uri.encodeComponent(cityName);
      final overpassUrl = 'https://overpass-api.de/api/interpreter';
      final query = '''
        [out:json];
        area[name="$cityNameEncoded"][boundary=administrative];
        node(area)["amenity"="cinema"];
        out body;
      ''';

      final overpassResponse = await http.post(
        Uri.parse(overpassUrl),
        body: {'data': query},
      );

      if (overpassResponse.statusCode == 200) {
        final overpassData = json.decode(overpassResponse.body);
        print('Overpass response: $overpassData');
        final elements = overpassData['elements'] as List? ?? [];

        setState(() {
          cinemaList = elements.map((cinema) => Cinema.fromJson(cinema)).toList();
        });
      } else {
        print('Error fetching cinemas: ${overpassResponse.statusCode}');
        setState(() {
          cinemaList = [];
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        cinemaList = [];
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cinema Halls in Your City'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Movie Poster Section
            if (widget.movie != null) ...[
              Container(
                height: 200,
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
                        'assets/images/placeholder.png',
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

            // Search Bar for City Name
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                hintText: 'Enter city name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.location_city),
              ),
              onSubmitted: (value) {
                fetchCinemasByCity(value);
              },
            ),
            const SizedBox(height: 20),

            // Loading indicator or Cinema list
            isLoading
                ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            )
                : Expanded(
              child: cinemaList.isEmpty
                  ? const Center(
                child: Text(
                  'No cinemas found. Try a different city.',
                  style:
                  TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
                  : ListView.builder(
                itemCount: cinemaList.length,
                itemBuilder: (context, index) {
                  final cinema = cinemaList[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: Colors.blueAccent,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        cinema.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        'Coordinates: (${cinema.latitude}, ${cinema.longitude})',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
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
