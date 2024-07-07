import 'package:flutter/material.dart';
import 'package:lost_and_found_app/services/admin_authentication.dart'; // Import your admin authentication service
import 'package:lost_and_found_app/pages/admin_student_button_page.dart';
import 'package:lost_and_found_app/utils/routs.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  List<Map<String, String>> items = [
    {
      'title': 'Card 1',
      'description': 'This is the description for card 1',
      'imageUrl': 'https://via.placeholder.com/100'
    },
    {
      'title': 'Card 2',
      'description': 'This is the description for card 2',
      'imageUrl': 'https://via.placeholder.com/100'
    },
    {
      'title': 'Card 3',
      'description': 'This is the description for card 3',
      'imageUrl': 'https://via.placeholder.com/100'
    },
  ];

  bool showDeleteIcon = false;

  void toggleDeleteIcons() {
    setState(() {
      showDeleteIcon = !showDeleteIcon;
    });
  }

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
                await AdminAuthentication()
                    .signOut(); // Add your logout logic here
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => AdminStudentButtonPage()));
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    return false; // Prevent back navigation
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Admin Home Page'),
          automaticallyImplyLeading: false, // Remove the back button
          actions: [
            GestureDetector(
              onTap: _logout,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red[600],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return CardItem(
                    title: items[index]['title']!,
                    description: items[index]['description']!,
                    imageUrl: items[index]['imageUrl']!,
                    showDeleteIcon: showDeleteIcon,
                    onDelete: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Delete Confirmation'),
                            content: Text('Do you want to delete this card?'),
                            actions: [
                              TextButton(
                                child: Text('No'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('Yes'),
                                onPressed: () {
                                  setState(() {
                                    items.removeAt(index);
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          color: const Color.fromARGB(255, 0, 0, 0),
          padding:
              EdgeInsets.symmetric(vertical: 10), // Added padding for spacing
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // Ensure Column takes minimum space needed
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      CircleButton(
                        icon: Icons.delete_outline,
                        color: Colors.blue,
                        onPressed: () {
                          // Implement your delete logic here
                          Navigator.pushNamed(
                              context, MyRouts.lostItemBinCatalogRout);
                        },
                      ),
                       // Added for spacing between button and text
                        const Text(
                        'Bin',
                        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 18),
                        ),
                    ],
                  ),
                  Column(
                    children: [
                      CircleButton(
                        icon: Icons.add,
                        color: Colors.green,
                        onPressed: () {
                          // Implement your add logic here
                          Navigator.pushNamed(
                              context, MyRouts.lostItemDetailsRout);
                        },
                      ),
                      // Added for spacing between button and text
                      const Text(
                        'Add',
                        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 18),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      CircleButton(
                        icon: Icons.delete,
                        color: Colors.red,
                        onPressed: toggleDeleteIcons,
                      ),
                      // Added for spacing between button and text
                      const Text(
                        'Delete',
                        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ],
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
  final bool showDeleteIcon;
  final VoidCallback onDelete;

  const CardItem({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.showDeleteIcon,
    required this.onDelete,
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
        trailing: showDeleteIcon
            ? IconButton(
                icon: Icon(Icons.close),
                onPressed: onDelete,
              )
            : null,
      ),
    );
  }
}

class CircleButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const CircleButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: Colors.white,
        ),
        onPressed: onPressed,
        tooltip: 'Button Tooltip',
      ),
    );
  }
}