import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lost_and_found_app/services/admin_authentication.dart';
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
        title: Text('LOST ITEMS'),
        backgroundColor: Colors.white,
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
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
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
                    Map<String, dynamic> data =
                    doc.data() as Map<String, dynamic>;
                    return GestureDetector(
                      onTap: () => _showItemDialog(context, doc.id, data),
                      child: Card(
                        margin: EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 5,
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              data['images'].isEmpty
                                  ? Container(
                                height: 100,
                                width: 100,
                                color: Colors.grey,
                                child: Center(
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
                                data['images'][0],
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Finder: ${data['finderName']}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text('Date: ${data['date']}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.delete_outline),
                      color: Colors.red,
                      iconSize: 30,
                      onPressed: () {
                        Navigator.pushNamed(
                            context, MyRouts.lostItemBinCatalogRout);
                      },
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Found Items',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      color: Colors.green,
                      iconSize: 30,
                      onPressed: () {
                        Navigator.pushNamed(
                            context, MyRouts.lostItemDetailsRout);
                      },
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Add',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
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
              style: TextButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
            ),
            TextButton(
              child: Text("Logout"),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await AdminAuthentication().signOut(); // Add your logout logic here
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => AdminStudentButtonPage(),
                  ),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
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
      builder: (context) => ItemDetailsDialog(docId: docId, data: data),
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
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              SizedBox(height: 16),
              Divider(),
              Text(
                'Description: ${widget.data['description']}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Floor: ${widget.data['floor']}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Class: ${widget.data['class']}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Finder's: ${widget.data['finderName']}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Finder's Email: ${widget.data['finderEmail']}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Finder's USN: ${widget.data['finderUsn']}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Date: ${widget.data['date']}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Divider(),
              if (showCollectionFields) ...[
                TextField(
                  controller: receiverNameController,
                  decoration: InputDecoration(
                    labelText: 'Receiver Name',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: receiverUsnController,
                  decoration: InputDecoration(
                    labelText: 'Receiver USN',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: receiverEmailController,
                  decoration: InputDecoration(
                    labelText: 'Receiver Email',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitCollectionDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Submit'),
                ),
                SizedBox(height: 16),
              ],
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showCollectionFields = !showCollectionFields;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: Text(showCollectionFields ? 'Hide' : 'Collect'),
              ),
            ],
          ),
        ),
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

  CircleButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
