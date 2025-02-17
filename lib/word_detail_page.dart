import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_remix/flutter_remix.dart';

class WordDetailPage extends StatelessWidget {
  final String word;
  final Map<String, dynamic> data;

  WordDetailPage({required this.word, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF0F5), // Light pink background
      appBar: AppBar(
        backgroundColor: Colors.black, // Black app bar
        title: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              word.toUpperCase(),
              textStyle: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.yellow, // Yellow text
              ),
              speed: const Duration(milliseconds: 100),
            ),
          ],
          totalRepeatCount: 1,
        ),
        leading: IconButton(
          icon: Icon(FlutterRemix.arrow_left_line, color: Colors.yellow),
          onPressed: () => Navigator.of(context).pop(),
        ),
        iconTheme: IconThemeData(color: Colors.yellow), // Yellow back arrow
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IPA
            Row(
              children: [
                Icon(FlutterRemix.mic_line,
                    color: Colors.yellow), // Remix icon (mic_line)
                SizedBox(width: 8),
                Text("IPA: ",
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                Text("${data["ipa"]}",
                    style: GoogleFonts.poppins(
                        fontSize: 18, color: Colors.black)),
              ],
            )
                .animate()
                .fadeIn(duration: 500.ms)
                .slideX(begin: -1, end: 0, duration: 500.ms),
            SizedBox(height: 10),
            // TPA
            Row(
              children: [
                Icon(FlutterRemix.text, color: Colors.yellow), // Remix icon
                SizedBox(width: 8),
                Text("TPA: ",
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                Text("${data["tpa"]}",
                    style: GoogleFonts.poppins(
                        fontSize: 18, color: Colors.black)),
              ],
            )
                .animate()
                .fadeIn(duration: 500.ms)
                .slideX(begin: -1, end: 0, duration: 500.ms),
            SizedBox(height: 20),
            // English Definition
            Text("English Definition:",
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black))
                .animate()
                .fadeIn(duration: 500.ms)
                .slideX(begin: -1, end: 0, duration: 500.ms),
            SizedBox(height: 8),
            Text(data["english_definition"],
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black))
                .animate()
                .fadeIn(duration: 500.ms)
                .slideX(begin: -1, end: 0, duration: 500.ms),
            SizedBox(height: 20),
            // Tamil Definition
            Text("Tamil Definition:",
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black))
                .animate()
                .fadeIn(duration: 500.ms)
                .slideX(begin: -1, end: 0, duration: 500.ms),
            SizedBox(height: 8),
            Text(data["tamil_definition"],
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black))
                .animate()
                .fadeIn(duration: 500.ms)
                .slideX(begin: -1, end: 0, duration: 500.ms),
          ],
        ),
      ),
    );
  }
}