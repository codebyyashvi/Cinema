import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'FavouriteCinemas.dart';
import 'Edit.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserModel user = UserModel(
    name: '',
    profilePicture: 'https://via.placeholder.com/150',
    phoneNumber: '',
    address: '',
    city: '',
    favoriteCinemas: [],
  );

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserDetailsFromLocal(); // Load user details from local storage
  }

  // Load user details from local SharedPreferences
  Future<void> _loadUserDetailsFromLocal() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      user.name = prefs.getString('name') ?? '';
      user.phoneNumber = prefs.getString('phoneNumber') ?? '';
      user.address = prefs.getString('address') ?? '';
      user.city = prefs.getString('city') ?? '';
      user.profilePicture = prefs.getString('profilePicture') ?? 'https://via.placeholder.com/150';
      user.favoriteCinemas = prefs.getStringList('favoriteCinemas') ?? [];
    });
  }

  // Save user info in SharedPreferences
  Future<void> _saveUserInfoLocally() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('name', user.name);
    await prefs.setString('phoneNumber', user.phoneNumber);
    await prefs.setString('address', user.address);
    await prefs.setString('city', user.city);
    await prefs.setString('profilePicture', user.profilePicture);
    await prefs.setStringList('favoriteCinemas', user.favoriteCinemas);
  }

  // Update profile picture by selecting from gallery
  Future<void> _updateProfilePicture() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        user.profilePicture = pickedFile.path;
      });
    }
  }

  // Save user info to both Firestore and SharedPreferences
  Future<void> _saveUserInfo() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        // Save to Firestore
        await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).set({
          'name': user.name,
          'phoneNumber': user.phoneNumber,
          'address': user.address,
          'city': user.city,
          'favoriteCinemas': user.favoriteCinemas,
          'profilePicture': user.profilePicture,
        }, SetOptions(merge: true)); // Use merge to avoid overwriting other fields

        // Save locally in SharedPreferences
        await _saveUserInfoLocally();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile section
              Container(
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
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _updateProfilePicture,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: user.profilePicture.startsWith('http')
                            ? NetworkImage(user.profilePicture)
                            : FileImage(File(user.profilePicture)) as ImageProvider,
                      ),
                    ),
                    const SizedBox(width: 16),
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
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: _saveUserInfo,
                            child: const Text('Save Profile'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Favorite cinemas section
              FavouriteCinemasWidget(
                user: user,
                onFavoriteCinemasUpdated: (updatedCinemas) {
                  setState(() {
                    user.favoriteCinemas = updatedCinemas;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
