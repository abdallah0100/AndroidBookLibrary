import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BookScreen extends StatelessWidget {
  final String title;
  final List<Map<String, String>> books;
  final bool pdf;

  const BookScreen({
    required this.title,
    required this.books,
    required this.pdf,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(pdf ? Icons.picture_as_pdf : Icons.description),
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
                final url = book['url'];
                final name = book['name'] ?? '';

                return ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/app_icon.png'),
                  ),
                  title: Text(name),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      if (url != null) {
                        try {
                          final uri = Uri.parse(url);
                          final launched = await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                          if (!launched) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Could not launch URL')),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Error launching URL: $e')),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('URL is null')),
                        );
                      }
                    },
                    child: const Text('GET'),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('Upload Book functionality not implemented')),
                );
              },
              child: const Text('Upload Book'),
            ),
          ),
        ],
      ),
    );
  }
}
