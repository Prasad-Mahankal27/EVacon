import 'dart:math'; // Import 'dart:math' for random number generation
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class StatusPage extends StatefulWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  double _randomValue = 0.5; // Default value

  @override
  void initState() {
    super.initState();
    _generateRandomValue();
  }

  void _generateRandomValue() {
    setState(() {
      _randomValue = Random().nextDouble(); // Generate random number between 0 and 1
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.greenAccent, Colors.blueAccent],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Charging Update',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircularPercentIndicator(
                      animation: true,
                      animationDuration: 1000,
                      radius: 150,
                      lineWidth: 30,
                      percent: _randomValue, // Use the random value here
                      progressColor: Colors.green,
                      backgroundColor: Colors.green.shade100,
                      circularStrokeCap: CircularStrokeCap.round,
                      center: Text(
                        "${(_randomValue * 100).toInt()}%", // Display the percentage
                        style: TextStyle(fontSize: 50, color: Colors.black),
                      ),
                    ),
                    SizedBox(height: 20), // Add space below the indicator

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}