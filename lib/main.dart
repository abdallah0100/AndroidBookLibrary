import 'package:flutter/material.dart';

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

  final String wordIconUrl =
      'https://img.icons8.com/color/96/000000/ms-word.png'; // made bigger (96px)
  final String pdfIconUrl =
      'https://img.icons8.com/color/96/000000/pdf.png'; // made bigger (96px)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Child Book App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Choose your child\'s age:',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Image.network(
                      wordIconUrl,
                      width: 60,
                      height: 60,
                    ),
                    const SizedBox(height: 4),
                    const Text('Word'),
                  ],
                ),
                Column(
                  children: [
                    Image.network(
                      pdfIconUrl,
                      width: 60,
                      height: 60,
                    ),
                    const SizedBox(height: 4),
                    const Text('PDF'),
                  ],
                ),
              ],
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
                    // from here the data is send to the 2nd screen
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookListScreen(
                            ageRange: age,
                            fileType: type,
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


 /// remove this, this is a temp 2ndry screen
class BookListScreen extends StatelessWidget {
  final String ageRange;
  final String fileType;

  const BookListScreen({
    Key? key,
    required this.ageRange,
    required this.fileType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$fileType Books - Ages $ageRange'),
      ),
      body: Center(
        child: Text(
          'This is the book list screen for $fileType, ages $ageRange.\nYour partner can build here.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
