import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:ev/screens/map_api.dart';

final Uri _mapUrl1 = Uri.parse(
    'https://www.google.com/maps/search/Toilets+near+me/@18.6481011,73.7595417,15z/data=!3m1!4b1?entry=ttu');
final Uri _mapUrl2 = Uri.parse(
    'https://www.google.com/maps/search/Vehicle+Stations+near+me/@18.648198,73.7286412,13z/data=!3m1!4b1?entry=ttu');
final Uri _mapUrl3 = Uri.parse(
    'https://www.google.com/maps/search/Hotels+near+me/@18.6483517,73.7286411,13z/data=!3m1!4b1?entry=ttu');
final Uri _mapUrl4 = Uri.parse(
    'https://www.google.com/maps/search/games+station+near+me/@18.6485054,73.728641,13z/data=!3m1!4b1?entry=ttu');

class MidScreenAvatar extends StatelessWidget {
  const MidScreenAvatar({Key? key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildLogoButton(context, "Toilet"),
          _buildLogoButton(context, "Mechanic"),
          _buildLogoButton(context, "Food"),
          _buildLogoButton(context, "Games"),
        ],
      ),
    );
  }

  Widget _buildLogoButton(BuildContext context, String searchTerm) {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: InkWell(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(nSearch: searchTerm),
            ),
          );
        },
        child: CircleAvatar(
          maxRadius: 35,
          child: Image.network(
            _getImageUrlForSearchTerm(searchTerm),
            fit: BoxFit.cover,
            height: 55,
          ),
        ),
      ),
    );
  }

  String _getImageUrlForSearchTerm(String searchTerm) {
    switch (searchTerm.toLowerCase()) {
      case "toilet":
        return "https://static.thenounproject.com/png/1272827-200.png";
      case "mechanic":
        return "https://cdn-icons-png.flaticon.com/512/713/713313.png";
      case "food":
        return "https://cdn-icons-png.flaticon.com/512/4080/4080032.png";
      case "games":
        return "https://cdn-icons-png.flaticon.com/512/5930/5930147.png";
      default:
        return "";
    }
  }
}
