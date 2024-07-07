import 'package:flutter/material.dart';
import 'package:lost_and_found_app/pages/admin_student_button_page.dart';
import 'package:lost_and_found_app/services/student_authentication.dart';

class StudentHomePage extends StatefulWidget {
  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  List<Map<String, String>> cards = [
    {
      'title': 'Card 1',
      'description': 'Card description for Course 1',
      'imageUrl': 'https://via.placeholder.com/100'
    },
    {
      'title': 'Card 2',
      'description': 'Card description for Card 2',
      'imageUrl': 'https://via.placeholder.com/100'
    },
    {
      'title': 'Card 3',
      'description': 'Card description for Card 3',
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
                Navigator.of(context).pop(); // Close the dialog
                await StudentAuthentication()
                    .signOut(); // Go back to previous screen
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => AdminStudentButtonPage()));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Student Home Page'),
          automaticallyImplyLeading: false, // Remove the back button
          actions: [
            GestureDetector(
              onTap: _logout,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 7),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.red[600], // Light red color
                  shape: BoxShape.rectangle,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                      color: Colors.white, // White icon color
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Logout",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
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
                  title: cards[index]['title']!,
                  description: cards[index]['description']!,
                  imageUrl: cards[index]['imageUrl']!,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;

  const CardItem({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(
          imageUrl,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
        title: Text(title),
        subtitle: Text(description),
      ),
    );
  }
}
