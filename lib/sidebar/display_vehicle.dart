import 'package:ev/auth/uihelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

User? user = FirebaseAuth.instance.currentUser;
String userEmail = user!.email!;

class displayVehicle extends StatefulWidget {
  const displayVehicle({super.key});

  @override
  State<displayVehicle> createState() => _displayVehicleState();
}

class _displayVehicleState extends State<displayVehicle> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Details'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(userEmail)
            .doc('vehicle')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists) {
            return const Center(
              child: Text('No profile created'),
            );
          } else {
            var profileData = snapshot.data!.data() as Map<String, dynamic>;
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("VEHICLE DETAILS", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                    const SizedBox(height: 25,),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  UiHelper.TextS('Vehicle name:'),
                                  const SizedBox(height: 20,),
                                  UiHelper.TextS('Model:'),
                                  const SizedBox(height: 20,),
                                  UiHelper.TextS('Registration No.:'),
                                  const SizedBox(height: 20,),
                                  UiHelper.TextS('VIN:'),
                                ],
                              ),
                              const SizedBox(width: 20,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  UiHelper.TextS('${profileData['name']}'),
                                   const SizedBox(height: 20,),
                                  UiHelper.TextS('${profileData['model']}'),
                                   const SizedBox(height: 20,),
                                  UiHelper.TextS('${profileData['vehicle no.']}'),
                                   const SizedBox(height: 20,),
                                  UiHelper.TextS('${profileData['VIN']}'),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );;
  }
}
