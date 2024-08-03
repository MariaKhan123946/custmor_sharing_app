import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AddBlogPage extends StatefulWidget {
  @override
  _AddBlogPageState createState() => _AddBlogPageState();
}

class _AddBlogPageState extends State<AddBlogPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference().child("Blogs");

  void _addBlog() {
    String title = _titleController.text;
    String description = _descriptionController.text;
    String image = _imageController.text;

    Map<String, String> blog = {
      "title": title,
      "desc": description,
      "image": image,
    };

    _databaseReference.push().set(blog).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Blog added successfully')),
      );
      _titleController.clear();
      _descriptionController.clear();
      _imageController.clear();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add blog')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Blog"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: "Description"),
            ),
            TextField(
              controller: _imageController,
              decoration: InputDecoration(labelText: "Image URL"),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _addBlog,
              child: Text("Add Blog"),
            ),
          ],
        ),
      ),
    );
  }
}
