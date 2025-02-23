import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import 'word_detail_page.dart';

void main() {
  runApp(DictionaryApp());
}

class DictionaryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dictionary App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: DictionaryHomePage(),
    );
  }
}

class DictionaryHomePage extends StatefulWidget {
  @override
  _DictionaryHomePageState createState() => _DictionaryHomePageState();
}

class _DictionaryHomePageState extends State<DictionaryHomePage> {
  late Database _database;
  TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> recentWords = [];

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String dbPath = '${documentsDirectory.path}/mini_dictionary.db';

    if (!await File(dbPath).exists()) {
      ByteData data = await rootBundle.load('assets/mini_dictionary.db');
      List<int> bytes = data.buffer.asUint8List();
      await File(dbPath).writeAsBytes(bytes);
    }

    _database = await openDatabase(dbPath);
  }

  Future<Map<String, dynamic>?> _searchWord(String word) async {
    final List<Map<String, dynamic>> results = await _database.query(
      'dictionary',
      where: 'word = ?',
      whereArgs: [word],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<Map<String, dynamic>?> _getRandomWord() async {
    final List<Map<String, dynamic>> results = await _database.query('dictionary');
    return results.isNotEmpty ? results[Random().nextInt(results.length)] : null;
  }

  void _search() async {
    final word = _searchController.text.trim();
    if (word.isNotEmpty) {
      final result = await _searchWord(word);
      if (result != null) {
        setState(() {
          recentWords.insert(0, {
            'word': word,
            'type': 'Searched',
            'timestamp': DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now()),
          });
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) => WordDetailPage(wordData: result)));
      } else {
        _showError('Word not found');
      }
    }
  }

  void _showRandomWord() async {
    final result = await _getRandomWord();
    if (result != null) {
      setState(() {
        recentWords.insert(0, {
          'word': result['word'],
          'type': 'Random',
          'timestamp': DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.now()),
        });
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) => WordDetailPage(wordData: result)));
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: Text('Dictionary App', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              // style: TextStyle(color: Colors.white70),
              decoration: InputDecoration(
                labelText: 'Search Word',
                border: OutlineInputBorder(),
                prefixIcon: Icon(FlutterRemix.search_2_fill, color: Colors.deepPurple),
              ),
            ).animate().fade(duration: 500.ms).scale(delay: 200.ms),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _search,
                  icon: Icon(FlutterRemix.search_eye_fill,
                    color: Colors.white,),
                  label: Text('Search'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _showRandomWord,
                  icon: Icon(FlutterRemix.shuffle_fill,
                    color: Colors.white),
                  label: Text('Random Word'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                ),
              ],
            ).animate().slideX(duration: 500.ms),
            SizedBox(height: 20),
            Text('Recent Searches:', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: recentWords.length,
                itemBuilder: (context, index) {
                  final item = recentWords[index];
                  return Card(
                    color: item['type'] == 'Searched' ? Colors.deepPurple.shade100 : Colors.orange.shade100,
                    child: ListTile(
                      title: Text(item['word']!, style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${item['type']} • ${item['timestamp']}'),
                      leading: Icon(item['type'] == 'Searched' ? FlutterRemix.search_fill : FlutterRemix.shuffle_fill, color: Colors.deepPurple),
                      onTap: () async {
                        final result = await _searchWord(item['word']!);
                        if (result != null) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => WordDetailPage(wordData: result)));
                        }
                      },
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
