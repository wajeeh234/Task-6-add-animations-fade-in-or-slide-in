import 'package:flutter/material.dart';

void main() {
  runApp(ItemListApp());
}

class ItemListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Item List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: ItemListScreen(),
      routes: {
        '/details': (context) => ItemDetailsScreen(),
      },
    );
  }
}

class Fruit {
  final String name;
  final String description;

  Fruit({required this.name, required this.description});
}

class ItemListScreen extends StatefulWidget {
  @override
  _ItemListScreenState createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  final List<Fruit> items = [
    Fruit(
      name: 'Apple',
      description: 'Apples are nutritious and delicious.',
    ),
    Fruit(
      name: 'Banana',
      description: 'Bananas are high in potassium and great for snacks.',
    ),
    Fruit(
      name: 'Cherry',
      description: 'Cherries are small, round, and red or black in color.',
    ),
    Fruit(
      name: 'Date',
      description: 'Dates are sweet fruits of the date palm tree.',
    ),
    Fruit(
      name: 'Elderberry',
      description:
          'Elderberries are small, dark berries that grow in clusters.',
    ),
    Fruit(
      name: 'Fig',
      description: 'Figs are soft, sweet fruits with a thin skin.',
    ),
    Fruit(
      name: 'Grape',
      description:
          'Grapes can be eaten fresh or used to make wine, juice, and jelly.',
    ),
    Fruit(
      name: 'Honeydew',
      description: 'Honeydew melons are sweet and green-fleshed.',
    ),
    Fruit(
      name: 'Iced Apple',
      description: 'Iced apples are frozen versions of regular apples.',
    ),
    Fruit(
      name: 'Jackfruit',
      description:
          'Jackfruits are large, tropical fruits with a spiky exterior.',
    ),
  ];

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fruits List'),
        centerTitle: true,
        backgroundColor: Colors.yellow,
      ),
      body: AnimatedList(
        key: _listKey,
        initialItemCount: items.length,
        itemBuilder: (context, index, animation) {
          return _buildItem(items[index], animation, index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildItem(Fruit item, Animation<double> animation, int index) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        margin: EdgeInsets.all(4.0),
        child: ListTile(
          title: Text(
            item.name,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    ItemDetailsScreen(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.ease;

                  final tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
                settings: RouteSettings(arguments: item),
              ),
            );
          },
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _removeItem(index),
          ),
        ),
      ),
    );
  }

  void _showAddItemDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newItem = Fruit(
                  name: nameController.text,
                  description: descriptionController.text,
                );
                setState(() {
                  items.add(newItem);
                  _listKey.currentState?.insertItem(items.length - 1);
                });
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _removeItem(int index) {
    final removedItem = items.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildItem(removedItem, animation, index),
      duration: Duration(milliseconds: 300),
    );
  }
}

class ItemDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Fruit item = ModalRoute.of(context)!.settings.arguments as Fruit;

    return Scaffold(
      appBar: AppBar(
        title: Text('${item.name} Details'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'hero-${item.name}',
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    item.name,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                item.description,
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
