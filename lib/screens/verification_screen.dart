import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerificationScreen extends StatefulWidget {
  final String uid;

  const VerificationScreen({super.key, required this.uid});

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  List<String> verificationDocs = [];
  bool isSubmitting = false;

  Future<void> _uploadDocuments() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        verificationDocs = result.files.map((file) => file.name).toList();
      });
    }
  }

  Future<void> _submitVerification() async {
    setState(() => isSubmitting = true);

    await FirebaseFirestore.instance.collection('verification_requests').doc(widget.uid).set({
      'uid': widget.uid,
      'email': FirebaseAuth.instance.currentUser!.email,
      'status': "Pending",
      'submittedAt': Timestamp.now(),
      'verificationDocs': verificationDocs,
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Verification request submitted!")));

    setState(() => isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verification Required")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("Upload documents for verification", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            verificationDocs.isEmpty
                ? const Text("No documents selected", style: TextStyle(color: Colors.grey))
                : Column(children: verificationDocs.map((doc) => Text(doc)).toList()),
            const SizedBox(height: 15),
            ElevatedButton(onPressed: _uploadDocuments, child: const Text("Upload Documents")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isSubmitting ? null : _submitVerification,
              child: isSubmitting ? const CircularProgressIndicator() : const Text("Submit for Verification"),
            ),
          ],
        ),
      ),
    );
  }
}
