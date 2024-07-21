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

  void _logout() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout"),
          backgroundColor: Colors.white,
          content: Text(
            "Are you sure you want to logout?",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            _buildDialogButton(
              label: "Cancel",
              onPressed: () => Navigator.of(context).pop(),
            ),
            _buildDialogButton(
              label: "Logout",
              onPressed: () async {
                Navigator.of(context).pop();
                await StudentAuthentication().signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => AdminStudentButtonPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDialogButton({required String label, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextButton(
        child: Text(label, style: TextStyle(color: Colors.white)),
        onPressed: onPressed,
      ),
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
        automaticallyImplyLeading: false,
        actions: [
          GestureDetector(
            onTap: _logout,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 7),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.rectangle,
              ),
              child: Row(
                children: [
                  Icon(Icons.logout, color: Colors.white),
                  SizedBox(width: 5),
                  Text("Logout", style: TextStyle(color: Colors.white)),
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
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              return GestureDetector(
                onTap: () => _showItemDialog(context, data),
                child: Card(
                  elevation: 5,
                  margin: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        data['images'] == null || data['images'].isEmpty
                            ? Container(
                                height: 100,
                                width: 100,
                                color: Colors.grey,
                                child: const Center(
                                  child: Text(
                                    'No Image',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              )
                            : Image.network(
                                data['images'][0] ?? '',
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Finder: ${data['finderName'] ?? 'Unknown'}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text('Date: ${data['date'] ?? 'Unknown'}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
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
              itemCount: (data['images'] ?? []).length,
              itemBuilder: (context, index) {
                return Image.network(
                  data['images'][index] ?? '',
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
                _buildDetailText('Description:', data['description'] ?? 'No description available'),
                _buildDetailText('Floor:', data['floor'] ?? 'Unknown'),
                _buildDetailText('Class:', data['class'] ?? 'Unknown'),
                _buildDetailText("Finder:", data['finderName'] ?? 'Unknown'),
                _buildDetailText("Finder's Email:", data['finderEmail'] ?? 'Unknown'),
                _buildDetailText("Finder's USN:", data['finderUsn'] ?? 'Unknown'),
                _buildDetailText('Date:', data['date'] ?? 'Unknown'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailText(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(value),
        SizedBox(height: 12),
      ],
    );
  }
}
