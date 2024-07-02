import 'package:flutter/material.dart';

class StudentHomePage extends StatefulWidget {
  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  List<Map<String, String>> cards = [
    {
      'title': 'card 1',
      'description': 'card description for Course 1',
      'imageUrl': 'https://via.placeholder.com/100'
    },
    {
      'title': 'card 2',
      'description': 'card description for card 2',
      'imageUrl': 'https://via.placeholder.com/100'
    },
    {
      'title': 'card 3',
      'description': 'card description for card 3',
      'imageUrl': 'https://via.placeholder.com/100'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Home Page'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: cards.length,
          itemBuilder: (context, index) {
            return CardItem(
              item: cards[index],
            );
          },
        ),
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  final Map<String, String> item;

  const CardItem({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.all(10),
        leading: Image.network(
          item['imageUrl']!,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
        title: Text(item['title']!),
        subtitle: Text(item['description']!),
      ),
    );
  }
}
