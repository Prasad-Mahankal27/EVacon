// import 'package:evsathi/screens/featurePage/module/station.dart';
import 'package:ev/dummy_files/booking_page.dart';
import 'package:ev/screens/upi.dart';
import 'package:flutter/material.dart';

class stationDetailPage extends StatefulWidget {
  

  const stationDetailPage({Key? key, }) : super(key: key);

  @override
  State<stationDetailPage> createState() => _stationDetailPageState();
}

class _stationDetailPageState extends State<stationDetailPage> {
  bool isHovered1 = false;
  bool isHovered2 = false;
  String avail = 'Available';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.grey[900],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.greenAccent, Colors.blueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: ListView(
                  children: [
                    SizedBox(height: 20),
                    Center(
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'image1.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
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
                                  SizedBox(width: 10),
                                  Text(
                                    '4.0',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Tata',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: avail == 'Busy'
                                      ? Colors.red
                                      : Colors.greenAccent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  avail,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          SizedBox(height: 20),
                          Text(
                            "Description",
                            style: TextStyle(
                              color: Colors.grey[900],
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Latitude: 28.6139 \n Longitude: 77.2090 \n Price per 15 min (in rupees): 50 \n Charge Type: DC \n Speed (kW): 50 \n Distance from Location (km): 2.5",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green, Colors.green],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: EdgeInsets.all(25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MouseRegion(
                    onEnter: (_) {
                      setState(() {
                        isHovered1 = true;
                      });
                    },
                    onExit: (_) {
                      setState(() {
                        isHovered1 = false;
                      });
                    },
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                         onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PhonePePayment()),
            );
          },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isHovered1
                                  ? [Colors.greenAccent, Colors.blueAccent]
                                  : [Colors.blue, Colors.green],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 10.0,
                          ),
                          child: Text(
                            "Booking",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  MouseRegion(
                    onEnter: (_) {
                      setState(() {
                        isHovered2 = true;
                      });
                    },
                    onExit: (_) {
                      setState(() {
                        isHovered2 = false;
                      });
                    },
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isHovered2
                                  ? [Colors.greenAccent, Colors.blueAccent]
                                  : [Colors.blue, Colors.green],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 10.0,
                          ),
                          child: Text(
                            "Rating Page",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
