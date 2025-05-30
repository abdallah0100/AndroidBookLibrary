import 'package:flutter/material.dart';
import 'BookScreen.dart';

void main() {
  runApp(ChildBookApp());
}

class ChildBookApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Child Book App',
      home: AgeSelectionScreen(),
    );
  }
}

class AgeSelectionScreen extends StatelessWidget {
  final List<Map<String, String>> options = [
    {'age': '0-4', 'type': 'Word', 'image': 'assets/images/ages_0_4.png'},
    {'age': '0-4', 'type': 'PDF', 'image': 'assets/images/ages_0_4.png'},
    {'age': '4-8', 'type': 'Word', 'image': 'assets/images/ages_4_8.png'},
    {'age': '4-8', 'type': 'PDF', 'image': 'assets/images/ages_4_8.png'},
    {'age': '8-12', 'type': 'Word', 'image': 'assets/images/ages_8_12.png'},
    {'age': '8-12', 'type': 'PDF', 'image': 'assets/images/ages_8_12.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Child Book App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Choose your child\'s age:',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                itemCount: options.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final option = options[index];
                  final age = option['age'] ?? '';
                  final type = option['type'] ?? '';
                  final imagePath = option['image'] ?? '';

                  return GestureDetector(
                    onTap: () {
                      // Prepare sample books for the selected age and type
                      final sampleBooks = [
                        {'name': 'Book 1'},
                        {'name': 'Book 2'},
                        {'name': 'Book 3'},
                      ];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookScreen(
                            title: 'Ages $age',
                            books: sampleBooks,
                            pdf: type == 'PDF',
                          ),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                imagePath,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Ages $age',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            type,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
