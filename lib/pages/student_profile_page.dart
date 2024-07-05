import 'package:flutter/material.dart';

class StudentProfilePage extends StatefulWidget {
  @override
  _StudentProfilePageState createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  String _name = 'John Doe';
  String _usnNumber = '123456789';
  String _email = 'johndoe@example.com';
  String _photoUrl = 'assets/images/default_profile.png'; // Default photo URL

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                // TODO: Implement photo selection logic
              },
              child: CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage(_photoUrl),
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Name'),
              subtitle: Text(_name),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // TODO: Implement name editing logic
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.confirmation_number),
              title: Text('USN Number'),
              subtitle: Text(_usnNumber),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // TODO: Implement USN number editing logic
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Email'),
              subtitle: Text(_email),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // TODO: Implement email editing logic
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}