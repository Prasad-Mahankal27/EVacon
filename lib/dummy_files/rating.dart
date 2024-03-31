import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;
// Get the currently authenticated user
    User? user = FirebaseAuth.instance.currentUser;
    // Use the user's email as the document ID
    String userEmail = user!.email!;

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  double _rating = 0;
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _suggestionController = TextEditingController();

  void submit(String feedbacku, String suggestion) async {
  await FirebaseFirestore.instance
      .collection(userEmail)
      .doc('feedback') 
      .set({
    'feedback': feedbacku,
    'suggestions': suggestion,
  });
  _showFeedbackSnackbar(context);
  Navigator.pop(context);
}

void _showFeedbackSnackbar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Thank you for your feedback!"))
      );
}

  bool _isDarkTheme = false;

  final List<String> _feedback = ['Terrible', 'Bad', 'Average', 'Good', 'Excellent'];

  @override
  Widget build(BuildContext ctx) {
    return Theme(
      data: _isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Feedback', style: TextStyle(color: Colors.white)),
              backgroundColor: const Color(0xFF007bff),
              actions: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isDarkTheme = !_isDarkTheme;
                    });
                  },
                  icon: Icon(_isDarkTheme ? Icons.nightlight_round : Icons.wb_sunny),
                ),
              ],
            ),
            body: Container(
              height: constraints.maxHeight,
              // decoration: BoxDecoration(
              //   //gradient: _isDarkTheme ? _linearGradientDark() : _spiralGradientLight(),
              // ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Rate Our App', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _isDarkTheme ? Colors.white : Colors.red)),
                    const SizedBox(height: 10),
                    Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          children: [
                            EmojiRating(
                              onChanged: (value) {
                                setState(() {
                                  _rating = value;
                                });
                              },
                              value: _rating,
                            ),
                            const SizedBox(height: 8),
                            Text(_rating > 0 && _rating <= 5 ? _feedback[(_rating - 1).toInt()] : 'Tap an emoji to rate', style: TextStyle(fontSize: 20, color: _isDarkTheme ? Colors.white : Colors.black)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(controller: _textController, decoration: const InputDecoration(labelText: 'Your Feedback', border: OutlineInputBorder()), maxLines: 5),
                    const SizedBox(height: 20),
                    TextField(controller: _suggestionController, decoration: const InputDecoration(labelText: 'Your Suggestions', border: OutlineInputBorder()), maxLines: 5),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      child: const Text('Submit Feedback'),
                      onPressed: () {
                          submit(_textController.text.toString(), _suggestionController.text.toString());
                      } 
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _submitFeedback(BuildContext ctx) {
    print('Rating: $_rating');
    print('Feedback: ${_textController.text}');
    print('Suggestions: ${_suggestionController.text}');

    const snackBar = SnackBar(
      content: Row(
        children: [
          Text('Thank you for your feedback'),
          SizedBox(width: 8),
          Text('🙏'),
        ],
      ),
    );
    ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
  }

  Gradient _linearGradientDark() {
    return const LinearGradient(
      colors: [Color(0xFF13294b), Color(0xFF1a7ca8)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  Gradient _spiralGradientLight() {
    return const RadialGradient(
      colors: [Color(0xFF89cff0), Color(0xFF007bff)],
      center: Alignment.center,
      radius: 1.5,
      stops: [0.3, 1.0],
    );
  }
}

class EmojiRating extends StatelessWidget {
  final double value;
  final Function(double) onChanged;

  const EmojiRating({Key? key, required this.value, required this.onChanged}) : super(key: key);

  Widget buildEmoji(int index) {
    switch (index.toInt()) {
      case 1:
        return const Text('😔', style: TextStyle(fontSize: 40));
      case 2:
        return const Text('😕', style: TextStyle(fontSize: 40));
      case 3:
        return const Text('🙂', style: TextStyle(fontSize: 40));
      case 4:
        return const Text('😄', style: TextStyle(fontSize: 40));
      case 5:
        return const Text('😁', style: TextStyle(fontSize: 40));
      default:
        return const Text('');
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
            (index) => IconButton(
          icon: buildEmoji(index + 1),
          onPressed: () {
            onChanged(index.toDouble() + 1);
          },
        ),
      ),
    );
  }
}
