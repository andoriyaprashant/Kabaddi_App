import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kabadi/constants.dart';
import 'package:kabadi/screens/custom_textform.dart';

class EditTeamProfilePage extends StatelessWidget {
  const EditTeamProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 100),
            child: Center(
              child: Text(
                "Edit Team Profile",
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        body: const SingleChildScrollView(
          child: EditTeamProfileForm(),
        ),
      ),
    );
  }
}

class EditTeamProfileForm extends StatefulWidget {
  const EditTeamProfileForm({Key? key}) : super(key: key);

  @override
  _EditTeamProfileFormState createState() => _EditTeamProfileFormState();
}

class _EditTeamProfileFormState extends State<EditTeamProfileForm> {
  // TextEditingController _firstNameController = TextEditingController();
  TextEditingController _teamNameController = TextEditingController();
  // TextEditingController _emailController = TextEditingController();
  // TextEditingController _phoneNumberController = TextEditingController();
  // TextEditingController _cityController = TextEditingController();
  // TextEditingController _stateController = TextEditingController();

  // TextEditingController _newPasswordController = TextEditingController();
  // TextEditingController _confirmPasswordController = TextEditingController();
  bool _isChecked = false;
  Uint8List? _pickedImage;
  Rx<bool> isLoading = false.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(userProfile.value);
    if (userProfile.value.isNotEmpty) {
      _teamNameController.text = userProfile.value["name"];
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFf7f2f0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  pickImage();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 64,
                      backgroundImage: _pickedImage == null
                          ? (userProfile.value.isEmpty)
                              ? const NetworkImage(
                                      'https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png')
                                  as ImageProvider
                              : NetworkImage(userProfile.value["logo"])
                                  as ImageProvider
                          : MemoryImage(_pickedImage!),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        pickImage();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    CustomTextFormField(
                      controller: _teamNameController,
                      heading: "Enter Team Name",
                      hintText: "Enter name",
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked = value ?? false;
                          });
                        },
                        checkColor: Colors.white,
                        activeColor: Colors.black,
                      ),
                      const Text("Terms and conditions",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      constraints: const BoxConstraints(
                          maxWidth:
                              600), // Adjust the maxWidth as per your layout
                      child: const Text(
                        'Welcome to Kabadi App. These Terms and Conditions outline the rules and regulations for the use of Kabadi App\'s services. By accessing this app, we assume you accept these terms and conditions. Do not continue to use Kabadi App if you do not agree to take all of the terms and conditions stated on this page. By using Kabadi App, users acknowledge and agree to the collection and use of their personal information as outlined in the app\'s Privacy Policy. Kabadi App is committed to protecting the privacy of its users and will only use personal information in accordance with applicable laws and regulations.',
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Obx(() {
                  return ElevatedButton(
                    onPressed: () {
                      // Add logic to update profile
                      _updateProfile();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 70,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      backgroundColor: const Color(0xFFfc5607),
                      foregroundColor: Colors.white,
                    ),
                    child: isLoading.value
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Update Profile",
                            style: TextStyle(color: Colors.white),
                          ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateProfile() async {
    // Get the current user
    isLoading.value = true;
    setState(() {});
    User? user = FirebaseAuth.instance.currentUser;
    if (_formKey.currentState!.validate()) {
      if (user != null && _isChecked) {
        // Prepare the data to update
        var url;
        if (userProfile.value.isEmpty && _pickedImage == null) {
          Get.snackbar("Error", "Please pick an image");
          isLoading.value = false;
          setState(() {});
          return;
        } else if (_pickedImage != null) {
          url = await uploadToStorage(_pickedImage!, "Teams", user.uid);
        }
        Map<String, dynamic> userData = {
          'name': _teamNameController.text,
          "id": user.uid,
          "logo": url ?? userProfile.value["logo"],
          // Add more fields as needed
        };
        try {
          // Update the profile data in Firestore
          await FirebaseFirestore.instance
              .collection('Teams')
              .doc(user.uid)
              .set(userData);
          var profile = await FirebaseFirestore.instance
              .collection("Teams")
              .where("uid", isEqualTo: user.uid)
              .get();
          if (profile.docs.isNotEmpty) {
            userProfile.value = profile.docs.first.data();
          }
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Profile Updated"),
                content: const Text("Profile updated successfully!"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        } catch (e) {
          Get.snackbar("Error", e.toString());
        } finally {
          isLoading.value = false;
          setState(() {});
        }
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Oops"),
              content: const Text(
                  "Please accept Terms and Conditions and fill all details"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      }

      isLoading.value = false;
      setState(() {});
    }
  }

  Future<String> uploadToStorage(
      Uint8List image, String collection, String id) async {
    var ref = FirebaseStorage.instance.ref().child(collection).child(id);
    final metadata = SettableMetadata(contentType: "image/jpeg");
    UploadTask uploadTask = ref.putData(image, metadata);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> pickImage() async {
    final XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      // showSnackbar("Image picked", context);
      _pickedImage = await pickedImage.readAsBytes();
      setState(() {});
    } else {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text("Please pick an image")));
      if (userProfile.value.isEmpty)
        Get.snackbar("Warning", "Please pick an image");
    }
  }

  @override
  void dispose() {
    // Clean up the TextEditingController
    _teamNameController.dispose();
    super.dispose();
  }
}
