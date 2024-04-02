import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: RatingPage(),
  ));
}

class RatingPage extends StatefulWidget {
  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  double _chargingSpeedRating = 0;
  double _pricingRating = 0;
  double _cleanlinessRating = 0;
  double _maintenanceRating = 0;
  TextEditingController _feedbackController = TextEditingController();

  void _submitFeedback() {
    // Here you can implement functionality to submit feedback to your backend or perform any other action needed
    
    // Show a dialog box to thank the user
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Thank you!"),
          content: const Text("Thank you for your valuable feedback!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate back to the home screen after 3 seconds
                Future.delayed(const Duration(seconds: 3), () {
                  Navigator.of(context).pop();
                });
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Station Feedback', style: TextStyle(fontSize: 24)),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Charging Speed',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            StarRating(
              key: const Key('charging_speed'),
              initialRating: _chargingSpeedRating,
              onRatingChanged: (rating) {
                setState(() {
                  _chargingSpeedRating = rating;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Pricing',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            StarRating(
              key: const Key('pricing'),
              initialRating: _pricingRating,
              onRatingChanged: (rating) {
                setState(() {
                  _pricingRating = rating;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Cleanliness',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            StarRating(
              key: const Key('cleanliness'),
              initialRating: _cleanlinessRating,
              onRatingChanged: (rating) {
                setState(() {
                  _cleanlinessRating = rating;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Maintenance',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            StarRating(
              key: const Key('maintenance'),
              initialRating: _maintenanceRating,
              onRatingChanged: (rating) {
                setState(() {
                  _maintenanceRating = rating;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Feedback for Improvement',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _feedbackController,
              maxLines: 4,
              style: const TextStyle(fontSize: 20),
              decoration: InputDecoration(
                hintText: 'Enter your feedback here...',
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 15),
            Center(
              child: ElevatedButton(
                onPressed: _submitFeedback,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StarRating extends StatefulWidget {
  final ValueChanged<double>? onRatingChanged;
  final double initialRating;

  StarRating({Key? key, this.onRatingChanged, required this.initialRating})
      : super(key: key);

  @override
  _StarRatingState createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  late double _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _rating = index + 1.0;
            });
            if (widget.onRatingChanged != null) {
              widget.onRatingChanged!(_rating);
            }
          },
          child: Icon(
            index < _rating ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 40,
          ),
        );
      }),
    );
  }
}
