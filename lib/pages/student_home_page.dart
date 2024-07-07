import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lost_and_found_app/pages/admin_student_button_page.dart';
import 'package:lost_and_found_app/services/student_authentication.dart';
import 'package:lost_and_found_app/utils/routs.dart';

class StudentHomePage extends StatefulWidget {
  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  final CollectionReference lostItemsCollection =
      FirebaseFirestore.instance.collection('lost_items');

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
    return Scaffold(
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
      body: StreamBuilder<QuerySnapshot>(
        stream: lostItemsCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No lost items found.'));
          }
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              return GestureDetector(
                onTap: () => _showItemDialog(context, data),
                child: Card(
                  margin: EdgeInsets.all(16),
                  child: Column(
                    children: [
                        data['images'].isEmpty
                          ? Container(
                            height: 200,
                            width: double.infinity,
                            color: Colors.grey,
                            child: Center(
                            child: Text(
                              'No Image Available',
                              style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              ),
                            ),
                            ),
                          )
                          : Image.network(
                            data['images'][0],
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.contain,
                          ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Founder: ${data['founderName']}'),
                            Text('Date: ${data['date']}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
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
                      style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showItemDialog(BuildContext context, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: StudentItemDetailsDialog(data: data),
      ),
    );
  }
}

class StudentItemDetailsDialog extends StatelessWidget {
  final Map<String, dynamic> data;

  StudentItemDetailsDialog({required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 300,
            child: PageView.builder(
              itemCount: data['images'].length,
              itemBuilder: (context, index) {
                return Image.network(
                  data['images'][index],
                  fit: BoxFit.contain,
                  height: double.infinity,
                  width: double.infinity,
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Description: ${data['description']}'),
                Text('Floor: ${data['floor']}'),
                Text('Class: ${data['class']}'),
                Text('Founder: ${data['founderName']}'),
                Text('Founder Email: ${data['founderEmail']}'),
                Text('Founder USN: ${data['founderUsn']}'),
                Text('Date: ${data['date']}'),
              ],
            ),
          ),
        ],
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
