import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LostItemBinCatalog extends StatelessWidget {
  final CollectionReference collectedItemsCollection =
      FirebaseFirestore.instance.collection('collected_items');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lost Item Bin Catalog'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: collectedItemsCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No collected items found.'));
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
                            Text('Finder: ${data['finderName']}'),
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
    );
  }

  void _showItemDialog(BuildContext context, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: CollectedItemDetailsDialog(data: data),
      ),
    );
  }
}

class CollectedItemDetailsDialog extends StatelessWidget {
  final Map<String, dynamic> data;

  CollectedItemDetailsDialog({required this.data});

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
                Text("Finders's: ${data['finderName']}"),
                Text("Finders's Email: ${data['finderEmail']}"),
                Text("Finders's USN: ${data['finderUsn']}"),
                Text('Date: ${data['date']}'),
                SizedBox(height: 16),
                Text('Receiver Name: ${data['receiverName']}'),
                Text('Receiver USN: ${data['receiverUsn']}'),
                Text('Receiver Email: ${data['receiverEmail']}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
