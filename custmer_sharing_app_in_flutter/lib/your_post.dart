import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class yourPostScreen extends StatefulWidget {
  @override
  _yourPostScreenState createState() => _yourPostScreenState();
}

class _yourPostScreenState extends State<yourPostScreen> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  TimeOfDay? _fromTime;
  TimeOfDay? _untilTime;
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}.png';
      var ref = FirebaseStorage.instance.ref().child(fileName);
      var uploadTask = ref.putFile(image);

      // Waiting for the task to complete
      var taskSnapshot = await uploadTask.whenComplete(() => {});

      // Get the URL of the uploaded image
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      print('Upload successful, download URL: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _post() async {
    String location = _locationController.text.trim();
    String date = _dateController.text.trim();
    if (location.isEmpty || date.isEmpty || _fromTime == null || _untilTime == null || _image == null) {
      // Handle empty fields
      print('Please fill all the fields and select an image');
      return;
    }

    String? imageUrl = await _uploadImage(_image!);

    if (imageUrl == null) {
      // Handle image upload failure
      print('Image upload failed');
      return;
    }

    await FirebaseFirestore.instance.collection('post').add({
      'location': location,
      'date': date,
      'fromTime': _fromTime!.format(context),
      'untilTime': _untilTime!.format(context),
      'imageUrl': imageUrl,
    });

    // Clear fields
    _locationController.clear();
    _dateController.clear();
    setState(() {
      _fromTime = null;
      _untilTime = null;
      _image = null;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Post created successfully')));
  }

  Future<void> _selectTime(BuildContext context, bool isFrom) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != (isFrom ? _fromTime : _untilTime)) {
      setState(() {
        if (isFrom) {
          _fromTime = picked;
        } else {
          _untilTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Image.asset('images/img_17.png',height: 20,), // Replace with the actual path
          onPressed: () {},
        ),
        title: Center( child: Text('Where are you going?',style: TextStyle(color: Colors.black),)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Location: Example Starbucks on 3rd floor of conference center'),
              TextField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10.0),
              Text('Date',style: TextStyle(color: Colors.black,),),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
                    });
                  }
                },
              ),
              SizedBox(height: 16.0),
              Text('Set time',style: TextStyle(color: Colors.black),),
              Column(
                children: [
                    Row(
                      children: [
                        Text("From:"),
                        SizedBox(width: 30,),
                        Container(
                              width: 250,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(

                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color: Colors.black)
                              ),
                              child: GestureDetector(
                                onTap: () => _selectTime(context, true),
                                child: Text(_fromTime != null ? _fromTime!.format(context) : 'Select Time'),
                              ),
                            ),
                      ],
                    ),
                      SizedBox(height: 20,),
                        Row(
                          children: [
                            Text("Util:"),
                            SizedBox(width: 40,),
                            Container(
                            width: 250,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(

                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color: Colors.black)
                            ),
                            child: GestureDetector(
                              onTap: () => _selectTime(context, false),
                              child: Text(_untilTime != null ? _untilTime!.format(context) : 'Select Time'),
                            ),
                                                  ),
                          ],
                        ),
                    ],
                  ),


              SizedBox(height: 16.0),
              GestureDetector(
                onTap: _pickImage,
                child: Center(
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Color(0xffD9D9D9),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: _image != null
                        ? Image.file(_image!, fit: BoxFit.cover)
                        : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt, color: Color(0xff000000),size: 40,),
                        Text(
                          'Snap a quick photo so that it\'s easy to find you',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Center(
                child: GestureDetector(
                  onTap: _post,
                  child: Container(
                    width: 290,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xff5F2D9C),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      'Post',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  ),
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
}
