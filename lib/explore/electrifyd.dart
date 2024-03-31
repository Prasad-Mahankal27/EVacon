import 'package:flutter/material.dart';

class Electrify extends StatelessWidget {
  final String availability;
  Electrify({Key? key, required this.availability}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.star,
                  color: Colors.yellow[800],
                ),
                const SizedBox(width: 10),
                Text(
                  '4.0',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Text(
              'Tata',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 12,
              ),
              decoration: BoxDecoration(
                color: availability == 'Busy' ? Colors.red : Colors.greenAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                availability,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const SizedBox(height: 20),
        Text(
          "Description",
          style: TextStyle(
            color: Colors.grey[900],
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          " Latitude: 28.6139 \n Longitude: 77.2090 \n Price per 15 min (in rupees): 50 \n Charge Type: DC \n Speed (kW): 50 \n Distance from Location (km): 2.5",
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
