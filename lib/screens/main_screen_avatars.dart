import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

final Uri _mapUrl1 = Uri.parse('https://www.google.com/maps/search/Toilets+near+me/@18.6481011,73.7595417,15z/data=!3m1!4b1?entry=ttu');
final Uri _mapUrl2 = Uri.parse('https://www.google.com/maps/search/Vehicle+Stations+near+me/@18.648198,73.7286412,13z/data=!3m1!4b1?entry=ttu');
final Uri _mapUrl3 = Uri.parse('https://www.google.com/maps/search/Hotels+near+me/@18.6483517,73.7286411,13z/data=!3m1!4b1?entry=ttu');
final Uri _mapUrl4 = Uri.parse('https://www.google.com/maps/search/games+station+near+me/@18.6485054,73.728641,13z/data=!3m1!4b1?entry=ttu');


class MidScreenAvatar extends StatelessWidget {
  const MidScreenAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: InkWell(
                       onTap: () => launchUrlString(_mapUrl1.toString()),
                      child: CircleAvatar(
                        maxRadius: 35,
                        child: Image.network("https://static.thenounproject.com/png/1272827-200.png", fit: BoxFit.cover, height: 55),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: InkWell(
                       onTap: () => launchUrlString(_mapUrl2.toString()),
                      child: CircleAvatar(
                        maxRadius: 35,
                        child: Image.network("https://cdn-icons-png.flaticon.com/512/713/713313.png", fit: BoxFit.cover, height: 55),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: InkWell(
                       onTap: () => launchUrlString(_mapUrl3.toString()),
                      child: CircleAvatar(
                        maxRadius: 35,
                        child: Image.network("https://cdn-icons-png.flaticon.com/512/4080/4080032.png", fit: BoxFit.cover,height: 55,),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: InkWell(
                      onTap: () => launchUrlString(_mapUrl4.toString()), 
                      child: CircleAvatar(
                        maxRadius: 35,
                        child: Image.network("https://cdn-icons-png.flaticon.com/512/5930/5930147.png", fit: BoxFit.cover, height:55),
                      ),
                    ),
                  ),
                  // Add more InkWell widgets for each social media icon
                ],
              ),
            );
  }
}