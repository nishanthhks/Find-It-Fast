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
          backgroundColor: Colors.white, // Set background color to white
          content: Text(
            "Are you sure you want to logout?",
            style: TextStyle(color: Colors.black), // Content text color
          ),
          actions: [
            Container(
              decoration: BoxDecoration(
                color: Colors.black, // Button background color
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white), // Button text color
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black, // Button background color
                borderRadius: BorderRadius.circular(3),
              ),
              child: TextButton(
                child: Text(
                  "Logout",
                  style: TextStyle(color: Colors.white), // Button text color
                ),
                onPressed: () async {
                  Navigator.of(context).pop(); // Close the dialog
                  await StudentAuthentication()
                      .signOut(); // Go back to previous screen
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => AdminStudentButtonPage()));
                },
              ),
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
        title: Text(
          'LOST ITEMS',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false, // Remove the back button
        actions: [
          GestureDetector(
            onTap: _logout,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 7),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.black, // Changed to black background
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
                  elevation: 5,
                  margin: EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        color: Colors.grey,
                        child: data['images'].isEmpty
                            ? Center(
                          child: Text(
                            'No Image Available',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        )
                            : Image.network(
                          data['images'][0],
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Finder: ${data['finderName']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Date: ${data['date']}',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 14,
                              ),
                            ),
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
      bottomNavigationBar: BottomAppBar(
        elevation: 10,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.delete_outline),
              onPressed: () {
                // Implement your delete logic here
                Navigator.pushNamed(context, MyRouts.lostItemBinCatalogRout);
              },
              tooltip: 'Delete Items',
              color: Colors.black,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 300,
            child: PageView.builder(
              itemCount: data['images'].length,
              itemBuilder: (context, index) {
                return Image.network(
                  data['images'][index],
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Description:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(data['description']),
                SizedBox(height: 12),
                Text(
                  'Floor:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(data['floor']),
                SizedBox(height: 12),
                Text(
                  'Class:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(data['class']),
                SizedBox(height: 12),
                Text(
                  "Finder:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(data['finderName']),
                SizedBox(height: 12),
                Text(
                  "Finder's Email:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(data['finderEmail']),
                SizedBox(height: 12),
                Text(
                  "Finder's USN:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(data['finderUsn']),
                SizedBox(height: 12),
                Text(
                  'Date:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(data['date']),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
