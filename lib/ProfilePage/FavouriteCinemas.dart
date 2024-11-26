import 'package:flutter/material.dart';
class UserModel {
  String name;
  String profilePicture;
  String phoneNumber;
  String address;
  String city;
  List<String> favoriteCinemas;

  UserModel({
    required this.name,
    required this.profilePicture,
    required this.phoneNumber,
    required this.address,
    required this.city,
    required this.favoriteCinemas,
  });
}

class FavouriteCinemasWidget extends StatefulWidget {
  final UserModel user;  // Ensure this matches the UserModel type
  final Function(List<String>) onFavoriteCinemasUpdated;

  FavouriteCinemasWidget({
    required this.user,
    required this.onFavoriteCinemasUpdated,
  });

  @override
  _FavouriteCinemasWidgetState createState() => _FavouriteCinemasWidgetState();
}


class _FavouriteCinemasWidgetState extends State<FavouriteCinemasWidget> {
  late List<String> favoriteCinemas;
  final TextEditingController _cinemaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Create a local copy of the user's favorite cinemas
    favoriteCinemas = List<String>.from(widget.user.favoriteCinemas);
  }

  @override
  void dispose() {
    _cinemaController.dispose();
    super.dispose();
  }

  void _addCinema(String cinema) {
    setState(() {
      favoriteCinemas.add(cinema);
    });
    widget.onFavoriteCinemasUpdated(favoriteCinemas); // Notify parent
  }

  void _removeCinema(String cinema) {
    setState(() {
      favoriteCinemas.remove(cinema);
    });
    widget.onFavoriteCinemasUpdated(favoriteCinemas); // Notify parent
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.redAccent[100],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Favourite Cinemas:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            itemCount: favoriteCinemas.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(favoriteCinemas[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeCinema(favoriteCinemas[index]),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _cinemaController,
                  decoration: const InputDecoration(
                    hintText: 'Add a cinema',
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.green),
                onPressed: () {
                  if (_cinemaController.text.isNotEmpty) {
                    _addCinema(_cinemaController.text);
                    _cinemaController.clear(); // Clear the input
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
