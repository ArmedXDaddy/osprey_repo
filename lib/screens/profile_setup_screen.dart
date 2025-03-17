import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:osprey_app/screens/home2_screen.dart';
import 'package:osprey_app/screens/verification_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  final String uid;
  final String userType;
  final bool isEditing;

  const ProfileSetupScreen({super.key, required this.uid, required this.userType, this.isEditing = false});

  @override
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  final TextEditingController bioController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController specializationController = TextEditingController();
  final TextEditingController availabilityController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController stageNameController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController industryController = TextEditingController();

  List<String> certifications = [];
  List<String> interests = [];
  List<String> achievements = [];
  List<String> verificationDocs = [];
  String? profilePicUrl;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _loadProfileData();
    }
  }

  // 🔹 Load existing profile data if editing
  Future<void> _loadProfileData() async {
    DocumentSnapshot profileDoc =
        await firestore.collection('profiles').doc(widget.uid).get();
    if (profileDoc.exists) {
      Map<String, dynamic>? profile = profileDoc.data() as Map<String, dynamic>?;

      if (profile != null) {
        setState(() {
          bioController.text = profile['bio'] ?? "";
          locationController.text = profile['location'] ?? "";
          websiteController.text = profile['website'] ?? "";
          specializationController.text = profile['specialization'] ?? "";
          availabilityController.text = profile['availability'] ?? "";
          experienceController.text = profile['experienceLevel'] ?? "";
          categoryController.text = profile['category'] ?? "";
          stageNameController.text = profile['stageName'] ?? "";
          companyNameController.text = profile['companyName'] ?? "";
          industryController.text = profile['industry'] ?? "";
          profilePicUrl = profile['profilePicUrl'] ?? "";
          certifications = List<String>.from(profile['certifications'] ?? []);
          interests = List<String>.from(profile['interests'] ?? []);
          achievements = List<String>.from(profile['achievements'] ?? []);
          verificationDocs = List<String>.from(profile['verificationDocs'] ?? []);
        });
      }
    }
  }

  // 🔹 Upload Profile Picture
  Future<void> _pickProfilePicture() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File profileFile = File(result.files.single.path!);
      String fileName = result.files.single.name;
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref('profile_pictures/${widget.uid}/$fileName')
          .putFile(profileFile);
      String downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        profilePicUrl = downloadUrl;
      });
    }
  }

  // 🔹 Upload Verification Docs (Only for verified roles)
  Future<void> _pickDocuments() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      List<String> docUrls = [];
      for (var file in result.files) {
        File docFile = File(file.path!);
        String fileName = file.name;
        TaskSnapshot snapshot = await FirebaseStorage.instance
            .ref('verification_docs/${widget.uid}/$fileName')
            .putFile(docFile);
        String downloadUrl = await snapshot.ref.getDownloadURL();
        docUrls.add(downloadUrl);
      }
      setState(() {
        verificationDocs = docUrls;
      });
    }
  }

  // 🔹 Submit Profile Data
  Future<void> _submitProfile() async {
    setState(() => isLoading = true);

    Map<String, dynamic> profileData = {
      'bio': bioController.text.trim(),
      'location': locationController.text.trim(),
      'website': websiteController.text.trim(),
      'profilePicUrl': profilePicUrl ?? "",
      'socialLinks': {
        'instagram': "",
        'linkedin': "",
        'twitter': "",
      },
    };

    // 🔹 Add fields based on user type
    if (widget.userType == "Trainee/Coach") {
      profileData.addAll({
        'certifications': certifications,
        'specialization': specializationController.text.trim(),
        'availability': availabilityController.text.trim(),
        'experienceLevel': experienceController.text.trim(),
      });
    } else if (widget.userType == "Athlete/Influencer/Celebrity") {
      profileData.addAll({
        'achievements': achievements,
        'category': categoryController.text.trim(),
        'followersCount': 0,
        'stageName': stageNameController.text.trim(),
      });
    } else if (widget.userType == "Company/Promoter/Sponsor") {
      profileData.addAll({
        'companyName': companyNameController.text.trim(),
        'industry': industryController.text.trim(),
      });
    }

    // ✅ Store Profile in Firestore
    await firestore.collection('profiles').doc(widget.uid).set(profileData, SetOptions(merge: true));

    setState(() => isLoading = false);

    // ✅ Redirect based on verification needs
    DocumentSnapshot userDoc = await firestore.collection('users').doc(widget.uid).get();
    bool needsVerification = userDoc.exists ? userDoc['needsVerification'] ?? false : false;

    if (needsVerification) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => VerificationScreen(uid: widget.uid)),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(uid: widget.uid, userType: widget.userType)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complete Your Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickProfilePicture,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: profilePicUrl != null ? NetworkImage(profilePicUrl!) : null,
                child: profilePicUrl == null ? const Icon(Icons.camera_alt, size: 40) : null,
              ),
            ),
            const SizedBox(height: 20),
            TextField(controller: bioController, decoration: const InputDecoration(labelText: "Short Bio")),
            TextField(controller: locationController, decoration: const InputDecoration(labelText: "Location")),
            TextField(controller: websiteController, decoration: const InputDecoration(labelText: "Website")),

            if (widget.userType == "Company/Promoter/Sponsor") ...[
              TextField(controller: companyNameController, decoration: const InputDecoration(labelText: "Company Name")),
              TextField(controller: industryController, decoration: const InputDecoration(labelText: "Industry")),
            ],

            if (widget.userType != "User/Follower") ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickDocuments,
                child: const Text("Upload Verification Documents"),
              ),
            ],

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : _submitProfile,
              child: isLoading ? const CircularProgressIndicator() : const Text("Save & Continue"),
            ),
          ],
        ),
      ),
    );
  }
}
