import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LostItemBinCatalog extends StatelessWidget {
  final CollectionReference collectedItemsCollection =
      FirebaseFirestore.instance.collection('collected_items');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Found Items History'),
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: collectedItemsCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No collected items found.'));
          }
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              return CollectedItemCard(
                data: data,
                onTap: () => _showItemDialog(context, data),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  void _showItemDialog(BuildContext context, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: CollectedItemDetailsDialog(data: data),
      ),
    );
  }
}

class CollectedItemCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onTap;

  const CollectedItemCard({required this.data, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              data['images'].isEmpty
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
                      data['images'][0],
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Receiver: ${data['receiverName']}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CollectedItemDetailsDialog extends StatelessWidget {
  final Map<String, dynamic> data;

  const CollectedItemDetailsDialog({required this.data, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
                    fit: BoxFit.contain,
                    height: double.infinity,
                    width: double.infinity,
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            ItemDetailText(label: 'Description', value: data['description']),
            const SizedBox(height: 8),
            ItemDetailText(label: 'Floor', value: data['floor']),
            const SizedBox(height: 8),
            ItemDetailText(label: 'Class', value: data['class']),
            const SizedBox(height: 8),
            ItemDetailText(label: "Finder's Name", value: data['finderName']),
            const SizedBox(height: 8),
            ItemDetailText(label: "Finder's Email", value: data['finderEmail']),
            const SizedBox(height: 8),
            ItemDetailText(label: "Finder's USN", value: data['finderUsn']),
            const SizedBox(height: 8),
            ItemDetailText(label: 'Date', value: data['date']),
            const SizedBox(height: 16),
            const Divider(),
            ItemDetailText(label: 'Receiver Name', value: data['receiverName']),
            const SizedBox(height: 8),
            ItemDetailText(label: 'Receiver USN', value: data['receiverUsn']),
            const SizedBox(height: 8),
            ItemDetailText(label: 'Receiver Email', value: data['receiverEmail']),
          ],
        ),
      ),
    );
  }
}

class ItemDetailText extends StatelessWidget {
  final String label;
  final String value;

  const ItemDetailText({required this.label, required this.value, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '$label: $value',
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}
