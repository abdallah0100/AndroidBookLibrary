import 'package:flutter/material.dart';

class BookScreen extends StatelessWidget {
  final String title;
  final List<Map<String, String>> books;
  final bool pdf;

  const BookScreen({required this.title, required this.books, required this.pdf, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // Blue background
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white, // Only title text white
            fontSize: 20,
          ),
        ),
        centerTitle: true, // Center title
        actions: [
          IconButton(
            icon: Icon(pdf ? Icons.picture_as_pdf : Icons.wordpress), // Keep default color (black)
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: const AssetImage('assets/app_icon.png'),
                  ),
                  title: Text(book['name'] ?? ''),
                  trailing: ElevatedButton(
                    onPressed: () {},
                    child: Text('GET'),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Upload Book'),
            ),
          ),
        ],
      ),
    );
  }
}
