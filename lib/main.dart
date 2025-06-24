import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'BookScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ChildBookApp());
}

class ChildBookApp extends StatelessWidget {
  const ChildBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Child Book App',
      home: const AgeSelectionScreen(),
    );
  }
}

class AgeSelectionScreen extends StatelessWidget {
  const AgeSelectionScreen({super.key});

  final List<Map<String, String>> options = const [
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: AppBar(
          elevation: 4,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.lightBlueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.book_rounded, size: 32, color: Colors.white),
                    SizedBox(height: 6),
                    Text(
                      'Child Book Library',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Tap to explore or download your book!',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
        ),
      ),
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
                  final age = option['age']!;
                  final type = option['type']!;
                  final imagePath = option['image']!;

                  return GestureDetector(
                    onTap: () async {
                      try {
                        final ageGroup = age.replaceAll('-', '_');
                        final books = await fetchBooksFromFirebase(ageGroup, type)
                            .timeout(const Duration(seconds: 5), onTimeout: () {
                          throw Exception('Firebase request timed out');
                        });

                        if (!context.mounted) return;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookScreen(
                              title: 'Ages $age',
                              books: books,
                              pdf: type == 'PDF',
                            ),
                          ),
                        );
                      } catch (e) {
                        developer.log('Error fetching books: $e');
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
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
                              color: Colors.grey,
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

  Future<List<Map<String, String>>> fetchBooksFromFirebase(
      String ageGroup, String fileType) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref(ageGroup);

    DatabaseEvent event;
    try {
      event = await ref.once().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw Exception('Firebase request timed out');
        },
      );
    } catch (e) {
      throw Exception('Firebase error: $e');
    }

    if (!event.snapshot.exists || event.snapshot.value == null) {
      throw Exception('No data found for $ageGroup');
    }

    final data = Map<String, dynamic>.from(event.snapshot.value as Map);
    List<Map<String, String>> books = [];

    data.forEach((storyName, formats) {
      final formatLinks = Map<String, dynamic>.from(formats);
      final link = formatLinks[fileType];
      books.add({'name': storyName, 'url': link});
    });

    return books;
  }
}
