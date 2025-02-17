import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_remix/flutter_remix.dart'; // Import flutter_remix
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
        primarySwatch: Colors.deepPurple, // Changed primary color
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        scaffoldBackgroundColor: Color(0xFFF8F8FF), // Light background
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
  TextEditingController _controller = TextEditingController();
  List<Map<String, String>> searchHistory = [];
  Map<String, dynamic> dictionaryData = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadDictionaryData();
  }

  Future<void> loadDictionaryData() async {
    String data = await rootBundle.loadString('assets/mini_dictionary.json');
    setState(() {
      dictionaryData = json.decode(data);
    });
  }

  Future<void> searchWord(String word, String source) async {
    setState(() => isLoading = true);
    await Future.delayed(Duration(milliseconds: 500));

    if (dictionaryData.containsKey(word.toLowerCase())) {
      setState(() {
        searchHistory.insert(0, {
          "word": word,
          "source": source,
          "time": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        });
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WordDetailPage(
              word: word, data: dictionaryData[word.toLowerCase()]),
        ),
      );
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Word not found"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
    setState(() => isLoading = false);
  }

  Future<void> fetchRandomWord() async {
    if (dictionaryData.isNotEmpty) {
      List<String> words = dictionaryData.keys.toList();
      String randomWord = (words..shuffle()).first;
      searchWord(randomWord, "random_button");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(FlutterRemix.arrow_left_line, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Dictionary App', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF673AB7), // Deep purple app bar
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Enter a word",
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  prefixIcon: Icon(FlutterRemix.search_line,
                      color: Colors.grey[500]), // Remix icon
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        searchWord(_controller.text.trim(), "search_bar"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF673AB7), // Deep purple
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text("Search", style: TextStyle(fontSize: 16)),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: fetchRandomWord,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4CAF50), // Green
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text("Random Word", style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Loading Indicator
            if (isLoading)
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            // Search History
            Expanded(
              child: ListView(
                children: [
                  Divider(color: Colors.grey[300]),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text("Search History",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  ...searchHistory.map(
                        (entry) => Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Text(entry["word"]!,
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        subtitle: Text(
                            "Source: ${entry["source"]}, Time: ${entry["time"]}",
                            style: TextStyle(fontSize: 12)),
                        onTap: () => searchWord(entry["word"]!, "history"),
                        leading: Icon(FlutterRemix.history_line,
                            color: Color(0xFF673AB7)), // Remix icon
                        trailing: Icon(FlutterRemix.arrow_right_s_line,
                            color: Colors.grey[500], size: 16), // Remix icon
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}