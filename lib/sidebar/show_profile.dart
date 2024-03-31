import 'package:ev/auth/uihelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

User? user = FirebaseAuth.instance.currentUser;
String userEmail = user!.email!;

class show_profile extends StatefulWidget {
  @override
  State<show_profile> createState() => _show_profileState();
}

class _show_profileState extends State<show_profile> {
  Future<String?> getImageUrl(String userEmail) async {
    try {
      // Check if the image exists for the user in Firebase Storage
      String imageUrl =
          await FirebaseStorage.instance.ref(userEmail).getDownloadURL();
      return imageUrl;
    } catch (error) {
      // If the image doesn't exist or there's an error, return null
      print("Error getting image URL: $error");
      return null;
    }
  }

  Widget buildProfilePic(String userEmail) {
    return FutureBuilder<String?>(
      future: getImageUrl(userEmail),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // If the future is still loading, return a loading indicator or placeholder
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // If there's an error fetching the image URL, return the default icon
          return const Icon(Icons.person);
        } else if (snapshot.hasData && snapshot.data != null) {
          // If the image URL is available, return the image widget
          return CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(snapshot.data!),
          );
        } else {
          // If the image doesn't exist, return the default icon
          return const Icon(Icons.person);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Details'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(userEmail)
            .doc('details')
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
                  children: [
                    CircleAvatar(minRadius: 15, child: buildProfilePic(userEmail)),
                    const SizedBox(height: 20,),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  UiHelper.TextS('Name:'),
                                  UiHelper.TextS('Email:'),
                                  UiHelper.TextS('Gender:'),
                                  UiHelper.TextS('Country:'),
                                  UiHelper.TextS('District:'),
                                  UiHelper.TextS('State:'),
                                  UiHelper.TextS('City:'),
                                  UiHelper.TextS('Pincode:'),
                                  UiHelper.TextS('Phone:'),
                                ],
                              ),
                              const SizedBox(width: 25,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  UiHelper.TextS('${profileData['name']}'),
                                  UiHelper.TextS('${profileData['email']}'),
                                  UiHelper.TextS('${profileData['gender']}'),
                                  UiHelper.TextS('${profileData['country']}'),
                                  UiHelper.TextS('${profileData['district']}'),
                                  UiHelper.TextS('${profileData['state']}'),
                                  UiHelper.TextS('${profileData['city']}'),
                                  UiHelper.TextS('${profileData['pincode']}'),
                                  UiHelper.TextS('${profileData['phone']}'),
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
    );
  }
}
