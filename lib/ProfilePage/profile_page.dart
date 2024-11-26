import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Correctly import the image picker

void main() {
  runApp(ProfilePage());
}

// User class definition that encapsulates user-related data
class User {
  String name; // Name of the user
  String profilePicture; // URL for the user's profile picture
  String phoneNumber; // Phone number of the user
  final String email; // Email ID of the user (read-only)
  String address; // Address of the user
  String city; // City of the user
  final List<Map<String, String>> bookings; // List of bookings done by the user
  List<String> favoriteCinemas; // List of favorite cinemas

  User({
    required this.name,
    required this.profilePicture,
    required this.phoneNumber,
    required this.email,
    required this.address,
    required this.city,
    required this.bookings,
    required this.favoriteCinemas,
  });
}

// ProfilePage is a StatefulWidget representing the user profile UI
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Creating an instance of User with sample data
  final User user = User(
    name: 'John Doe',
    profilePicture: 'https://via.placeholder.com/150',
    phoneNumber: '123-456-7890',
    email: 'john.doe@example.com', // Email is read-only
    address: '123 Street, Example Town',
    city: 'Example City',
    bookings: [
      {
        'movie': 'Inception',
        'cinema': 'Cineworld',
        'ticketNo': 'T123456',
        'seatNo': 'A10',
        'paymentStatus': 'Paid',
        'bookingDate': '2023-08-15'
      },
      {
        'movie': 'Interstellar',
        'cinema': 'IMAX',
        'ticketNo': 'T123457',
        'seatNo': 'B10',
        'paymentStatus': 'Paid',
        'bookingDate': '2023-08-20'
      },
    ],
    favoriteCinemas: [],
  );

  final picker = ImagePicker(); // Image picker instance
  String? selectedBookingTicketNo;

  Future<void> _updateProfilePicture() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        user.profilePicture = pickedFile.path;
      });
    }
  }

  void _removeProfilePicture() {
    setState(() {
      user.profilePicture = 'https://via.placeholder.com/150';
    });
  }

  void _saveUserInfo() {
    // Logic to save user data to Firebase or local storage can be added here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile updated successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Profile Page'), // AppBar title
          backgroundColor: Colors.red, // AppBar color
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // User Info Box
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.teal[100], // Background color
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3), // Shadow color
                        spreadRadius: 2, // Shadow spread
                        blurRadius: 5, // Shadow blur
                        offset: Offset(0, 3), // Shadow offset
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _updateProfilePicture,
                        child: CircleAvatar(
                          radius: 50, // Avatar size
                          backgroundImage: NetworkImage(user.profilePicture),
                        ),
                      ),
                      SizedBox(width: 16), // Space between avatar and form
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            EditableTextField(
                              label: 'Name',
                              initialValue: user.name,
                              onChanged: (value) => user.name = value,
                            ),
                            EditableTextField(
                              label: 'Phone',
                              initialValue: user.phoneNumber,
                              onChanged: (value) => user.phoneNumber = value,
                              keyboardType: TextInputType.phone,
                            ),
                            Text(
                              'Email: ${user.email}', // Email is read-only
                              style: TextStyle(fontSize: 16),
                            ),
                            EditableTextField(
                              label: 'Address',
                              initialValue: user.address,
                              onChanged: (value) => user.address = value,
                            ),
                            EditableTextField(
                              label: 'City',
                              initialValue: user.city,
                              onChanged: (value) => user.city = value,
                            ),
                            SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: _saveUserInfo,
                              child: Text('Save Profile'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16), // Space between boxes
                // Booking Details Box
                // Booking-related implementation remains unchanged
                SizedBox(height: 16), // Space between boxes
                FavouriteCinemasWidget(user: user), // New Favorite Cinemas widget
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Editable TextField Widget for Reusability
class EditableTextField extends StatelessWidget {
  final String label;
  final String initialValue;
  final Function(String) onChanged;
  final TextInputType keyboardType;

  EditableTextField({
    required this.label,
    required this.initialValue,
    required this.onChanged,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(labelText: label),
      keyboardType: keyboardType,
      onChanged: onChanged,
    );
  }
}

// Favourite Cinemas Widget remains unchanged
class FavouriteCinemasWidget extends StatefulWidget {
  final User user;

  FavouriteCinemasWidget({required this.user});

  @override
  _FavouriteCinemasWidgetState createState() => _FavouriteCinemasWidgetState();
}

class _FavouriteCinemasWidgetState extends State<FavouriteCinemasWidget> {
  late List<String> favoriteCinemas;

  @override
  void initState() {
    super.initState();
    // Initialize with user's favorite cinemas
    favoriteCinemas = List<String>.from(widget.user.favoriteCinemas);
  }

  void _addCinema(String cinema) {
    setState(() {
      favoriteCinemas.add(cinema);
      widget.user.favoriteCinemas = favoriteCinemas;
    });
  }

  void _removeCinema(String cinema) {
    setState(() {
      favoriteCinemas.remove(cinema);
      widget.user.favoriteCinemas = favoriteCinemas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[100],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Favourite Cinemas:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ...favoriteCinemas.map((cinema) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(cinema, style: TextStyle(fontSize: 16)),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeCinema(cinema),
                ),
              ],
            );
          }).toList(),
          SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(labelText: 'Add Cinema'),
            onSubmitted: _addCinema,
          ),
        ],
      ),
    );
  }
}
