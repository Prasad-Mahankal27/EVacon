import 'package:ev/screens/map_api.dart';
import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 11, left: 11),
      child: Card(
        elevation: 10,
        color: Colors.white,
        shadowColor: Colors.black,
        child: Column(
          children: [
            Container(
              height: 200,
              width: 330,
            ),
            Text("Long Press to open Map: ", style: TextStyle(letterSpacing: 2,color: Colors.red[900], fontSize: 10, fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );
  }
}
