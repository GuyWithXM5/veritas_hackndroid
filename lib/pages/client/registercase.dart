import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:veritasapp/Widgets/bottomnavigation.dart';
import 'package:file_picker/file_picker.dart';


class regcase extends StatefulWidget {
  const regcase({super.key});

  @override
  _regcaseState createState() => _regcaseState();
}

class _regcaseState extends State<regcase> {
  String? _selectedOption;
  bool? _isChecked = false;

  final TextEditingController _locationCont = TextEditingController();
  final TextEditingController _dateCont = TextEditingController();
  final TextEditingController _descriptionCont = TextEditingController();

  String? downloadURL;

Future<void> _filepicker() async {
  try {
    // Get App Check token
    final appCheckToken = await FirebaseAppCheck.instance.getToken();
    print('App Check Token: $appCheckToken');
    await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true);

    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      String fileName = result.files.single.name;

      // ✅ Ensure FirebaseStorage instance is initialized properly
      final FirebaseStorage storage = FirebaseStorage.instance;

      // ✅ Create a reference to the file location in Firebase Storage
      Reference storageRef = storage.ref().child(
          'case_files/${FirebaseAuth.instance.currentUser!.uid}/$fileName');

      // ✅ Upload file to Firebase Storage with App Check token
      UploadTask uploadTask = storageRef.putFile(file);
      TaskSnapshot snapshot = await uploadTask;

      // ✅ Get the download URL after successful upload
      String downloadURL = await snapshot.ref.getDownloadURL();

      // Optionally, you can save the file information to Firestore here
      // final user = FirebaseAuth.instance.currentUser;
      // await FirebaseFirestore.instance
      //     .collection("Registerted_Cases(non-assigned)")
      //     .doc(user!.uid)
      //     .collection("Cases")
      //     .add({
      //   "fileURL": downloadURL,
      //   "fileName": fileName,
      //   "uploadedAt": FieldValue.serverTimestamp(),
      // });

      print("✅ File uploaded successfully: $downloadURL");

      // Display success message using a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("File uploaded successfully!")),
      );
    } else {
      print("⚠️ No file selected.");
    }
  } catch (e) {
    print("❌ Error picking or uploading file: $e");

    // Display error message using a SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error uploading file. Please try again.")),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register a Case",
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),),
        backgroundColor: Color.fromRGBO(132, 189, 255, 1),
      ),
      backgroundColor: const Color.fromRGBO(132, 189, 255, 1),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20), // Vertical space
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  21, 40, 21, 0), // Left and right padding
              child: Container(
                height: 65,
                width: 353,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 10), // Spacing
                    Text(
                      'Type of case: ',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white, // Text color set to white
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            icon: Icon(Icons.keyboard_arrow_down,
                                color: Colors.white), // Custom dropdown icon
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            value: _selectedOption,
                            dropdownColor: Colors.black, // Dropdown box color
                            items: <String>[
                              'Civil',
                              'Labor',
                              'Family',
                              'Cooperative',
                              'Consumer forum',
                              'Other',
                            ].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    value,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                _selectedOption = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20), // Additional vertical space
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  21, 20, 21, 0), // Left and right padding
              child: Container(
                height: 65,
                width: 353,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  controller: _locationCont,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Location',
                    hintStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // Additional vertical space
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  21, 20, 21, 0), // Left and right padding
              child: Container(
                height: 65,
                width: 353,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  controller: _dateCont,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Approximate Date',
                    hintStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // Additional vertical space
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  21, 20, 21, 0), // Left and right padding
              child: Container(
                height: 65,
                width: 353,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  controller: _descriptionCont,
                  maxLines: 3,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Briefly describe your case here',
                    hintStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // Additional vertical space
            GestureDetector(
              onTap: (){
                _filepicker();
              },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  20, 20, 20, 0), // Left and right padding
              child: Container(
                height: 65,
                width: 353,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 72,
                      height: 72,
                      child: Image.asset(
                          'assets/images/Folder-pana 1.png'), // Replace 'your_image.png' with your image asset path
                    ),
                    SizedBox(width: 10), // Spacing between image and text
                    Text(
                      'Upload files regarding the case',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black.withOpacity(0.6), // lighter color
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),),
            SizedBox(height: 20), // Additional vertical space
            Padding(
              padding:
                  EdgeInsets.fromLTRB(20, 20, 20, 0), // Left and right padding
              child: Container(
                height: 65,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius:
                      BorderRadius.circular(30), // Border radius set to 15
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: _isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked = value;
                        });
                      },
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8), // Adjust left padding
                        child: Text(
                          'I certify that the above facts are true to the best of my knowledge.',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20), // Additional vertical space
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  20, 0, 20, 0), // Left and right padding
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  backgroundColor: Colors.black,
                ),
                onPressed: () {
                  if (_selectedOption!.isNotEmpty &&
                      _locationCont.text.trim().isNotEmpty &&
                      _dateCont.text.trim().isNotEmpty &&
                      _descriptionCont.text.trim().isNotEmpty) {
                    final user = FirebaseAuth.instance.currentUser;
                    FirebaseFirestore.instance
                        .collection("regcase")
                        .doc()
                        .collection("Cases")
                        .add({
                          "uid": user?.uid,
                          "clientName": user?.displayName,
                          "clientEmail": user?.email,
                          "caseType": _selectedOption,
                          "location": _locationCont.text.trim(),
                          "date": _dateCont.text.trim(),
                          "fileURL": downloadURL,
                          "briefing": _descriptionCont.text.trim(),
                        })
                        .then((value) => ScaffoldMessenger.of(context)
                            .showSnackBar(
                                SnackBar(content: Text("Case registered."))))
                        .catchError((error) => ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(
                                content: Text("!!Try again later!!"))));
                    _locationCont.clear();
                    _dateCont.clear();
                    _descriptionCont.clear();
                    // _isChecked = false;
                    // _selectedOption = null;
                    Navigator.pushNamed(context, "/selectlawyer");
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Please answer all the fields.")));
                  }
                },
                child: SizedBox(
                  height: 65,
                  width: 353,
                  child: Center(
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 100,
            )
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationDabba(
        index: 0,
        onTap: (index) {
          if(index==0){
            Navigator.pop(context);
          }
          // print("Selected Index: $index");
        },
        backgroundColor: Colors.grey[200]!,
        buttonColor: Colors.black,
        icons: [Icons.home, Icons.file_copy, Icons.payment],
      ),
    );
  }
}
