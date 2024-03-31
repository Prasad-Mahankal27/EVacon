import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev/auth/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileInputForm extends StatefulWidget {
  @override
  _ProfileInputFormState createState() => _ProfileInputFormState();
}

class _ProfileInputFormState extends State<ProfileInputForm> {
  TextEditingController _fullNameController = TextEditingController();
  //TextEditingController _emailController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _districtController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _pincodeController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  String _selectedGender = 'Male'; // Default gender selection
  File? pickedImage;

void submitProfile(String name, String country, String district, String state, String city, String pin, String phone) async {
  try {
    // Get the currently authenticated user
    User? user = FirebaseAuth.instance.currentUser;
    // Use the user's email as the document ID
    String userEmail = user!.email!;

    // Set profile details in Firestore using the user's email as the document ID
    await FirebaseFirestore.instance.collection(userEmail).doc('details').set({
      'name': name,
      'email': userEmail,
      'gender': _selectedGender,
      'country': country,
      'district': district,
      'state': state,
      'city': city,
      'pincode': pin,
      'phone': phone,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile Changes saved!")),
    );

    // Navigate back to previous screen
    Navigator.pop(context);
  } catch (error) {
    // Handle any errors
    print("Error submitting profile: $error");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Error submitting profile!")),
    );
  }
}


  showDialogBox(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Pick image from"),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Ensure the dialog size fits its content
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () {
                  // Add logic to handle camera option
                  pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text("Gallery"),
                onTap: () {
                  // Add logic to handle gallery option
                  pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

 pickImage(ImageSource imageSource) async {
  try {
    final photo = await ImagePicker().pickImage(source: imageSource);
    if (photo == null) {
      return;
    }
    final tempImage = File(photo.path);
    setState(() {
      pickedImage = tempImage;
    });
  } catch (error) {
    print("Error picking image: $error"); // Log the error for debugging
    // Optionally, show a snackbar to the user:
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Error accessing camera or gallery")),
    );
  }
 }

UploadData() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    String userEmail = user!.email!;

    // Upload the image to Firebase Storage
    UploadTask uploadTask = FirebaseStorage.instance.ref('$userEmail').putFile(pickedImage!);
    TaskSnapshot taskSnapshot = await uploadTask;

    // Get the download URL for the uploaded image
    String imageUrl = await taskSnapshot.ref.getDownloadURL();

    // Store the image details in Firestore
    await FirebaseFirestore.instance.collection(userEmail).doc('images').set({
      "email": userEmail,
      "image": imageUrl,
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile Changes saved!")),
      );
    }
    Navigator.pop(context);
  } catch (error) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error submitting image!")),
      );
    }
    print("Error uploading image: $error");
  }
}


void deleteCollection() async {
    try {
    User? user = FirebaseAuth.instance.currentUser;
    String userEmail = user!.email!;
      await FirebaseFirestore.instance.collection(userEmail).get().then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
    } catch (error) {
      return ;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: InkWell(
                  onTap: () {
                    deleteCollection();
                    showDialogBox(context);
                 },
                  child: pickedImage != null
                      ? CircleAvatar(
                          radius: 60,
                          backgroundImage: FileImage(pickedImage!),
                        )
                      : const CircleAvatar(
                          radius: 80,
                          child: Icon(Icons.person, size: 90),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                keyboardType: TextInputType.text, // Text input type
              ),
              const SizedBox(height: 30),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                onChanged: (newValue) {
                  setState(() {
                    _selectedGender = newValue!;
                  });
                },
                items: ['Male', 'Female', 'Others']
                    .map((gender) => DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _countryController,
                      decoration: const InputDecoration(labelText: 'Country'),
                      keyboardType: TextInputType.text, // Text input type
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _districtController,
                      decoration: const InputDecoration(labelText: 'District'),
                      keyboardType: TextInputType.text, // Text input type
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _stateController,
                decoration: const InputDecoration(labelText: 'State'),
                keyboardType: TextInputType.text, // Text input type
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(labelText: 'City'),
                      keyboardType: TextInputType.text, // Text input type
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _pincodeController,
                      decoration: const InputDecoration(labelText: 'Pincode'),
                      keyboardType: TextInputType.number, // Numeric input type
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone, // Phone number input type
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Save button logic...

                    submitProfile(
                      _fullNameController.text.toString(),
                     // _emailController.text.toString(),
                      _countryController.text.toString(),
                      _districtController.text.toString(),
                      _stateController.text.toString(),
                      _cityController.text.toString(),
                      _pincodeController.text.toString(),
                      _phoneNumberController.text.toString()
                    );
                    UploadData();
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _fullNameController.dispose();
  //  _emailController.dispose();
    _countryController.dispose();
    _districtController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }
}
