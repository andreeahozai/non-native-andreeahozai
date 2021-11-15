import 'package:flutter/material.dart';

import 'sql_helper.dart';
import 'add.dart';
import 'update.dart';
import 'book.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // Remove the debug banner
        debugShowCheckedModeBanner: false,
        title: 'Books',
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
        ),
        home: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Book> booksList = [];
  late final data;
  bool _isLoading = true;

  void _refreshList(int index) async {
    setState(() {
      booksList.removeAt(index);
    });
  }

  void _initList() async {
    final data = await SQLHelper.getItems();
    setState(() {
      booksList.clear();
      for (int i = 0; i < data.length; i++) {
        booksList.add(Book(
            id: data[i]['id'],
            title: data[i]['title'],
            author: data[i]['author'],
            category: data[i]['category'],
            price: double.parse(data[i]['price']),
            stock: int.parse(data[i]['stock']),
            publishing_house: data[i]['publishing_house']));
      }
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _initList();
  }

  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a journal!'),
    ));
  }

  Future<void> _showMyDialog(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Are you sure you want to delete the book ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteItem(booksList[index].id);
                _refreshList(index);
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
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
        title: const Text('Books'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: booksList.length,
              itemBuilder: (context, index) => Card(
                color: Colors.lightBlue[200],
                margin: const EdgeInsets.all(15),
                child: ListTile(
                    title: Text(booksList[index].title),
                    subtitle: Text(booksList[index].author +
                        "\n" +
                        booksList[index].category +
                        "\n" +
                        booksList[index].price.toString() +
                        "\n" +
                        booksList[index].stock.toString() +
                        "\n" +
                        booksList[index].publishing_house),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          UpdatePage(book: booksList[index])),
                                );
                              }),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _showMyDialog(index);
                            },
                          ),
                        ],
                      ),
                    )),
              ),
            ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Add()),
            );
          }),
    );
  }
}
