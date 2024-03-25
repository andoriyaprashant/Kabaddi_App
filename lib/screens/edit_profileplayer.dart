import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kabadi/constants.dart';
import 'package:kabadi/screens/custom_textform.dart';

class EditPlayerProfilePage extends StatelessWidget {
  const EditPlayerProfilePage({Key? key}) : super(key: key);

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
                "Edit Player Profile",
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
          child: EditPlayerProfileForm(),
        ),
      ),
    );
  }
}

class EditPlayerProfileForm extends StatefulWidget {
  const EditPlayerProfileForm({Key? key}) : super(key: key);

  @override
  _EditPlayerProfileFormState createState() => _EditPlayerProfileFormState();
}

class _EditPlayerProfileFormState extends State<EditPlayerProfileForm> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _aboutController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _jerseyController = TextEditingController();
  TextEditingController _pointsController = TextEditingController();
  TextEditingController _positionController = TextEditingController();
  TextEditingController _teamController = TextEditingController();
  TextEditingController _matchesController = TextEditingController();
  bool _isChecked = false;
  Uint8List? _pickedImage;

  Rx<List<Map<String, String>>> teamList = Rx<List<Map<String, String>>>([]);
  Rx<bool> isTeamLoading = false.obs;
  Rx<bool> isLoading = false.obs;

  final _formKey = GlobalKey<FormState>();

  Future<List<Map<String, String>>> getTeamDetails() async {
    try {
      isTeamLoading.value = true;
      var teams = await FirebaseFirestore.instance.collection("Teams").get();
      List<Map<String, String>> teamList = [];

      teams.docs.forEach((doc) {
        var teamData = doc.data();
        var teamDetails = {
          'logo': teamData['logo'] as String,
          'name': teamData['name'] as String,
        };
        teamList.add(teamDetails);
      });

      return teamList;
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return [];
    } finally {
      isTeamLoading.value = false;
    }
  }

  getTeams() async {
    var teamListtemp = await getTeamDetails();
    teamList.value.addAll(teamListtemp);
    teamList.refresh();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTeams();
    print(userProfile.value);
    if (userProfile.value.isNotEmpty) {
      _nameController.text = userProfile.value["name"];
      _aboutController.text = userProfile.value["about"];
      _ageController.text = userProfile.value["age"].toString();
      _jerseyController.text = userProfile.value["jerseyNo"].toString();
      _pointsController.text = userProfile.value["points"].toString();
      _positionController.text = userProfile.value["position"];
      _teamController.text = userProfile.value["teamName"];
      _matchesController.text = userProfile.value["matchesPlayed"].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return isTeamLoading.value
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
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
                                    : NetworkImage(
                                            userProfile.value["imageUrl"])
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
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextFormField(
                                  controller: _nameController,
                                  heading: "Player Name",
                                  hintText: "Enter name",
                                  keyboardType: TextInputType.name,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: CustomTextFormField(
                                  controller: _ageController,
                                  heading: "Player Age",
                                  hintText: "Enter age",
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextFormField(
                                  controller: _jerseyController,
                                  heading: "Jersey Number",
                                  hintText: "Enter jersey no",
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: CustomTextFormField(
                                  controller: _matchesController,
                                  heading: "Matches Played",
                                  hintText: "Enter matches",
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextFormField(
                                  controller: _pointsController,
                                  heading: "Points Scored",
                                  hintText: "Enter points",
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: CustomTextFormField(
                                  controller: _positionController,
                                  heading: "Playing Position",
                                  hintText: "Enter position",
                                  keyboardType: TextInputType.name,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          DropdownMenu(
                            onSelected: (value) {
                              _teamController.text = value!;
                            },
                            initialSelection: _teamController.text,
                            dropdownMenuEntries: teamList.value.map((e) {
                              return DropdownMenuEntry(
                                  value: e['name'], label: e['name']!);
                            }).toList(),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextFormField(
                            controller: _aboutController,
                            heading: "About",
                            hintText: "Player description",
                            keyboardType: TextInputType.name,
                            maxLength: 500,
                            maxLines: 10,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
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
                            isLoading.value = false;
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
        if (_teamController.text.trim() == "") {
          Get.snackbar("Error", "Please select a team");
          setState(() {
            isLoading.value = false;
          });
          return;
        }
        var url;
        if (userProfile.value.isEmpty && _pickedImage == null) {
          Get.snackbar("Error", "Please pick an image");
          isLoading.value = false;
          setState(() {});
          return;
        } else if (_pickedImage != null) {
          url = await uploadToStorage(_pickedImage!, "Players", user.uid);
        }
        int age, jerseyNo, matches, points;
        try {
          age = int.parse(_ageController.text);
          jerseyNo = int.parse(_jerseyController.text);
          matches = int.parse(_matchesController.text);
          points = int.parse(_pointsController.text);
        } catch (e) {
          Get.snackbar("Error", "please enter a number");
          setState(() {
            isLoading.value = false;
          });
          return;
        }
        Map<String, dynamic> userData = {
          "about": _aboutController.text,
          "name": _nameController.text,
          "imageUrl": url ?? userProfile.value["imageUrl"],
          "age": age,
          "jerseyNo": jerseyNo,
          "points": points,
          "position": _positionController.text,
          "teamName": _teamController.text,
          "matchesPlayed": matches,
          "id": user.uid
        };
        try {
          // Update the profile data in Firestore
          await FirebaseFirestore.instance
              .collection('Players')
              .doc(user.uid)
              .set(userData);
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
          var profile = await FirebaseFirestore.instance
              .collection("Players")
              .where("uid", isEqualTo: user.uid)
              .get();
          if (profile.docs.isNotEmpty) {
            userProfile.value = profile.docs.first.data();
          }
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
    super.dispose();
  }
}
