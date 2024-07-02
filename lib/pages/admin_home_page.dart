import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
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
        color: Colors.grey[200],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: CircleButton(
                icon: Icons.add,
                color: Colors.green,
                onPressed: () {
                  Navigator.pushNamed(context, MyRouts.lostItemDetailsRout);
                },
              ),
            ),
            Expanded(
              child: CircleButton(
                icon: Icons.delete,
                color: Colors.red,
                onPressed: toggleDeleteIcons,
              ),
            ),
          ],
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
      margin: EdgeInsets.all(30),
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
      ),
    );
  }
}
