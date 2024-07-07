import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lost_and_found_app/services/admin_authentication.dart'; // Import your admin authentication service
import 'package:lost_and_found_app/pages/admin_student_button_page.dart';
import 'package:lost_and_found_app/utils/routs.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final CollectionReference lostItemsCollection =
      FirebaseFirestore.instance.collection('lost_items');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Home Page'),
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
                onTap: () => _showItemDialog(context, doc.id, data),
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

  void _showItemDialog(
      BuildContext context, String docId, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: ItemDetailsDialog(docId: docId, data: data),
      ),
    );
  }
}

class ItemDetailsDialog extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> data;

  ItemDetailsDialog({required this.docId, required this.data});

  @override
  _ItemDetailsDialogState createState() => _ItemDetailsDialogState();
}

class _ItemDetailsDialogState extends State<ItemDetailsDialog> {
  bool showCollectionFields = false;
  final TextEditingController receiverNameController = TextEditingController();
  final TextEditingController receiverUsnController = TextEditingController();
  final TextEditingController receiverEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 300,
            child: PageView.builder(
              itemCount: widget.data['images'].length,
              itemBuilder: (context, index) {
                return Image.network(
                  widget.data['images'][index],
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
                Text('Description: ${widget.data['description']}'),
                Text('Floor: ${widget.data['floor']}'),
                Text('Class: ${widget.data['class']}'),
                Text('Founder: ${widget.data['founderName']}'),
                Text('Founder Email: ${widget.data['founderEmail']}'),
                Text('Founder USN: ${widget.data['founderUsn']}'),
                Text('Date: ${widget.data['date']}'),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showCollectionFields = !showCollectionFields;
                    });
                  },
                  child: Text(showCollectionFields ? 'Hide' : 'Collect'),
                ),
                if (showCollectionFields)
                  Column(
                    children: [
                      TextField(
                        controller: receiverNameController,
                        decoration: InputDecoration(labelText: 'Receiver Name'),
                      ),
                      TextField(
                        controller: receiverUsnController,
                        decoration: InputDecoration(labelText: 'Receiver USN'),
                      ),
                      TextField(
                        controller: receiverEmailController,
                        decoration:
                            InputDecoration(labelText: 'Receiver Email'),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _submitCollectionDetails,
                        child: Text('Submit'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitCollectionDetails() async {
    final String receiverName = receiverNameController.text;
    final String receiverUsn = receiverUsnController.text;
    final String receiverEmail = receiverEmailController.text;

    try {
      await FirebaseFirestore.instance.collection('collected_items').add({
        ...widget.data,
        'receiverName': receiverName,
        'receiverUsn': receiverUsn,
        'receiverEmail': receiverEmail,
      });
      await FirebaseFirestore.instance
          .collection('lost_items')
          .doc(widget.docId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Collection details submitted successfully!')),
      );
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit collection details: $e')),
      );
    }
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
