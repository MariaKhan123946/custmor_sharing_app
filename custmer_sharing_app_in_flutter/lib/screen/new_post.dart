import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewPostScreen extends StatelessWidget {
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _captionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _imageUrlController,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _captionController,
              decoration: InputDecoration(labelText: 'Caption'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement logic to add new post to Firestore
                FirebaseFirestore.instance.collection('posts').add({
                  'profileImageUrl': 'images/img_12.png', // Replace with actual path or URL
                  'name': 'John Doe',
                  'location': 'New York',
                  'startTime': '10:00 AM',
                  'endTime': '1:00 PM',
                  'postTime': '10:30 AM',
                  'postImageUrl': _imageUrlController.text.trim(), // Use user-provided URL
                  'caption': _captionController.text.trim(), // Use user-provided caption
                }).then((value) {
                  Navigator.pop(context); // Return to previous screen after adding post
                }).catchError((error) => print("Failed to add post: $error"));
              },
              child: Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
}
