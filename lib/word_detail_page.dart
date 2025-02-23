import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WordDetailPage extends StatelessWidget {
  final Map<String, dynamic> wordData;

  WordDetailPage({required this.wordData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: Text(
          wordData['word'] ?? 'Word Details',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(FlutterRemix.arrow_left_s_line, size: 28),
          onPressed: () => Navigator.pop(context),
        ).animate().fade(duration: 400.ms).scale(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetail("Word", wordData['word'], Colors.deepPurple),
                  _buildDetail("IPA", wordData['ipa'], Colors.blue),
                  _buildDetail("TPA", wordData['tpa'], Colors.green),
                  _buildDetail("English Definition", wordData['english_definition'], Colors.red),
                  _buildDetail("Tamil Definition", wordData['tamil_definition'], Colors.orange),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(FlutterRemix.arrow_left_circle_fill,color: Colors.lightGreenAccent, size: 24),
                      label: Text('Back'),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                    )
                        .animate()
                        .fade(duration: 500.ms)
                        .scale(delay: 200.ms)
                        .shake(duration: 400.ms),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetail(String title, String? content, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: color,
          highlightColor: Colors.white,
          child: Text(
            title,
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ).animate().fade(duration: 500.ms).scale(),
        SizedBox(height: 5),
        Text(
          content ?? 'N/A',
          style: GoogleFonts.poppins(fontSize: 16),
        ).animate().fade(duration: 400.ms).slideY(begin: 0.5, end: 0),
        SizedBox(height: 10),
      ],
    );
  }
}
