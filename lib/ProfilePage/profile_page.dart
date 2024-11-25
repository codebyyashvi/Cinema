import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Correctly import the image picker

void main() {
  runApp(ProfilePage());
}

// User class definition that encapsulates user-related data
class USer {
  String name; // Name of the user
  String profilePicture; // URL for the user's profile picture
  String phoneNumber; // Phone number of the user
  String email; // Email ID of the user
  String address; // Address of the user
  String city; // City of the user
  final List<Map<String, String>> bookings; // List of bookings done by the user
  List<String> favoriteCinemas; // List of favorite cinemas

  // Constructor for the User class to initialize its properties
  USer({
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
  final USer user = USer(
    name: 'John Doe',
    profilePicture: 'https://via.placeholder.com/150',
    phoneNumber: '123-456-7890',
    email: 'john.doe@example.com',
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
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
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

  void _updateUserInfo(String field, String value) {
    setState(() {
      switch (field) {
        case 'name':
          user.name = value;
          break;
        case 'phone':
          user.phoneNumber = value;
          break;
        case 'email':
          user.email = value;
          break;
        case 'address':
          user.address = value;
          break;
        case 'city':
          user.city = value;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Profile Page'), // AppBar title
          backgroundColor: Colors.teal, // AppBar color
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
                        onTap:
                            _updateProfilePicture, // Clickable profile picture
                        child: CircleAvatar(
                          radius: 50, // Avatar size
                          backgroundImage: NetworkImage(
                              user.profilePicture), // Profile picture from URL
                        ),
                      ),
                      SizedBox(width: 16), // Space between avatar and name
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name, // Displaying user's name
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold), // Text style
                          ),
                          Text(user.phoneNumber), // Displaying phone number
                          Text(user.email), // Displaying email
                          Text(user.address), // Displaying address
                          Text(user.city), // Displaying city
                          SizedBox(height: 8),
                          TextButton(
                            onPressed: _removeProfilePicture,
                            child: Text(
                              'Remove Profile Photo',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16), // Space between boxes
                UpdateUserInfoWidget(
                    onUpdate: _updateUserInfo), // Widget to update user info
                SizedBox(height: 16), // Space between boxes
                // Booking Details Box
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[100], // Background color
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
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align text to the start
                    children: [
                      Text(
                        'Your Bookings:',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: double
                            .infinity, // Ensures the DropdownButton takes the full width
                        child: DropdownButton<String>(
                          isExpanded:
                              true, // Ensures the dropdown expands to fill the available width
                          hint: Text('Select a booking'),
                          value: selectedBookingTicketNo,
                          items: user.bookings.map((booking) {
                            return DropdownMenuItem<String>(
                              value: booking['ticketNo'],
                              child: Text(
                                  'Booking ${booking['ticketNo']} - ${booking['movie']}'),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedBookingTicketNo = value;
                            });
                          },
                        ),
                      ),
                      if (selectedBookingTicketNo != null) ...[
                        SizedBox(height: 16),
                        ...user.bookings
                            .where((booking) =>
                                booking['ticketNo'] == selectedBookingTicketNo)
                            .map((booking) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Movie: ${booking['movie']}'),
                              Text('Cinema: ${booking['cinema']}'),
                              Text('Ticket No: ${booking['ticketNo']}'),
                              Text('Seat No: ${booking['seatNo']}'),
                              Text(
                                  'Payment Status: ${booking['paymentStatus']}'),
                              Text('Booking Date: ${booking['bookingDate']}'),
                            ],
                          );
                        }).toList(),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 16), // Space between boxes
                FavouriteCinemasWidget(
                    user: user), // New Favourite Cinemas widget
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension on ImagePicker {
  getImage({required ImageSource source}) {}
}

// Update User Info Widget
class UpdateUserInfoWidget extends StatefulWidget {
  final Function(String, String) onUpdate;

  UpdateUserInfoWidget({required this.onUpdate});

  @override
  _UpdateUserInfoWidgetState createState() => _UpdateUserInfoWidgetState();
}

class _UpdateUserInfoWidgetState extends State<UpdateUserInfoWidget> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String phone = '';
  String email = '';
  String address = '';
  String city = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[100], // Background color
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Name'),
              onSaved: (value) {
                name = value ?? '';
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Phone Number'),
              onSaved: (value) {
                phone = value ?? '';
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Email'),
              onSaved: (value) {
                email = value ?? '';
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Address'),
              onSaved: (value) {
                address = value ?? '';
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'City'),
              onSaved: (value) {
                city = value ?? '';
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _formKey.currentState?.save();
                  widget.onUpdate('name', name);
                  widget.onUpdate('phone', phone);
                  widget.onUpdate('email', email);
                  widget.onUpdate('address', address);
                  widget.onUpdate('city', city);
                }
              },
              child: Text('Update Info'),
            ),
          ],
        ),
      ),
    );
  }
}

// Favourite Cinemas Widget
class FavouriteCinemasWidget extends StatefulWidget {
  final USer user;

  FavouriteCinemasWidget({required this.user});

  @override
  _FavouriteCinemasWidgetState createState() => _FavouriteCinemasWidgetState();
}

class _FavouriteCinemasWidgetState extends State<FavouriteCinemasWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[100], // Background color
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Favourite Cinemas:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ...widget.user.favoriteCinemas.map((cinema) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(cinema, style: TextStyle(fontSize: 16)),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      widget.user.favoriteCinemas.remove(cinema);
                    });
                  },
                ),
              ],
            );
          }).toList(),
          SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(labelText: 'Add Cinema'),
            onSubmitted: (cinema) {
              setState(() {
                widget.user.favoriteCinemas.add(cinema);
              });
            },
          ),
        ],
      ),
    );
  }
}
