import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class BookScreen extends StatefulWidget {
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
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  Map<String, bool> downloading = {};
  Map<String, bool> downloaded = {};

  Future<String> getDownloadPath() async {
    if (Platform.isAndroid) {
      return '/storage/emulated/0/Download';
    } else {
      final dir = await getApplicationDocumentsDirectory();
      return dir.path;
    }
  }

  Future<void> _checkDownloads() async {
    final path = await getDownloadPath();
    for (var book in widget.books) {
      final name = book['name']!;
      final file = File('$path/$name.${widget.pdf ? "pdf" : "docx"}');
      downloaded[name] = await file.exists();
    }
    setState(() {});
  }

  Future<void> _downloadFile(String url, String name) async {
    final status = await Permission.storage.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Storage permission denied')),
      );
      return;
    }

    final path = await getDownloadPath();
    final filePath = '$path/$name.${widget.pdf ? "pdf" : "docx"}';

    try {
      setState(() => downloading[name] = true);

      await Dio().download(url, filePath, deleteOnError: true);

      downloaded[name] = true;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Download completed')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download failed: $e')),
      );
    } finally {
      setState(() => downloading[name] = false);
    }
  }

  Future<void> _openFile(String name) async {
    final path = await getDownloadPath();
    final filePath = '$path/$name.${widget.pdf ? "pdf" : "docx"}';
    await OpenFile.open(filePath);
  }

  @override
  void initState() {
    super.initState();
    _checkDownloads();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          automaticallyImplyLeading: true,
          elevation: 4,
          backgroundColor: Colors.transparent,
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
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.books.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final book = widget.books[index];
                final name = book['name']!;
                final url = book['url']!;
                final isDownloading = downloading[name] ?? false;
                final isDownloaded = downloaded[name] ?? false;

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/app_icon.png'),
                      backgroundColor: Colors.white,
                    ),
                    title: Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    trailing: isDownloading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.lightBlueAccent,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: () {
                                  if (isDownloaded) {
                                    _openFile(name);
                                  } else {
                                    _downloadFile(url, name);
                                  }
                                },
                                child: Text(isDownloaded ? 'OPEN' : 'GET'),
                              ),
                              const SizedBox(width: 6),
                              if (isDownloaded)
                                IconButton(
                                  tooltip: 'Redownload',
                                  icon: const Icon(Icons.refresh),
                                  onPressed: () => _downloadFile(url, name),
                                ),
                            ],
                          ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload Book'),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Upload Book functionality not implemented')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
