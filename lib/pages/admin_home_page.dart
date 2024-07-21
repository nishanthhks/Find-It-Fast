import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lost_and_found_app/services/admin_authentication.dart';
import 'package:lost_and_found_app/pages/admin_student_button_page.dart';
import 'package:lost_and_found_app/utils/routs.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

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
        title: const Text('LOST ITEMS'),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [LogoutButton()],
      ),
      body: Column(
        children: [
          Expanded(child: LostItemsList(collection: lostItemsCollection)),
          const AdminActionButtons(),
        ],
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await AdminAuthentication().signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const AdminStudentButtonPage(),
                  ),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _logout(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 7),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.red[600],
          shape: BoxShape.rectangle,
        ),
        child: const Row(
          children: [
            Icon(
              Icons.logout,
              color: Colors.white,
            ),
            SizedBox(width: 5),
            Text(
              "Logout",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class LostItemsList extends StatelessWidget {
  final CollectionReference collection;

  const LostItemsList({super.key, required this.collection});

  void _showItemDialog(BuildContext context, String docId, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => ItemDetailsDialog(docId: docId, data: data),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: collection.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No lost items found.'));
        }
        return ListView(
          children: snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return GestureDetector(
              onTap: () => _showItemDialog(context, doc.id, data),
              child: LostItemCard(data: data),
            );
          }).toList(),
        );
      },
    );
  }
}

class LostItemCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const LostItemCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
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
    );
  }
}

class AdminActionButtons extends StatelessWidget {
  const AdminActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AdminActionButton(
            icon: Icons.delete_outline,
            color: Colors.red,
            label: 'Found Items',
            onPressed: () {
              Navigator.pushNamed(context, MyRouts.lostItemBinCatalogRout);
            },
          ),
          AdminActionButton(
            icon: Icons.add_circle_outline,
            color: Colors.green,
            label: 'Add',
            onPressed: () {
              Navigator.pushNamed(context, MyRouts.lostItemDetailsRout);
            },
          ),
        ],
      ),
    );
  }
}

class AdminActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onPressed;

  const AdminActionButton({
    super.key,
    required this.icon,
    required this.color,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon),
          color: color,
          iconSize: 30,
          onPressed: onPressed,
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class ItemDetailsDialog extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> data;

  const ItemDetailsDialog({super.key, required this.docId, required this.data});

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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 300,
                child: PageView.builder(
                  itemCount: widget.data['images'].length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      widget.data['images'][index] ?? '',
                      fit: BoxFit.contain,
                      height: double.infinity,
                      width: double.infinity,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              ItemDetailText(label: 'Description', value: widget.data['description'] ?? 'No description available'),
              ItemDetailText(label: 'Floor', value: widget.data['floor'] ?? 'Unknown'),
              ItemDetailText(label: 'Class', value: widget.data['class'] ?? 'Unknown'),
              ItemDetailText(label: "Finder's Name", value: widget.data['finderName'] ?? 'Unknown'),
              ItemDetailText(label: "Finder's Email", value: widget.data['finderEmail'] ?? 'Unknown'),
              ItemDetailText(label: "Finder's USN", value: widget.data['finderUsn'] ?? 'Unknown'),
              ItemDetailText(label: 'Date', value: widget.data['date'] ?? 'Unknown'),
              const SizedBox(height: 16),
              const Divider(),
              if (showCollectionFields) ...[
                CollectionField(
                  controller: receiverNameController,
                  label: 'Receiver Name',
                ),
                CollectionField(
                  controller: receiverUsnController,
                  label: 'Receiver USN',
                ),
                CollectionField(
                  controller: receiverEmailController,
                  label: 'Receiver Email',
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitCollectionDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Submit'),
                ),
                const SizedBox(height: 16),
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Collection details submitted successfully!')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit collection details: $e')),
        );
      }
    }
  }
}

class ItemDetailText extends StatelessWidget {
  final String label;
  final String value;

  const ItemDetailText({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        '$label: $value',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class CollectionField extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const CollectionField({
    super.key,
    required this.controller,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
