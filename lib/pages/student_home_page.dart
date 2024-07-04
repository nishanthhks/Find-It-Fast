import 'package:flutter/material.dart';
import 'package:lost_and_found_app/pages/admin_student_button_page.dart';
import 'package:lost_and_found_app/services/authentication.dart';

class StudentHomePage extends StatefulWidget {
  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  List<Map<String, String>> cards = [
    {
      'title': 'card 1',
      'description': 'card description for Course 1',
      'imageUrl': 'https://via.placeholder.com/100'
    },
    {
      'title': 'card 2',
      'description': 'card description for card 2',
      'imageUrl': 'https://via.placeholder.com/100'
    },
    {
      'title': 'card 3',
      'description': 'card description for card 3',
      'imageUrl': 'https://via.placeholder.com/100'
    },
  ];

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Logout"),
              onPressed: () async {
                // Add your logout logic here
                // For example, navigating back to the login page
                Navigator.of(context).pop(); // Close the dialog

                await AuthServices().signOut(); // Go back to previous screen
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AdminStudentButtonPage()));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Home Page'),
        actions: [
          GestureDetector(
            onTap: _logout,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red[600], // Light red color
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.logout,
                color: Colors.white, // White icon color
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: cards.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: CardItem(
                item: cards[index],
              ),
            );
          },
        ),
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  final Map<String, String> item;

  const CardItem({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.all(15),
        leading: Image.network(
          item['imageUrl']!,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
        title: Text(item['title']!),
        subtitle: Text(item['description']!),
      ),
    );
  }
}
